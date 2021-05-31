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

class CreditsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var coolPeople:Array<String> = ['ACIDICSHOES', 'ZUMORIZU', 'JUKEBOX', 'BLAMEJAJUBZ', 'KIRO', 'THE FIZZY FRENZY', 'GRANTARE', 'RAT', 'EVANCLUBYT', 'ROCKETPOPS', 'COSMIC BERRY', 'JOHNLEBRON'];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuCredits.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...coolPeople.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, coolPeople[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
		}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!

		FlxG.sound.playMusic('assets/music/HAHAIGETTONAMETHISSONGLOOL.ogg');

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.ACCEPT)
		{
			switch(curSelected) {
				case 3:
					FlxG.openURL("https://www.youtube.com/channel/UCou-r4h1UnFDN1_zo4TDRrg");
				case 4:
					FlxG.openURL("https://www.youtube.com/channel/UCYWbre_6s1DbTpHTRK-GKKQ");
				case 5:
					FlxG.openURL("https://www.youtube.com/channel/UCy2hDS9MCXjcTbEfZfuY2tw");
				case 6:
					FlxG.openURL('https://www.youtube.com/channel/UCKbKOSJPbP4u81cpBpoSntw');
				case 7:
					FlxG.openURL('https://www.youtube.com/channel/UCudDrG_hUHOLfd_1xjiIRpw');
				case 8:
					FlxG.openURL('https://www.youtube.com/channel/UCdkHxFQnvyIKHSPcRRu-9PQ');
				case 9:
					FlxG.openURL('https://www.youtube.com/channel/UCVbNlXsQ-9WA2WcN8u2se_Q');
				case 10:
					FlxG.openURL('https://www.instagram.com/lol.fruits/');
			}
		//	var funnystring = Std.string(curSelected);
		//	FlxG.openURL(funnystring); 
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
//		#if !switch
		//NGio.logEvent('Fresh');
//		#end

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
