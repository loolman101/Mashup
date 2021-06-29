package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import Controls.Control;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class WardrobeMenu extends MusicBeatState
{
    var wardrobeItems:Array<String> = ['NORMAL'];
    var wardrobeCharNames:Array<String> = ['', '-theo', '-cnf'];

    var menuItems:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;

    var bfPreviews:FlxTypedGroup<Character>;

    override function create()
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuBG.png');
        add(bg);

        menuItems =  new FlxTypedGroup<Alphabet>();
        add(menuItems);

        bfPreviews =  new FlxTypedGroup<Character>();
        add(bfPreviews);

        if (FlxG.save.data.theoOutfit)
            wardrobeItems.push('THEO OUTFIT');
        if (FlxG.save.data.spaceroomOutfit)
            trace('nothing yet');

        /*for (i in ['COMMUNITY NIGHT FUNKIN'])
        {
            wardrobeItems.push(i);
        }*/

        for (i in 0...wardrobeItems.length)
        {
            var menuItem:Alphabet = new Alphabet(0, (70 * i) + 30, wardrobeItems[i], true, false);
            menuItem.isMenuItem = true;
            menuItem.targetY = i;
            menuItem.ID = i;
            menuItems.add(menuItem);

            var bfPreview = new Character(FlxG.width - 500, 0, 'bf', false, true, wardrobeCharNames[i]);
            bfPreview.screenCenter(Y);
            bfPreview.ID = i;
            bfPreviews.add(bfPreview);
        }

        curSelected = wardrobeCharNames.indexOf(FlxG.save.data.curOutfit);

        changeSelection(0);

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

        if (controls.ACCEPT)
        {
            FlxG.save.data.curOutfit = wardrobeCharNames[curSelected];
            FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, 0.7);
            for (junkers in menuItems)
            {
                if (junkers.ID == curSelected)
                    FlxFlicker.flicker(junkers, 1, 0.06, true, false);
                else
                    FlxTween.tween(junkers, {alpha: 0}, 0.4, {
                        ease: FlxEase.quadOut,
                        onComplete: function(twn:FlxTween)
                        {
                            junkers.kill();
                        }
                    });
            }
            for (flStudio in bfPreviews)
            {
                if (flStudio.ID == curSelected){ flStudio.playAnim('hey');
                    FlxFlicker.flicker(flStudio, 1, 0.06, true, false, function(flick:FlxFlicker)
                    {
                        FlxG.switchState(new MainMenuState());
                    });
                }
            }
        }

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

        for (bf in bfPreviews)
        {
            bf.visible = bf.ID == curSelected;
        }

        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
    }
}