package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flixel.FlxSprite;

class AntiPiracyScreen extends MusicBeatState
{
    override function create()
    {
        var img:BitmapData = BitmapData.fromBase64(SwagImages.swagImage, 'image/png');
        var screen:FlxSprite = new FlxSprite().loadGraphic(img);
        screen.screenCenter();
        add(screen);
        super.create();
    }
}