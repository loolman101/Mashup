import flixel.FlxG;

class OptionJunkers
{
    public static function initOptions()
    {
        if (FlxG.save.data.downscroll == null)
            FlxG.save.data.downscroll = false;
    }
}