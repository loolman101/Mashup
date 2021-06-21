import flixel.FlxG;

class OptionJunkers
{
    public static function initOptions()
    {
        if (FlxG.save.data.scrolltype == null)
            FlxG.save.data.scrolltype = 'upscroll';
    }
}