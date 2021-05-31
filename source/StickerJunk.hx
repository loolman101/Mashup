import flixel.FlxG;

class StickerJunk
{
    public static function initStickers()
    {
        if (FlxG.save.data.theoSticker == null)
            FlxG.save.data.theoSticker = false;
    }
}