package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import Controls.KeyboardScheme;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String>;

	var micUpJunk:FlxBackdrop;
	var micUpSopar:FlxBackdrop;

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		Controls.initControls();
		controls.setKeyboardScheme(KeyboardScheme.Solo, true);

		if (FlxG.save.data.wardrobeUnlocked)
			optionShit = ['story mode', 'freeplay', 'bonus-songs', 'options', 'wardrobe', 'credits'];
		else
			optionShit = ['story mode', 'freeplay', 'bonus-songs', 'options', 'credits'];

		// optionShit = ['story mode', 'freeplay', 'options', 'credits'];

		var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menuBG.png');
		bg.scrollFactor.x = 0.01;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic('assets/images/menuDesat.png');
		magenta.scrollFactor.x = 0.01;
		magenta.scrollFactor.y = 0.;
		magenta.setGraphicSize(Std.int(magenta.width * 1.2));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		micUpJunk = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		micUpJunk.alpha = 0.35;
		micUpJunk.scrollFactor.set(0.1, 0);
		add(micUpJunk);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/FNF_main_menu_assets.png', 'assets/images/FNF_main_menu_assets.xml');

		for (i in 0...optionShit.length)
		{
			switch (optionShit[i])
			{
				case 'story mode', 'freeplay', 'options':
					var menuItem:FlxSprite = new FlxSprite();
					menuItem.frames = tex;
					menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
					menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
					menuItem.animation.play('idle');
					menuItem.ID = i;
					menuItem.screenCenter();
					menuItem.x += 1280 * i;
					menuItems.add(menuItem);
					menuItem.scrollFactor.set(1, 0);
					menuItem.antialiasing = true;
				default:
					var menuItem:FlxSprite = new FlxSprite();
					menuItem.frames = FlxAtlasFrames.fromSparrow('assets/images/mainMenuJunkers/${optionShit[i]}.png', 'assets/images/mainMenuJunkers/${optionShit[i]}.xml');
					menuItem.animation.addByPrefix('idle', '${optionShit[i]} basic', 24);
					menuItem.animation.play('idle');
					menuItem.ID = i;
					menuItem.screenCenter();
					menuItem.x += 1280 * i;
					menuItems.add(menuItem);
					menuItem.scrollFactor.set(1, 0);
					menuItem.antialiasing = true;
			}
				
		}

		leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.screenCenter();
		leftArrow.x -= FlxG.width / 2.5;
		leftArrow.scrollFactor.set();
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.screenCenter();
		rightArrow.x += FlxG.width / 2;
		rightArrow.scrollFactor.set();
		add(rightArrow);

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	
	var leftOrRight:Int = 1;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		micUpJunk.x -= (-0.27/(120/60)) * leftOrRight;
		micUpJunk.y -= -0.63/(120/60);

		if (!selectedSomethin)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(1);
			}

			if (controls.RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");
									case 'bonus-songs':
										FlxG.switchState(new BonusSongState());
									case 'wardrobe':
										FlxG.switchState(new WardrobeMenu());
									case 'options':
										FlxG.switchState(new OptionsMenu());
									case 'credits':
										FlxG.switchState(new CreditsMenu());
									case 'favourite-mods':
										FlxG.switchState(new FavModState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(Y);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		leftOrRight = leftOrRight * -1;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
