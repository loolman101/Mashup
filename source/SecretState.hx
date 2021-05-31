package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import openfl.Assets;
import lime.utils.Assets;

using StringTools;

class SecretState extends MusicBeatState
{
    override function create()
    {
        var coolImage:FlxSprite = new FlxSprite().loadGraphic('assets/images/zzzzzzzz.png');
        coolImage.screenCenter(X);
        coolImage.screenCenter(Y);
        coolImage.setGraphicSize(FlxG.height);
        add(coolImage);

        FlxG.sound.playMusic('assets/music/seeecret_junk.ogg');

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}
    }
}