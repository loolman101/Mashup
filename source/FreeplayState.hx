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

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = ['Spaceroom', 'Autumn', 'Leaf-Decay', 'Corruption', 'Dread'];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var fullComboCoin:FlxSprite;

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

	/*	if (StoryMenuState.weekUnlocked[2] || isDebug)
		{
			songs.push('Musical-Genius');
			songs.push('Virginity');
		}

		if (StoryMenuState.weekUnlocked[3] || isDebug)
		{
			songs.push('Autumn');
			songs.push('Leaf-Decay');
			songs.push('Corruption');
		}

		if (StoryMenuState.weekUnlocked[4] || isDebug)
		{
			songs.push('Blammer');
		}

		if (StoryMenuState.weekUnlocked[5] || isDebug)
		{
			songs.push('Cocoa');
			songs.push('Eggnog');
			songs.push('Winter-Horrorland');
		}   

		if (StoryMenuState.weekUnlocked[6] || isDebug)
		{
			songs.push('Senpai');
			songs.push('Roses');
			songs.push('Thorns');
			// songs.push('Winter-Horrorland');
		}     */ 

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBGBlue.png');
		add(bg);

		fullComboCoin = new FlxSprite(830, 270);
		fullComboCoin.frames = FlxAtlasFrames.fromSparrow('assets/images/fullCombo.png', 'assets/images/fullCombo.xml');
		fullComboCoin.animation.addByPrefix('idle', 'Shiny', 24, true);
		fullComboCoin.animation.play('idle');
		fullComboCoin.setGraphicSize(Std.int(fullComboCoin.width / 1.5));
		fullComboCoin.updateHitbox();
		add(fullComboCoin);
		fullComboCoin.visible = false;

		grpSongs = new FlxTypedGroup<Sussy>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var coolSongName:Sussy = new Sussy(30, 260 + (100 * i), songs[i].toLowerCase(), i);
			grpSongs.add(coolSongName);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

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

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

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

		for (item in grpSongs.members)
		{
			var lastY = item.y;
			var trueWidth = item.width;
			var daY = 260 + ((bullShit - curSelected) * 100);
			var scaledY = FlxMath.remapToRange(daY, 0, 1, 0, 1.3);
			FlxTween.tween(item, {y: daY}, 0.1);

			bullShit++;

			//item.setGraphicSize(Std.int((bullShit - curSelected) * trueWidth));

			item.intednedSize = item.size *  (1 - (Math.abs(item.index - curSelected) * 0.4));
			trace(Std.string(item.index) + ' ' + Std.string(item.intednedSize));
			trace(Std.string(item.index) + ' ' + Std.string(Std.int(FlxMath.lerp(item.size, item.intednedSize, 0.5))));

			//item.setGraphicSize(Std.int((Math.abs(bullShit - curSelected)) * -1));

			item.alpha = 0.6 - (Math.abs(item.index - curSelected) * 0.15);
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.index == curSelected)
			{
				item.alpha = 1;
				item.intednedSize = item.size;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
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
		if (width != intednedSize)
			setGraphicSize(Std.int(FlxMath.lerp(width, intednedSize, 0.5)));
		//updateHitbox();*/
		super.update(elapsed);
	}
}