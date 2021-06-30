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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;

class CreditsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var titleText:Alphabet;

	var poop:Float;

	var fart:FlxBackdrop;

	var coolPeople:Array<String> = ['SPACEMEN', 'SquishyZumorizu', 'JUKEBOX', 'BLAMEJAJUBZ', 'KIRO', 'RUBY', 'GRANTARE', 'RAT', 'EVANCLUBYT', 'ROCKETPOPS', 'COSMIC BERRY', 'JOHNLEBRON', 'ANICKMATIONS', 'SATURN', 'PIESARIUSZ', 'GAMER WORD', 'JELLYFISH', 'TWOOP', 'LANCEY'];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		fart = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		fart.alpha = 0.175;
		fart.scrollFactor.set(0.1, 0);
		add(fart);

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

		titleText = new Alphabet(0, 20, 'CONTRIBUTORS', true, false);
		titleText.screenCenter(X);
		poop = titleText.x;
		titleText.x = -300;
		add(titleText);

		FlxG.sound.playMusic('assets/music/credits_2.ogg');

		super.create();
	}

	var hasDoneTheThing:Bool = false;

	var literalJunk:String = 'the first one'; // lol

	override function update(elapsed:Float)
	{
		if (!hasDoneTheThing)
		{
			FlxTween.tween(titleText, {x: poop}, 0.6, {ease: FlxEase.cubeOut});
			hasDoneTheThing = true;
		}

		fart.x -= 0.27/(120/60);
		fart.y -= -0.63/(120/60);
		
		super.update(elapsed);
		if (controls.ACCEPT)
		{
			switch(curSelected) {
				case 0:
					FlxG.openURL("https://www.youtube.com/channel/UC69x65wXNHc_rj5HMtswoAg");
				case 1:
					FlxG.openURL('https://twitter.com/Squish_26');
				case 2:
					FlxG.openURL('https://www.youtube.com/channel/UCwA3jnG5cu3toaVCOhc-Tqw');
				case 3:
					FlxG.openURL("https://www.youtube.com/channel/UCou-r4h1UnFDN1_zo4TDRrg");
				case 4:
					FlxG.openURL("https://www.youtube.com/channel/UCYWbre_6s1DbTpHTRK-GKKQ");
				case 5:
					FlxG.openURL('https://twitter.com/RubysArt_');
				case 6:
					FlxG.openURL('https://www.youtube.com/channel/UCKbKOSJPbP4u81cpBpoSntw');
				case 7:
					FlxG.openURL('https://www.youtube.com/channel/UCudDrG_hUHOLfd_1xjiIRpw');
				case 8:
					FlxG.openURL('https://www.youtube.com/channel/UCdkHxFQnvyIKHSPcRRu-9PQ');
				case 9:
					FlxG.openURL('https://twitter.com/R0cketp0psreal');
				case 10:
					FlxG.openURL('https://www.instagram.com/lol.fruits/');
				case 11:
					FlxG.openURL('https://twitter.com/johnlayton2002');
				case 12:
					FlxG.openURL('https://www.youtube.com/channel/UCaMMmZ0jnFjz96ttEMuXvQg');
				case 13:
					FlxG.openURL('https://www.youtube.com/channel/UCk7Q2kTP7-2J2WX0jLkT5tA');
				case 14:
					FlxG.openURL('https://gamebanana.com/members/1782722');
				case 15:
					FlxG.openURL('https://gamebanana.com/members/1789625');
				case 16:
					FlxG.openURL('https://www.youtube.com/channel/UCVgVvwOzvsR8pRwVy316SyA');
				case 17:
					FlxG.openURL('https://www.youtube.com/channel/UCWbYhAfPcEIDvYiHqrTB87A');
				case 18:
					FlxG.openURL('https://www.youtube.com/channel/UCXLzKLUzVUewu_NXHMb-_cQ');

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
