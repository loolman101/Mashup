package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.display.FlxBackdrop;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	public static var cinematicMode:Bool = false;

	var controlsStrings:Array<String> = ['CINEMATIC MODE', 'TOGGLE FULLSCREEN', 'DOWNSCROLL'];

	var iLoveWow2:FlxBackdrop;

	var checkMark:FlxSprite;

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFF00f2ff;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		iLoveWow2 = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		iLoveWow2.alpha = 0.2;
		iLoveWow2.scrollFactor.set(0.1, 0);
		add(iLoveWow2);

		checkMark = new FlxSprite(1030, 350);
		checkMark.frames = FlxAtlasFrames.fromSparrow('assets/images/option_things.png', 'assets/images/option_things.xml');
		checkMark.animation.addByPrefix('true', 'ON', 24, false);
		checkMark.animation.addByPrefix('false', 'OFF', 24, false);
		checkMark.animation.play('false');
		checkMark.alpha = 0.75;
		add(checkMark);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		FlxG.sound.playMusic('assets/music/hamburger.ogg');

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		iLoveWow2.x -= -0.27/(120/60);
		iLoveWow2.y -= -0.63/(120/60);

		if (controls.ACCEPT)
		{
			switch(curSelected) {
				case 0:
					cinematicMode = !cinematicMode;
				case 1:
					FlxG.fullscreen = !FlxG.fullscreen;
				case 2:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
			}
		}

		switch(curSelected) {
			case 0:
				checkMark.animation.play(Std.string(cinematicMode));
			case 1:
				checkMark.animation.play(Std.string(FlxG.fullscreen));
			case 2:
				checkMark.animation.play(Std.string(FlxG.save.data.downscroll));
		}

		if (isSettingControl)
			waitingInput();
		else
		{
			if (controls.BACK)
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new MainMenuState());
			}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
