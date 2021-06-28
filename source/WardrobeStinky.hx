import flixel.FlxG;

class WardrobeStinky
{
    public static function initWardrobe()
    {
        if (FlxG.save.data.wardrobeUnlocked == null)
            FlxG.save.data.wardrobeUnlocked = false;

        if (FlxG.save.data.curOutfit == null)
            FlxG.save.data.curOutfit = '';
    }

    public static function unlockDaWardrobe()
    {
        FlxG.save.data.wardrobeUnlocked = true;
    }

    public static function unlockWardrobeItem(daItem:String)
    {
        switch (daItem)
        {
            case 'spaceroom':
                FlxG.save.data.spaceroomOutfit = true;
            case 'theo':
                FlxG.save.data.theoOutfit = true;
        }
    }
}