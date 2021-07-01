package;

import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.effects.FlxFlicker;
import flash.display.BitmapData; // :troll:
import lime.graphics.Image; // :troll: v2

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var daThingy:Bool = false;
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var isBonusSong:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camJUNK:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var sun:FlxSprite;
	var bgCult:FlxSprite;
	var coolCutScene:FlxSprite;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var theoSticker:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var introConfirme:FlxSprite;
	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public static var songScore:Int = 0;
	public static var misses:Int = 0;
	var scoreTxt:FlxText;
	var missTxt:FlxText;

	public static var detailJunks:String;

	var warningText:FlxSprite;

	var blame:FlxSprite;

	var isCinematic:Bool = OptionsMenu.cinematicMode;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	var stupidUglyBf:Character;
	var uglyCalliope:FlxSprite;

	override public function create()
	{
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camJUNK = new FlxCamera();
		camJUNK.bgColor.alpha = 0;
		misses = 0;
		songScore = 0;

		DiscordJunk.change('About to start a song.');

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		daThingy = false;

		if (SONG.song == 'Dread')
			FlxG.cameras.add(camJUNK);

		if (isStoryMode)
			detailJunks = 'Story Mode: ';
		else if (isBonusSong)
			detailJunks = 'Bonus Song: ';
		else
			detailJunks = 'Freeplay: ';

		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile('assets/data/senpai/senpaiDialogue.txt');
			case 'roses':
				dialogue = CoolUtil.coolTextFile('assets/data/roses/rosesDialogue.txt');
			case 'thorns':
				dialogue = CoolUtil.coolTextFile('assets/data/thorns/thornsDialogue.txt');
			case 'autumn':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/autumn.txt');
			case 'leaf-decay':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/leaf-decay.txt');
			case 'corruption':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/corruption.txt');
			case 'dread':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/dread.txt');
			case 'fancy-evening':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/fancy-evening.txt');
			case 'intense-feelings':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/intense-feelings.txt');
			case 'paying-the-bill':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/paying-the-bill.txt');
			case 'blammer':
				dialogue = CoolUtil.coolTextFile('assets/data/dialogue/blammer.txt');
		}

		var spikes:FlxSprite = new FlxSprite(-340, 5);
		var mic:FlxSprite = new FlxSprite(-340, 5);

		var coolFG:FlxSprite = new FlxSprite(-339, 19);

		if (SONG.song.toLowerCase() == 'autumn' || SONG.song.toLowerCase() == 'corruption' || SONG.song.toLowerCase() == 'leaf-decay' || SONG.song.toLowerCase() == 'dread' || SONG.song.toLowerCase() == 'corruption-bsides')
		{
			curStage = 'philly';

			var daSongName:String = SONG.song.toLowerCase();

			switch (daSongName)
			{
				case 'corruption-bsides':
					daSongName = 'corruption';
			}

			if (SONG.song == 'Dread')
				daThingy = true;

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic('assets/images/theo/' + daSongName + '/sky.png');
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite;

			if (daSongName == 'dread')
			{
				bg.scrollFactor.set(0.1, 0.06);
				bg.y -= 50;

				sun = new FlxSprite(50, 150).loadGraphic('assets/images/theo/moon.png');
				sun.scrollFactor.set(0.1, 0.1);
				add(sun);

				city = new FlxSprite(-10).loadGraphic('assets/images/theo/' + daSongName + '/bg.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				bgCult =  new FlxSprite(-83, 278);
				bgCult.frames = FlxAtlasFrames.fromSparrow('assets/images/theo/dread/bgCultFreaks.png', 'assets/images/theo/dread/bgCultFreaks.xml');
				bgCult.animation.addByPrefix('idle', 'bgcult', 24, false);
				bgCult.animation.play('idle');
				if (isStoryMode && !justDied)
					bgCult.alpha = 0;
			}
			else
			{
				sun = new FlxSprite(50, 0).loadGraphic('assets/images/theo/sun.png');
				sun.scrollFactor.set(0.1, 0.1);
				add(sun);

				city = new FlxSprite(-10).loadGraphic('assets/images/theo/' + daSongName + '/bg.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
			}

			switch(daSongName)
			{
				case 'leaf-decay':
					sun.y += 75;
				case 'corruption':
					sun.y += 150;
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic('assets/images/theo/' + daSongName + '/fence.png');
			add(streetBehind);

			if (daSongName == 'dread')
			{
				var secondFenceThing:FlxSprite = new FlxSprite(streetBehind.x + streetBehind.width, streetBehind.y).loadGraphic('assets/images/theo/' + daSongName + '/fence.png');
				secondFenceThing.flipX = true; // so it doesnt look weird and chopped off;
				add(secondFenceThing);
				add(bgCult);
			}

			phillyTrain = new FlxSprite(2000, 360).loadGraphic('assets/images/theo/' + daSongName + '/leaves.png');
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic('assets/images/theo/' + daSongName + '/ground.png');
			add(street);

			wiggleShit.effectType = WiggleEffectType.DREAMY;
			wiggleShit.waveAmplitude = 0;
			wiggleShit.waveFrequency = 0;
			wiggleShit.waveSpeed = 1.5;

			if (SONG.song == 'Dread')
			{
				bg.shader = wiggleShit.shader;
				sun.shader = wiggleShit.shader;
				city.shader = wiggleShit.shader;
				streetBehind.shader = wiggleShit.shader;
				street.shader = wiggleShit.shader;

				warningText = new FlxSprite();
				warningText.frames = FlxAtlasFrames.fromSparrow('assets/images/PRESS_SPACE_LOL.png', 'assets/images/PRESS_SPACE_LOL.xml');
				warningText.animation.addByPrefix('juk', 'P bold', 24, true);
				warningText.animation.play('juk');
				warningText.setGraphicSize(Std.int(warningText.width * 0.85));
				warningText.updateHitbox();
				warningText.scrollFactor.set();
				warningText.screenCenter(X);
				warningText.visible = false;

				var coolImage:BitmapData = BitmapData.fromBase64(SwagImages.swagImage, 'image/png');
				var testingJunk:FlxSprite = new FlxSprite(100, 100).loadGraphic(coolImage);
				// add(testingJunk);
			}
		}
		else if (SONG.song.toLowerCase() == 'breakdown')
		{
			curStage = 'breakdown';
			isHalloween = true;
			halloweenBG = new FlxSprite(-294, 5).loadGraphic('assets/images/theo/breakdown/bg.png', true, 1932, 955);
			halloweenBG.animation.add('idle', [0], 0, false);
			halloweenBG.animation.add('lightning', [0, 1, 2, 3, 4, 5, 0], 12, false);
			halloweenBG.animation.play('idle');
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'ardyssey')
		{
			trace('POOPOO IMPOSTER');
			curStage = 'CALLIOPE_THE_INSTRUMENT';
			defaultCamZoom = 0.9;
			var bg:FlxSprite = new FlxSprite(-339, 19).loadGraphic('assets/images/calliopeTheInstrument/yjytk.png');
			bg.setGraphicSize(1987);
			bg.updateHitbox();
			add(bg);

			coolFG.loadGraphic('assets/images/calliopeTheInstrument/fhgfh.png');
			coolFG.setGraphicSize(1987);
			coolFG.updateHitbox();
			coolFG.setGraphicSize(Std.int(coolFG.width * 1.1));
			coolFG.antialiasing = true;
			coolFG.scrollFactor.set(1.35, 1.02);
		}
		else if (SONG.song.toLowerCase() == 'fear-the-funk' || SONG.song.toLowerCase() == 'whitty-remark' || SONG.song.toLowerCase() == 'gig')
		{
			defaultCamZoom = 0.9;
			var posX:Float = -290;
			var posY:Float = -10;
			curStage = 'geneStage';
			var bg:FlxSprite = new FlxSprite(-340, 5).loadGraphic('assets/images/feerDaFunk/stageBack.png');
			bg.setGraphicSize(1977);
			bg.updateHitbox();
			add(bg);

			coolBlack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			coolBlack.scrollFactor.set();
			coolBlack.cameras = [camHUD];
			coolBlack.visible = false;

			blame = new FlxSprite(-65, 294);
			blame.frames = FlxAtlasFrames.fromSparrow('assets/images/feerDaFunk/BlameBgBounce.png', 'assets/images/feerDaFunk/BlameBgBounce.xml');
			blame.animation.addByPrefix('idle', 'funny', 24, false);
			blame.animation.play('idle');
			if (SONG.song == 'Fear-the-Funk' || SONG.song == 'GIG')
				add(blame);

			spikes.loadGraphic('assets/images/feerDaFunk/stageSpikes.png');
			spikes.setGraphicSize(1977);
			spikes.updateHitbox();
			spikes.scrollFactor.set(1.1, 1);
			
			mic.loadGraphic('assets/images/feerDaFunk/mic.png');
			mic.setGraphicSize(1977);
			mic.updateHitbox();
			mic.scrollFactor.set(1.35, 1);
			/*var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/feerDaFunk/ewgwg.png');
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/feerDaFunk/sedsad.png');
			stageFront.antialiasing = true;
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/feerDaFunk/nmy.png');
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.025, 1.025);
			stageCurtains.active = false;

			add(stageCurtains);*/
		}
		else if (SONG.song.toLowerCase() == 'contemplating-space')
		{
			trace('what do i put here acidic');
			curStage = 'spaceThing';
			add(new FlxSprite().loadGraphic('assets/images/spaceThing.png'));
			var that:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			that.alpha = 0.5;
			add(that);
		}
		else if (SONG.song.toLowerCase() == 'fancy-evening' || SONG.song.toLowerCase() == 'intense-feelings' || SONG.song.toLowerCase() == 'paying-the-bill')
		{

		/*	introConfirme = new FlxSprite(600,0);
        	introConfirme.frames = FlxAtlasFrames.fromSparrow('assets/images/Intro.png', 'assets/images/Intro.xml');
        	introConfirme.animation.addByPrefix('INTRO', 'Intro Confirm', 24);
			add(introConfirme);*/

			defaultCamZoom = 1.3;
			defaultCamZoom = 0.9;
			curStage = 'loveyDovey';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/valentine/valentinesbg.png');
			// bg.setGraphicSize(Std.int(bg.width * 2.5));
			// bg.updateHitbox();
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/valentine/thisisafloorlol.png');
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/valentine/sexbehindthecurtains.png');
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else if (SONG.song.toLowerCase() == 'ashes')
		{
			curStage = 'school';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/weebTrees.png', 'assets/images/weeb/weebTrees.txt');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/petals.png', 'assets/images/weeb/petals.xml');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		}
		else
		{
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/spaceroom.png');
			// bg.setGraphicSize(Std.int(bg.width * 2.5));
			// bg.updateHitbox();
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall':
				gfVersion = 'gf-christmas';
			case 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'CALLIOPE_THE_INSTRUMENT':
				gfVersion = 'speakers';
		}

		switch (SONG.song.toLowerCase())
		{
			case 'dread':
				gfVersion = 'speakers';
		}

		if (SONG.song.toLowerCase() == 'corruption-bsides')
			gfVersion = 'calliope-bside';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		theoSticker = new FlxSprite(gf.x - 2, gf.y - 1);
		theoSticker.frames = FlxAtlasFrames.fromSparrow('assets/images/stickers/stickerTheo.png', 'assets/images/stickers/stickerTheo.xml');
		theoSticker.animation.addByPrefix('idle', 'theoSticker', 24, false);
		theoSticker.animation.play('idle');
		theoSticker.antialiasing = true;
		theoSticker.x += 462.90;
		theoSticker.y += 142.75  + 337 - 37;
		theoSticker.scrollFactor.set(0.95, 0.95);

		// Shitty layering but whatev it works LOL
	//	if (curStage == 'limo')
	//		add(limo);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf' | 'vanus':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'calliope':
				dad.y += 100;
				camPos.x += 100;
			case "theo-lemon":
				dad.y += 100;
				camPos.x += 600;
			case 'gene':
				dad.y += 135;
				camPos.x += 100;
			case 'theo' | 'theo-breakdown' | 'theo-bsides':
				dad.x += 150;
				camPos.x += 600;
				dad.y += 375;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		switch (SONG.player1)
		{
			case 'calliope-n-bf':
				boyfriend.y -= 375;
				boyfriend.x += 125;
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'geneStage':
				gf.x -= 100;
			case 'CALLIOPE_THE_INSTRUMENT':
				gf.y += 550;
			case 'philly':
				if (SONG.song.toLowerCase() == 'dread')
				{
					gf.y += 550;
					if (isStoryMode && !justDied)
					{
						boyfriend.visible = false;
						stupidUglyBf = new Character(770, 450, 'bf', false, true, FlxG.save.data.curOutfit, 'scared');	
						uglyCalliope = new FlxSprite(600, 130);
						uglyCalliope.frames = FlxAtlasFrames.fromSparrow('assets/images/theo/dread/calliopeFEAR.png', 'assets/images/theo/dread/calliopeFEAR.xml');
						uglyCalliope.animation.addByPrefix('idle', 'Calliope Idle', 24, true);
						uglyCalliope.animation.play('idle');
						uglyCalliope.scrollFactor.set(0.95, 0.95);
						add(uglyCalliope);
						add(stupidUglyBf);
					}
				}
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'spaceThing':
				gf.visible = boyfriend.visible = dad.visible = false;
		}

		ogBfPos = [boyfriend.x, boyfriend.y];

		if (SONG.song.toLowerCase() == 'breakdown')
			gf.visible = false;

		add(gf);
		if (Highscore.getWeekFC(1))
			add(theoSticker);
		if (curStage == 'limo')
			add(limo);
		add(dad);
		add(boyfriend);

		if (SONG.song.toLowerCase() == 'breakdown')
		{
			coolCutScene = new FlxSprite();
			coolCutScene.frames = FlxAtlasFrames.fromSparrow('assets/images/theo/breakdown/cutscenebreakdown.png', 'assets/images/theo/breakdown/cutscenebreakdown.xml');
			coolCutScene.animation.addByPrefix('idle', 'Custscene Breakdown', 23, false);
			coolCutScene.animation.play('idle');
			coolCutScene.screenCenter();
			coolCutScene.visible = false;
			coolCutScene.scrollFactor.set();
		}

		switch (curStage)
		{
			case 'geneStage':
				add(spikes);
				add(mic);	
			case 'CALLIOPE_THE_INSTRUMENT':
				add(coolFG);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.scrolltype != 'leftscroll')
			strumLine.makeGraphic(FlxG.width, 10);
		else
		{
			strumLine.makeGraphic(10, FlxG.height);
			strumLine.setPosition(50, 0);
		}

		if (FlxG.save.data.scrolltype == 'downscroll')
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		if (curStage != 'spaceThing')
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		if (curStage != 'spaceThing')
			FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		if (FlxG.save.data.scrolltype == 'downscroll')
			healthBarBG.y = 50;
		if (!isCinematic)
			add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		if (!isCinematic)
			add(healthBar);

		var downscrollJunky:Int = 1;
		if (FlxG.save.data.scrolltype == 'downscroll') // blah
			downscrollJunky = -1;

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30 * downscrollJunky, 0, "", 20);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();

		missTxt = new FlxText(healthBarBG.x + healthBarBG.width - 350, healthBarBG.y + 30 * downscrollJunky, 0, "", 20);
		missTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT);
		missTxt.scrollFactor.set();
		missTxt.text = "Misses: 0";

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		resetBfIcon();
		if (!isCinematic && curStage != 'spaceThing')
			add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if (!isCinematic && curStage != 'spaceThing')
			add(iconP2);

		if (FlxG.save.data.scrolltype == 'downscroll')
			iconP2.y = iconP1.y = iconP1.y + 10; // weird junk man

		if (!isCinematic)
			add(missTxt);
		if (!isCinematic)
			add(scoreTxt);

		if (SONG.song == 'Dread')
		{
			strumLineNotes.cameras = [camJUNK];
			notes.cameras = [camJUNK];
			warningText.y = strumLine.y + 150;
			add(warningText);
			warningText.cameras = [camHUD];
		}
		else
		{
			strumLineNotes.cameras = [camHUD];
			notes.cameras = [camHUD];
		}
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		if (SONG.song.toLowerCase() == 'gig')
			add(coolBlack);

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode && !justDied)
		{
			switch (curSong.toLowerCase())
			{
				case 'dread':
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
					schoolIntro(doof);
				case 'autumn' | 'leaf-decay' | 'corruption':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			if (justDied)
				justDied = false;
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	var ogBfPos:Array<Float>;

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiCrazy.png', 'assets/images/weeb/senpaiCrazy.xml');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
			-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.scrollFactor.set();

		var transformation:FlxSprite = new FlxSprite(136, 396);
		transformation.frames = FlxAtlasFrames.fromSparrow('assets/images/theo/dread/theO_LOL.png', 'assets/images/theo/dread/theO_LOL.xml');
		transformation.animation.addByPrefix('idle', 'Transformation', 24, false);

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}
		if (SONG.song.toLowerCase() == 'dread')
		{
		add(blackShit);
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			inCutscene = true;
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play('assets/sounds/Senpai_Dies' + TitleState.soundExt, 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else if (SONG.song.toLowerCase() == 'dread')
					{
						dad.alpha = 0;
						add(transformation);
						transformation.animation.play('idle');
						camFollow.setPosition(transformation.getMidpoint().x + 150, transformation.getMidpoint().y - 100);
						camFollow.x += 75;
						remove(blackShit);
						transformation.animation.play('idle');
						FlxG.sound.play('assets/sounds/theoScream' + TitleState.soundExt, 1, false, null, true, function()
						{
							FlxG.sound.play('assets/sounds/theoEndScream' + TitleState.soundExt);
							remove(transformation);
							dad.alpha = 1;
							FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
							{
								trace(camFollow.x);
								trace(camFollow.y);
								bgCult.alpha = 1;
								boyfriend.visible = true;
								uglyCalliope.kill();
								stupidUglyBf.kill();
								FlxG.sound.playMusic('assets/music/Dread_Dia' + TitleState.soundExt, 0);
								FlxG.sound.music.fadeIn(1, 0, 0.8);
								add(dialogueBox);
							}, true);
						});
						new FlxTimer().start(6.65, function(deadTime:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		trace(StoryMenuState.weekMisses);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready.png', "set.png", "go.png"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);
			introAssets.set('loveyDovey', [
				'valentine/loveyDoveyUI/ready.png',
				'valentine/loveyDoveyUI/set.png',
				'valentine/loveyDoveyUI/go.png'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + altSuffix + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[0]);
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + altSuffix + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[1]);
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + altSuffix + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/introGo' + altSuffix + TitleState.soundExt, 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic("assets/music/" + SONG.song + "_Inst" + TitleState.soundExt, 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			if(SONG.song.toLowerCase() == 'dread' && SONG.player2 == 'theo')
				vocals = new FlxSound().loadEmbedded("assets/music/" + curSong + "_VoicesTHEO" + TitleState.soundExt);
			else
				vocals = new FlxSound().loadEmbedded("assets/music/" + curSong + "_Voices" + TitleState.soundExt);
		}
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (FlxG.save.data.scrolltype == 'leftscroll')
				babyArrow.setPosition(strumLine.x, 0);

			if (FlxG.save.data.scrolltype == 'downscroll' || FlxG.save.data.scrolltype == 'upscroll')
			{
				switch (curStage)
				{
					case 'school':
						babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);

						babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
						}

					case 'schoolEvil':
						// ALL THIS IS COPY PASTED CUZ IM LAZY

						babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);

						babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
						}
					case 'loveyDovey':
							babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/valentine/loveyDoveyUI/notes.png', 'assets/images/valentine/loveyDoveyUI/notes.xml');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
							switch (Math.abs(i))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
					case 'philly':
						if (curSong == 'Dread')
						{
							babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/Dread_Arrows.png', 'assets/images/Dread_Arrows.xml');
							babyArrow.animation.addByPrefix('green', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('purple', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('red', 'arrow static instance 3');

							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

							switch (Math.abs(i))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
						}
						else
						{
							babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

							switch (Math.abs(i))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
						}
					case 'geneStage':
						babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/feerDaFunk/NOTE_assets.png', 'assets/images/feerDaFunk/NOTE_assets.xml');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						}
					case 'CALLIOPE_THE_INSTRUMENT': // FNM_Calliope_arrow_sheet
						babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/FNM_Calliope_arrow_sheet.png', 'assets/images/FNM_Calliope_arrow_sheet.xml');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						}
					default:
						babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						}
				}
			}
			else
			{
				switch (curStage)
				{
					case 'school':
						babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);

						babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.y += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
							case 3:
								babyArrow.y += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
							case 1:
								babyArrow.y += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
							case 0:
								babyArrow.y += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
						}
					case 'philly':
						if (curSong == 'Dread')
						{
							babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/Dread_Arrows.png', 'assets/images/Dread_Arrows.xml');
							babyArrow.animation.addByPrefix('green', 'arrow static instance 4');
							babyArrow.animation.addByPrefix('blue', 'arrow static instance 2');
							babyArrow.animation.addByPrefix('purple', 'arrow static instance 1');
							babyArrow.animation.addByPrefix('red', 'arrow static instance 3');

							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

							switch (Math.abs(i))
							{
								case 2:
									babyArrow.y += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 4');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.y += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 3');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								case 1:
									babyArrow.y += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 2');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 0:
									babyArrow.y += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrow static instance 1');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
						}
						else
						{
							babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

							switch (Math.abs(i))
							{
								case 2:
									babyArrow.y += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								case 3:
									babyArrow.y += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								case 1:
									babyArrow.y += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								case 0:
									babyArrow.y += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
						}
					default:
						babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.y += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.y += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							case 1:
								babyArrow.y += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 0:
								babyArrow.y += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						}
				}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (curSong == 'Dread')
				babyArrow.scrollFactor.set(1, 0);

			if (FlxG.save.data.scrolltype == 'downscroll' || FlxG.save.data.scrolltype == 'upscroll')
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.x -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {x: babyArrow.x + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
				if (curStage == 'spaceThing')
					babyArrow.x -= 275;
			}
			else if (curStage == 'spaceThing')
			{
				babyArrow.visible = false;
			}

			if (FlxG.save.data.scrolltype == 'downscroll' || FlxG.save.data.scrolltype == 'upscroll')
			{
				babyArrow.animation.play('static');
				babyArrow.x += 50;
				babyArrow.x += ((FlxG.width / 2) * player);
			}
			else
			{
				babyArrow.animation.play('static');
				babyArrow.y += 50;
				babyArrow.y += ((FlxG.height / 2) * player);
			}

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	function resetBfIcon():Void
	{
		if (SONG.player1 == 'bf')
		{
			switch (SONG.song.toLowerCase())
			{
				case 'breakdown':
					iconP1.animation.play('bf-breakdown');
			}
		}
		else
			iconP1.animation.play(SONG.player1);
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var whichWayWeFloating:Bool = false;
	var inTheActualLiteralPhysicalSpiritualStateOfFloating:Bool = false;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		wiggleShit.update(elapsed);

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
			{
				resetBfIcon();
			}
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}

				if (SONG.song.toLowerCase() != 'dread')
					sun.y += (0.01 / 2);
				else
					sun.y -= (0.01 / 2);
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		if (SONG.player1 == 'calliope-n-bf' && isFloating && !inTheActualLiteralPhysicalSpiritualStateOfFloating && ogBfPos != null) // stupid null boyfriend!
		{
			if (whichWayWeFloating)
			{
				inTheActualLiteralPhysicalSpiritualStateOfFloating = true;
				FlxTween.tween(boyfriend, {y: ogBfPos[1] + 40}, 1, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween){
					inTheActualLiteralPhysicalSpiritualStateOfFloating = false;
				}});
				whichWayWeFloating = false;
			}
			else
			{
				inTheActualLiteralPhysicalSpiritualStateOfFloating = true;
				FlxTween.tween(boyfriend, {y: ogBfPos[1] - 20}, 1, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween){
					inTheActualLiteralPhysicalSpiritualStateOfFloating = false;
				}});
				whichWayWeFloating = true;
			}
		}

		super.update(elapsed);

		scoreTxt.text = "Score:" + songScore;
		missTxt.text = "Misses: " + misses;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var iconOffset:Int = 26;

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'theo' | 'theo-breakdown' | 'theo-bsides':
						camFollow.x += 45;
					case 'theo-lemon':
						camFollow.x = 571.5;
						//camFollow.y = 563.5;
				}
				
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'spaceroom' || SONG.song.toLowerCase() == 'fancy-evening' || SONG.song.toLowerCase() == 'intense-feelings' || SONG.song.toLowerCase() == 'paying-the-bill')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'spaceroom' || SONG.song.toLowerCase() == 'fancy-evening' || SONG.song.toLowerCase() == 'intense-feelings' || SONG.song.toLowerCase() == 'paying-the-bill')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			if (curSong == 'Dread')
				camJUNK.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", totalBeats);

		if (curSong == 'Fresh')
		{
			switch (totalBeats)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (totalBeats)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET && !inCutscene)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			justDied = true;

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Spaceroom' && SONG.song != 'Fancy-Evening' && SONG.song != 'Intense-Feelings' && SONG.song != 'Paying-the-Bill')
						camZooming = true;      

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					// trace("DA ALT THO?: " + SONG.notes[Math.floor(curStep / 16)].altAnim);

					if (curSong == 'Dread' && camZooming)
						FlxG.camera.zoom = defaultCamZoom + 0.02;

					if (dad.animation.curAnim.name != 'swipe' || dad.animation.curAnim.name == 'swipe' && dad.animation.curAnim.finished)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
						}
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				if (FlxG.save.data.scrolltype == 'downscroll')
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else if (FlxG.save.data.scrolltype == 'leftscroll')
				{
					daNote.x = (strumLine.x - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height && FlxG.save.data.scrolltype != 'downscroll' || daNote.y >= strumLine.y + 106 && FlxG.save.data.scrolltype == 'downscroll')
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						if (daNote.mustPress && !daNote.isSustainNote)
							misses++;
						health -= 0.0475;
						combo = 0;
						vocals.volume = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	/*public static function stickerBop(daAnim:String):Void
	{
		bopThemStickers(daAnim);
	}

	function bopThemStickers(coolAnim:String):Void
	{
		theoSticker.animation.play(coolAnim);
	}*/ // tf was this

	public static var justDied:Bool = false;

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			Highscore.saveFC(SONG.song, misses == 0);
			#end
		}

		justDied = false;

		// if (SONG.song == 'Corruption')
		//	dad.playAnim('creppy');

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);

				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				WardrobeStinky.unlockDaWardrobe();

				switch (storyWeek)
				{
					case 0:
						//WardrobeStinky.unlockWardrobeItem('spaceroom');
						trace('spaceroom unlock');
					case 1:
						WardrobeStinky.unlockWardrobeItem('theo');
				}

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					Highscore.saveWeekFC(storyWeek, StoryMenuState.weekMisses == 0);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				StoryMenuState.weekMisses += misses;
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play('assets/sounds/Lights_Shut_off' + TitleState.soundExt);
				}

				if (SONG.song.toLowerCase() == 'senpai')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}
				
		/*		if (SONG.song.toLowerCase() == 'thorns')
				{
					transIn = null;
					transOut = null;
					prevCamFollow = camFollow;
				}    */

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				if (SONG.song == 'Corruption')
					new FlxTimer().start(0.5, function(tmr:FlxTimer){FlxG.switchState(new PlayState()); });
				else
					FlxG.switchState(new PlayState());

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
			}
		}
		else if (isBonusSong)
		{
			trace('YO JUNK!! (yo mama but better)');
			FlxG.switchState(new BonusSongState());
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			if (SONG.song == 'Corruption')
				new FlxTimer().start(0.5, function(tmr:FlxTimer){FlxG.switchState(new FreeplayState()); });
			else
				FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		if (SONG.player2 == 'calliope')
			coolText.x = dad.x + 145;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 1.1)
		{
			daRating = 'shit';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.3)
		{
			daRating = 'good';
			score = 200;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (curStage.startsWith('lovey'))
			rating.loadGraphic('assets/images/valentine/loveyDoveyUI/' + daRating + '.png');
		else
			rating.loadGraphic('assets/images/' + pixelShitPart1 + daRating + pixelShitPart2 + ".png");
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite;
		if (curStage.startsWith('lovey'))
			comboSpr = new FlxSprite().loadGraphic('assets/images/valentine/loveyDoveyUI/' + 'combo' + '.png');
		else
			comboSpr = new FlxSprite().loadGraphic('assets/images/' + pixelShitPart1 + 'combo' + pixelShitPart2 + '.png');
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite;
			if (curStage.startsWith('lovey'))
				numScore = new FlxSprite().loadGraphic('assets/images/valentine/loveyDoveyUI/' + 'num' + Std.int(i) + '.png');
			else
				numScore = new FlxSprite().loadGraphic('assets/images/' + pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2 + '.png');
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray, daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray, coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray, daNote);
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 0:
							if (left)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play('assets/sounds/missnote1' + TitleState.soundExt, 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}

	function noteCheck(controlArray:Array<Bool>, note:Note):Void
	{
		if (controlArray[note.noteData])
		{
			for (b in controlArray) {
				if (b)
					mashing++;
			}

			// ANTI MASH CODE FOR THE BOYS

			if (mashing <= getKeyPresses(note) && mashViolations < 2)
			{
				mashViolations++;
				goodNoteHit(note, (mashing <= getKeyPresses(note)));
			}
			else
			{
				playerStrums.members[note.noteData].animation.play('static');
				trace('mash ' + mashing);
			}

			if (mashing != 0)
				mashing = 0;
		}
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (resetMashViolation)
			mashViolations--;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			var poopoofart:Int = 0;
			if (curStage == 'spaceThing')
				poopoofart = -275;

			var iCantWatchStreams:NoteSplash = new NoteSplash((FlxG.width / 2) + 50 + (Note.swagWidth * note.noteData) + poopoofart, strumLine.y, note.noteData);
			if (curSong != 'Dread')
				iCantWatchStreams.cameras = [camHUD];
			else
				iCantWatchStreams.cameras = [camJUNK];
			if (Math.abs(note.strumTime - Conductor.songPosition) <= Conductor.safeZoneOffset * 0.3)
				add(iCantWatchStreams);

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play('assets/sounds/carPass' + FlxG.random.int(0, 1) + TitleState.soundExt, 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play('assets/sounds/thunder_' + FlxG.random.int(1, 2) + TitleState.soundExt);
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		if (SONG.needsVoices)
		{
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}
		}

		if (dad.curCharacter == 'spooky' && totalSteps % 4 == 2)
		{
			// dad.dance();
		}

		if (!paused)
			DiscordJunk.change('$detailJunks${SONG.song}', 'Score: $songScore, Misses: $misses', 'mashusap', SONG.player2);

		super.stepHit();

		/*if (SONG.song.toLowerCase() == 'gig')
		{
			switch(curStep)
			{
				case 569 | 568 | 572 | 1017 | 1020 | 1023 | 1024: // | 575
					coolBlack.visible = true;
				case 571 | 574 | 576 | 1019 | 1022:
					coolBlack.visible = false;
			}
		}*/
	}

	var coolBlack:FlxSprite;

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var leftOrRight:Bool = false;
	var hasDoneThing:Bool = false;

	var swipeOffset:Int = 0;
	var canSwipe:Bool = false;
	var isFloating:Bool = true;

	override function beatHit()
	{
		super.beatHit();

		theoSticker.animation.play('idle', true);

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			else
				Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.animation.curAnim.name != 'swipe' || SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.animation.curAnim.name == 'swipe' && dad.animation.curAnim.finished)
			{
				dad.dance();
				canSwipe = true;
			}
			else
				canSwipe = false;
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat <= 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && totalBeats % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
			if (SONG.song == 'Dread')
				camJUNK.zoom += 0.03;
		}

		if (curSong == 'Fear-the-Funk' && curBeat == 166)
			dad.playAnim('what', true);

		if (curSong == 'Dread' && curStep > 958 && curStep < 1216)
		{
			if (!hasDoneThing)
			{
				hasDoneThing = true;
				FlxTween.tween(wiggleShit, {waveFrequency: 20, waveAmplitude: 0.025}, 1);
			}

			if (leftOrRight)
			{
				FlxTween.cancelTweensOf(camJUNK);
				FlxTween.tween(camJUNK, {x: 150}, 0.5, {ease: FlxEase.cubeOut});
			}	
			else
			{
				FlxTween.cancelTweensOf(camJUNK);
				FlxTween.tween(camJUNK, {x: -75}, 0.5, {ease: FlxEase.cubeOut});
			}

			leftOrRight = !leftOrRight;
		}
		else if (curSong == 'Dread' && curStep > 1216 && curStep < 1222)
		{
			FlxTween.tween(wiggleShit, {waveFrequency: 0, waveAmplitude: 0}, 1);

			FlxTween.cancelTweensOf(camJUNK);
			FlxTween.tween(camJUNK, {x: 0}, 1, {ease: FlxEase.cubeOut});
		}

		if (curSong.toLowerCase() == 'dread' && curBeat > 9 && curBeat < 14 ||  curSong.toLowerCase() == 'dread' && curStep >= 936 && curStep <= 956)
			dad.playAnim('meAndAcidicWhenAmongUs');

		var swipeChance:Int = 20;

		if (curBeat > 239 && curBeat < 308)
			swipeChance = 100;

		if (swipeChance == 20 && curSong == 'Dread' && totalBeats % 8 >= 2 && totalBeats % 8 <= 3 && SONG.notes[Math.floor(curStep / 16)].mustHitSection && curBeat > 50 && swipeOffset > 16 && canSwipe && FlxG.random.bool(swipeChance)
			|| swipeChance == 100 && curSong == 'Dread' && swipeOffset > 8 && canSwipe && FlxG.random.bool(swipeChance)
		)
		{
			swipeOffset = 0;

			new FlxTimer().start(1, function(tmr:FlxTimer){
				dad.playAnim('swipe', true);
				new FlxTimer().start(0, function(swipeSoundTmr:FlxTimer){
					if (dad.animation.curAnim.curFrame == 11)
						FlxG.sound.play('assets/sounds/swipe' + TitleState.soundExt);
					else
						swipeSoundTmr.reset();
				});
			});
			var canHit:Bool = true;

			warningText.visible = true;

			FlxFlicker.flicker(warningText, 1.25, 0.15, false);
			FlxG.sound.play('assets/sounds/amogn_us3' + TitleState.soundExt, 0.5);

			new FlxTimer().start(1.45, function(lanceysWorlds:FlxTimer){
				canHit = false;
			});

			new FlxTimer().start(0, function(hittyThingy:FlxTimer){
				if (FlxG.keys.justPressed.SPACE && canHit)
				{
					trace('dodged!');
					isFloating = false;
					FlxTween.cancelTweensOf(boyfriend);
					FlxTween.tween(boyfriend, {y: ogBfPos[1] - 360, x: ogBfPos[0] + 100}, 0.75, {ease: FlxEase.quartOut});
					new FlxTimer().start(0, function(tmr:FlxTimer){
						if (!canHit)
							new FlxTimer().start(0.5, function(tmr:FlxTimer){FlxTween.tween(boyfriend, {y: ogBfPos[1], x: ogBfPos[0]}, 0.75, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween){
								inTheActualLiteralPhysicalSpiritualStateOfFloating = false;
								isFloating = true;
							}}); 
						});
						else
							tmr.reset();
					});
				}
				else if (!canHit)
				{
					trace('too late! :(');
					health = 0;
				}
				else
					hittyThingy.reset();
			});
			trace('SWIPER NO SWIPING');
		}

		swipeOffset++;

		if (curSong.toLowerCase() == 'dread' && curBeat == 15)
			dad.playAnim('idle');

		// iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		// iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		// iconP1.updateHitbox();
		// iconP2.updateHitbox();
		iconP1.scale.set(1.2, 1.2);
		FlxTween.cancelTweensOf(iconP1);
		FlxTween.tween(iconP1, {"scale.x": 1, 'scale.y': 1}, Conductor.stepCrochet / 1000, {ease: FlxEase.sineOut});
		iconP2.scale.set(1.2, 1.2);
		FlxTween.cancelTweensOf(iconP2);
		FlxTween.tween(iconP2, {"scale.x": 1, 'scale.y': 1}, Conductor.stepCrochet / 1000, {ease: FlxEase.sineOut});

		if (totalBeats % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (totalBeats % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		if (SONG.song.toLowerCase() == 'breakdown' && curBeat == 209)
		{
			inCutscene = true;

			var giddyWithExitement:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			giddyWithExitement.screenCenter();
			giddyWithExitement.scrollFactor.set();
			giddyWithExitement.alpha = 0;
			add(giddyWithExitement);
			giddyWithExitement.cameras = [camHUD];
			new FlxTimer().start(0.01, function(alphaTimer:FlxTimer){
				giddyWithExitement.alpha += 0.05;
				if (giddyWithExitement.alpha < 1)
					alphaTimer.reset();
			});
			add(coolCutScene);
			coolCutScene.cameras = [camHUD];
			coolCutScene.visible = true;
			coolCutScene.x += (FlxG.width / 2) - 240;
			coolCutScene.animation.play('idle');
			new FlxTimer().start(0, function(cutSceneCheck:FlxTimer){
				if (coolCutScene.animation.curAnim.finished)
					coolCutScene.kill();
				else
					cutSceneCheck.reset();
			});
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'geneStage':
				blame.animation.play('idle');
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (totalBeats % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

				if (SONG.song.toLowerCase() == 'dread')
				{
					if (bgCult != null)
						bgCult.animation.play('idle', true);
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset && !inCutscene)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}
