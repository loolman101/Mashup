package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import Controls.Control;

using StringTools;

class WardrobeMenu extends MusicBeatState
{
    var wardrobeItems:Array<String> = ['NORMAL'];

    var menuItems:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;

    var bfPreview:Character;

    override function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBG.png');
        add(bg);

        menuItems =  new FlxTypedGroup<Alphabet>();
        add(menuItems);

        if (FlxG.save.data.theoOutfit)
            wardrobeItems.push('THEO OUTFIT');
        if (FlxG.save.data.spaceroomOutfit)
            trace('nothing yet');

        for (i in 0...wardrobeItems.length)
        {
            var menuItem:Alphabet = new Alphabet(0, (70 * i) + 30, wardrobeItems[i], true, false);
            menuItem.isMenuItem = true;
            menuItem.targetY = i;
            menuItem.ID = i;
            menuItems.add(menuItem);
        }

        bfPreview = new Character(FlxG.width - 500, 0, 'bf', false, true);
        bfPreview.screenCenter(Y);
        add(bfPreview);

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (controls.UP_P)
            changeSelection(-1);

        if (controls.DOWN_P)
            changeSelection(1);

        if (controls.BACK)
            FlxG.switchState(new MainMenuState());

        super.update(elapsed);
    }

    function changeSelection(change:Int)
    {
        curSelected += change;

        if (curSelected > wardrobeItems.length - 1)
            curSelected = 0;

        if (curSelected < 0)
            curSelected = wardrobeItems.length - 1;

        menuItems.forEach(function(item:Alphabet){
            item.targetY = item.ID - curSelected;
        });

        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
    }
}