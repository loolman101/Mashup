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
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class SecretState extends MusicBeatState
{
    public static var secretType:String = 'yomama';

    override function create()
    {
        switch (secretType)
        {
            case 'minion':
                var coolImage:FlxSprite = new FlxSprite().loadGraphic('assets/images/memes/zzzzzzzz.png');
                coolImage.screenCenter(X);
                coolImage.screenCenter(Y);
                coolImage.setGraphicSize(FlxG.height);
                add(coolImage);

                FlxG.sound.playMusic('assets/music/seeecret_junk.ogg');
            case 'tiky':
                var goTikyGo:FlxSprite = new FlxSprite().loadGraphic('assets/images/tiky.png', true, 476, 860);
                goTikyGo.animation.add('idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81], 10, true);
                goTikyGo.animation.play('idle');
                goTikyGo.screenCenter();
                goTikyGo.setGraphicSize(0, FlxG.height);
                add(goTikyGo);

                FlxG.sound.playMusic('assets/music/S2vyF0Aw5TSnFXxK.ogg');
            case 'sussy':
                var sus:FlxSprite = new FlxSprite();
                sus.frames = FlxAtlasFrames.fromSparrow('assets/images/coolSussy.png', 'assets/images/coolSussy.xml');
                sus.animation.addByPrefix('idle', 'S', 26, true);
                sus.animation.play('idle');
                sus.screenCenter();
                sus.setGraphicSize(0, FlxG.height);
                sus.antialiasing = true;
                add(sus);

                FlxG.sound.playMusic('assets/music/Untitled.ogg');
        }

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