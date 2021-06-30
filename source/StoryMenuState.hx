package;

import flixel.FlxG;
import Song.SwagSong;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.atlas.FlxAtlas;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Ardyssey'],
		['Autumn', 'Leaf-Decay', "Corruption", 'Dread'],
		['Fear-the-Funk']
	];
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true];
	public static var weekMisses:Int = 0;

	/*var weekSuckers:Array<String> = [
		'vanus',
		'theo'
	];*/

	var weekSongs:Array<String> = [
		'Ardyssey',
		'Leaf-Decay',
		'Fear-the-Funk'
	];

	var weekNames:Array<String> = [
		"LEFT UP DOWN RIGHT",
		"SMELLS LIKE LEMONS",
		"FAMILY SIZED BAG OF CHIPS"
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var theYoMamaYTChannel:FlxTypedGroup<FlxSprite>;
	var sopar:FlxSprite;
	var fnfNeo:FlxSprite;
	var junking:FlxSprite;
	var babish:FlxSprite;
	//var yellowBG:FlxSprite;
	var allThemBackgrounds:FlxTypedGroup<FlxSprite>;
	var bgSize:Int = 0;

	var fullComboCoin:FlxSprite;

	var stupidArray:Array<Float> = [];

	override function create()
	{
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		persistentUpdate = persistentDraw = true;

		DiscordJunk.change('In Menus');

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32, FlxColor.BLACK);

		txtWeekTitle = new FlxText(330, 70, 0, "", 78);
		txtWeekTitle.setFormat("assets/fonts/vcr.ttf", 78, FlxColor.BLACK);
		txtWeekTitle.screenCenter(X);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat("assets/fonts/vcr.ttf", 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');

		allThemBackgrounds = new FlxTypedGroup<FlxSprite>();
		add(allThemBackgrounds);	

		trace('A A MONG US A A  AAAA MONG US US');

		grpWeekText = new FlxTypedGroup<MenuItem>();
		//add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var songBG:FlxSprite = new FlxSprite(1280 * i).loadGraphic('assets/images/storyMenu/art/$i.png');
			songBG.ID = i;
			songBG.setGraphicSize(FlxG.width, FlxG.height);
			songBG.updateHitbox();
			songBG.antialiasing = true;
			allThemBackgrounds.add(songBG);

			var weekThing:MenuItem = new MenuItem(0, 720 + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		Conductor.changeBPM(Song.loadFromJson(weekSongs[curWeek]).bpm);

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		//add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite();
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');

		//rightArrow.x = 895;
		trace("Line 150");
		rightArrow.y -= rightArrow.height / 2;
		leftArrow.y -= leftArrow.height / 2;

		rightArrow.screenCenter();
		leftArrow.screenCenter();

		leftArrow.x -= FlxG.width / 2.5;
		rightArrow.x += FlxG.width / 2;

		//add(yellowBG);
		add(grpWeekCharacters);

		add(rightArrow);
		add(leftArrow);

		theYoMamaYTChannel = new FlxTypedGroup<FlxSprite>();
		add(theYoMamaYTChannel);

		for (i in 0...weekData.length)
		{
			var weekThingy:FlxSprite = new FlxSprite().loadGraphic('assets/images/storyMenu/titles/$i.png');
			weekThingy.screenCenter();
			stupidArray.push(weekThingy.x);
			weekThingy.x += 1280 * i;
			weekThingy.ID = i;
			switch (i)
			{
				case 1:
					weekThingy.setGraphicSize(Std.int(weekThingy.width * 0.45));
			}
			theYoMamaYTChannel.add(weekThingy);
		}

		

	/*	fnfNeo = new FlxSprite(973, 160);
		fnfNeo.frames = FlxAtlasFrames.fromSparrow('assets/images/weeks.png', 'assets/images/weeks.xml');
		fnfNeo.animation.addByPrefix('anim-1', 'blank', 24, false);
		fnfNeo.animation.addByPrefix('anim0', 'tutorial', 24, false);
		fnfNeo.animation.addByPrefix('anim1', 'WEEK1', 24, false);
		fnfNeo.animation.addByPrefix('anim2', 'blank', 24, false);
		fnfNeo.animation.play('anim0');
		add(fnfNeo);

		junking = new FlxSprite(-90, 160);
		junking.frames = FlxAtlasFrames.fromSparrow('assets/images/weeks.png', 'assets/images/weeks.xml');
		junking.animation.addByPrefix('anim-1', 'blank', 24, false);
		junking.animation.addByPrefix('anim0', 'tutorial', 24, false);
		junking.animation.addByPrefix('anim1', 'WEEK1', 24, false);
		junking.animation.addByPrefix('anim2', 'blank', 24, false);
		junking.animation.play('anim0');
		add(junking);*/

		//junking.alpha = 0.5;
		//fnfNeo.alpha =  0.5;

	/*	babish = new FlxSprite(845, 264);
		babish.frames = FlxAtlasFrames.fromSparrow('assets/images/storyMenuSuckers.png', 'assets/images/storyMenuSuckers.xml');
		babish.animation.addByPrefix('idle', 'BF idle dance', 24, true);
		babish.animation.addByPrefix('confirm', 'BF HEY!!', 24, false);
		babish.animation.play('idle');
		add(babish);

		sopar = new FlxSprite(121, 265);
		sopar.frames = FlxAtlasFrames.fromSparrow('assets/images/storyMenuSuckers.png', 'assets/images/storyMenuSuckers.xml');
		sopar.animation.addByPrefix('vanus', 'vanus no speakers', 24, true);
		sopar.animation.addByPrefix('theo', 'theo idle', 24, true);
		sopar.animation.addByPrefix('theo-confirm', 'theo right', 24, false);
		sopar.animation.play('vanus');
		add(sopar);*/

		fullComboCoin = new FlxSprite(1030, 20);
		fullComboCoin.frames = FlxAtlasFrames.fromSparrow('assets/images/fullCombo.png', 'assets/images/fullCombo.xml');
		fullComboCoin.animation.addByPrefix('idle', 'Shiny', 24, true);
		fullComboCoin.animation.play('idle');
		fullComboCoin.setGraphicSize(Std.int(fullComboCoin.width / 3.2));
		fullComboCoin.updateHitbox();
		add(fullComboCoin);
		fullComboCoin.visible = false;

		txtTracklist = new FlxText(0, FlxG.height - 50, 0, "Tracks", 50);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFF000000;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		FlxG.sound.playMusic('assets/music/' + weekSongs[curWeek] + '_Inst.ogg', 0);

		super.create();
	}

	override function beatHit()
	{
		super.beatHit();
		Conductor.changeBPM(Song.loadFromJson(weekSongs[curWeek], weekSongs[curWeek]).bpm);
		//bgSize = Std.int(yellowBG.width + 30);
		//trace(bgSize);
		FlxG.log.add('Beat Hit');
	}

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		//txtWeekTitle.x = (FlxG.width / 2) + (txtWeekTitle.width / 2);
		txtWeekTitle.screenCenter(X);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		//fnfNeo.animation.play('anim' + (curWeek + 1), true);
		//junking.animation.play('anim' + (curWeek - 1), true);

		/*if (bgSize > 1280)
		{
			bgSize -= 5;
			yellowBG.setGraphicSize(bgSize);
		}*/
		//if (!selectedWeek)
			//sopar.animation.play(weekSuckers[curWeek], false);

		// FlxG.watch.addQuick('font', scoreText.font);

		txtTracklist.y = FlxG.height - txtTracklist.height;

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					changeWeek(-1);
				}

				if (controls.RIGHT_P)
				{
					changeWeek(1);
				}

				if (FlxG.keys.justPressed.NINE)
					FlxG.log.add(Conductor.songPosition);

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play('assets/sounds/cancelMenu' + TitleState.soundExt);
			movedBack = true;
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

				//grpWeekText.members[curWeek].week.animation.resume();
				//grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			//sopar.animation.play(weekSuckers[curWeek] + '-confirm', true);
			//babish.animation.play('confirm');

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.isBonusSong = false;
			PlayState.campaignScore = 0;
			theYoMamaYTChannel.forEach(function(spr:FlxSprite){
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();
					FlxG.switchState(new PlayState());
				});
			});
			
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty = 1;


		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		//yellowBG.loadGraphic('assets/images/storymenu_' + weekBG[curWeek] + '.png'); 

		allThemBackgrounds.forEach(function(spr:FlxSprite){
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {x: 1280 * (spr.ID - curWeek)}, 0.4, {ease: FlxEase.quintOut});
		});

		theYoMamaYTChannel.forEach(function(spr:FlxSprite){
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {x: stupidArray[spr.ID] + 1280 * (spr.ID - curWeek)}, 0.3, {ease: FlxEase.quintOut});
		});

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		updateText();

		FlxG.sound.playMusic('assets/music/' + weekSongs[curWeek] + '_Inst.ogg', 0);
		Conductor.changeBPM(Song.loadFromJson(weekSongs[curWeek], weekSongs[curWeek]).bpm);
		Conductor.songPosition = 0;
		FlxG.log.add('change bpm' + Song.loadFromJson(weekSongs[curWeek], weekSongs[curWeek]).bpm);
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek];

		/*if (theYoMamaYTChannel.animation.curAnim.name == 'anim0')
			rightArrow.x = (FlxG.width / 2 + (theYoMamaYTChannel.width / 2)) + 30;
		else
			rightArrow.x = (FlxG.width / 2 + (theYoMamaYTChannel.width / 2)) + 75;*/
		
		//trace(rightArrow.x);

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		//txtTracklist.screenCenter(X);
		//txtTracklist.x -= txtTracklist.width;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
