package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = ['Ardyssey', 'Autumn', 'Leaf-Decay', 'Corruption', 'Dread', 'Fear-the-Funk'];
	var songChars:Array<String> = ['gf', 'theo', 'theo', 'theo', 'theo-lemon', 'gene'];
	var chars:FlxTypedGroup<Character>;

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var hasInitialized:Bool = false;

	var fullComboCoin:FlxSprite;

	var micdUpIRL:FlxBackdrop;

	private var grpSongs:FlxTypedGroup<Sussy>;
	private var curPlaying:Bool = false;

	override function create()
	{
		//songs = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		DiscordJunk.change('In Menus');

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		micdUpIRL = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		micdUpIRL.alpha = 0.35;
		add(micdUpIRL);

		var titleText:FlxSprite = new FlxSprite(0, 5);
		titleText.frames = FlxAtlasFrames.fromSparrow('assets/images/Freeplay_Junk.png', 'assets/images/Freeplay_Junk.xml');
		titleText.animation.addByPrefix('idle', 'story mode white', 24, true);
		titleText.animation.play('idle');
		titleText.setGraphicSize(0, 150);
		titleText.updateHitbox();
		titleText.antialiasing = true;
		titleText.screenCenter(X);
		add(titleText);

		fullComboCoin = new FlxSprite(0 -10);
		fullComboCoin.frames = FlxAtlasFrames.fromSparrow('assets/images/fullCombo.png', 'assets/images/fullCombo.xml');
		fullComboCoin.animation.addByPrefix('idle', 'Shiny', 24, true);
		fullComboCoin.animation.play('idle');
		fullComboCoin.setGraphicSize(Std.int(fullComboCoin.width * 0.3));
		fullComboCoin.updateHitbox();
		fullComboCoin.antialiasing = true;
		fullComboCoin.visible = false;

		chars = new FlxTypedGroup<Character>();
		add(chars);

		for (i in 0...songChars.length)
		{
			var songChar:Character = new Character(FlxG.width, FlxG.height, songChars[i], false, true);
			songChar.ID = i;
			songChar.visible = false;
			chars.add(songChar);
		}

		grpSongs = new FlxTypedGroup<Sussy>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var coolSongName:Sussy = new Sussy(-60, 260 + (100 * i), songs[i].toLowerCase(), i);
			grpSongs.add(coolSongName);
		}

		add(fullComboCoin);

		scoreText = new FlxText(FlxG.width * 0.7, titleText.height + 10, 0, "", 30);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 30, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		//add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		new FlxTimer().start(0.5, function(tmr:FlxTimer){
			hasInitialized = true;
			changeSelection();
			repositionCrap();
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		micdUpIRL.x -= -0.27/(120/60); // STOLEN FROM MIC'D UP LOOOL
		micdUpIRL.y -= 0.63/(120/60);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		// scoreText.x = FlxG.width - (scoreText.width * scoreText.text.length);
		scoreText.screenCenter(X);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		fullComboCoin.visible = Highscore.getSongFC(songs[curSelected]);

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.isBonusSong = false;
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}

		/*for (item in grpSongs.members)
		{
			item.y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
		}*/
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = 1;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "SLOW";
			case 1:
				diffText.text = 'FREAKY';
			case 2:
				diffText.text = "MASH";
		}
	}

	function changeSelection(change:Int = 0)
	{
	/*	#if !switch
		NGio.logEvent('Fresh');
		#end     */

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		// lerpScore = 0;
		#end

		FlxG.sound.playMusic('assets/music/' + songs[curSelected] + "_Inst" + TitleState.soundExt, 0);

		var bullShit:Int = 0;

		chars.forEach(function(spr:Character){
			if (spr.ID == curSelected)
				spr.visible = true;
			else
				spr.visible = false;
		});

		for (item in grpSongs.members)
		{
			var lastY = item.y;
			var trueWidth = item.width;
			var daY = 260 + ((bullShit - curSelected) * 100);
			var scaledY = FlxMath.remapToRange(daY, 0, 1, 0, 1.3);
			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {alpha: 0.6 - (Math.abs(item.index - curSelected) * 0.15), 
				y: daY, x: 30 - (Math.abs(item.index - curSelected) * 60), 
				'scale.x': 1 - (Math.abs(item.index - curSelected) * 0.15), 
				'scale.y': 1 - (Math.abs(item.index - curSelected) * 0.15)}, 0.2, 
				{ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){
					if (item.index == curSelected)
						item.alpha = 1;
					if (!hasInitialized)
						item.x = -600;
				}
			});

			bullShit++;
		}
	}

	function repositionCrap()
	{
		chars.forEach(function(spr:Character){
			switch (songChars[spr.ID])
			{
				case 'gf':
					spr.setGraphicSize(0, 450);
					spr.updateHitbox();
					FlxTween.tween(spr, {x: 786, y: 269}, 0.35, {ease: FlxEase.quartOut});
				case 'theo':
					spr.flipX = true;
					FlxTween.tween(spr, {x: 916, y: 332}, 0.35, {ease: FlxEase.quartOut});
				case 'gene':
					spr.setGraphicSize(0, 480);
					spr.updateHitbox();
					spr.flipX = true;
					FlxTween.tween(spr, {x: 916, y: 232}, 0.35, {ease: FlxEase.quartOut});
				case 'theo-lemon':
					spr.setGraphicSize(0, 540);
					spr.updateHitbox();
					spr.flipX = true;
					FlxTween.tween(spr, {x: 905, y: 179}, 0.35, {ease: FlxEase.quartOut});
			}
		});
	}
}

class Sussy extends FlxSprite
{
	public var index:Int;

	public var size:Float;

	public var intednedSize:Float;

	public function new(x:Int, y:Int, spire:String, index:Int)
	{	
		super(x, y);
		this.index = index;
		loadGraphic('assets/images/freeplaySongs/' + spire + '.png');
		this.size = width;
	}

	override function update(elapsed:Float)
	{
		//intednedSize = Std.int((intednedSize / 5) * width);
		//trace(intednedSize);
		/*if (width != intednedSize)
			setGraphicSize(Std.int(intednedSize));*/
		//updateHitbox();*/
		super.update(elapsed);
	}
}