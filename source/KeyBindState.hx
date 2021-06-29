package;

import Controls.Control;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import Controls.KeyboardScheme;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class KeyBindState extends MusicBeatState
{
    var isWaitingInput:Bool = false;

    var daControls:Array<String> = ['LEFT TO ${Controls.realControls[0]}', 'DOWN TO ${Controls.realControls[1]}', 'UP TO ${Controls.realControls[2]}', 'RIGHT TO ${Controls.realControls[3]}', 'RESET TO ${Controls.realControls[4]}'];

    var thoseThings:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;

    var bgTiles:FlxBackdrop;

    override function create()
    {
        var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFF21d2a8;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        bgTiles = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		bgTiles.alpha = 0.2;
		bgTiles.scrollFactor.set(0.1, 0);
		add(bgTiles);

        thoseThings =  new FlxTypedGroup<Alphabet>();
        add(thoseThings);

        for (i in 0...daControls.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, daControls[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			thoseThings.add(controlLabel);
        }

        super.create();
    }

    override function update(d:Float)
    {
        super.update(d);

        bgTiles.x -= -0.27/(120/60);
		bgTiles.y -= -0.63/(120/60);

        if (controls.ACCEPT && !isWaitingInput)
        {
            isWaitingInput = true;
            new FlxTimer().start(0, function(tmr:FlxTimer){
                if (!FlxG.keys.pressed.ENTER && !FlxG.keys.pressed.SPACE)
                {
                    new FlxTimer().start(0, function(controlTimer:FlxTimer){
                        if (FlxG.keys.justPressed.ANY)
                        {
                            if (FlxG.keys.anyPressed(Controls.KeysNotToBindTo))
                            {   
                                FlxG.sound.play('assets/sounds/S2_6D' + TitleState.soundExt, 0.4);
                                controlTimer.reset();
                            }
                            else
                                setNewBind();
                        }
                        else
                            controlTimer.reset();
                    });
                }
                else
                    tmr.reset();
            });
        }

        if (controls.UP_P && !isWaitingInput)
            changeSelection(-1);
        if (controls.DOWN_P && !isWaitingInput)
            changeSelection(1);

        if(controls.BACK && !isWaitingInput)
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new MainMenuState());
        }
    }

    function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = thoseThings.length - 1;
		if (curSelected >= thoseThings.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in thoseThings.members)
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

    /*{ JUST ME TRYNA REMEMBER HOW TO SWAP JUNK IN ARRAYS
        var cooInt:Int = 2;
        var cursel:Int = 0
        var swagArray:Array = [1, 2, 3];
        var lastKey = swagArray[swagArray.indexOf(coolInt)];
        swagArray[swagArray.indexOf(coolInt)] = swagArray[cursel];
        swagArray[cursel] = lastKey;
    }*/ 

    function setNewBind():Void
    {
        var curKeyPressed = FlxG.keys.getIsDown()[0].ID;
        trace(curKeyPressed);
        if (Controls.realControls.contains(curKeyPressed))
        {
            var lastKey = Controls.realControls.indexOf(curKeyPressed);
            Controls.realControls[Controls.realControls.indexOf(curKeyPressed)] = Controls.realControls[curSelected];
            Controls.realControls[curSelected] = curKeyPressed;

            Controls.reloadControls();

            controls.setKeyboardScheme(KeyboardScheme.Solo, true);
            daControls = ['LEFT TO ${Controls.realControls[0]}', 'DOWN TO ${Controls.realControls[1]}', 'UP TO ${Controls.realControls[2]}', 'RIGHT TO ${Controls.realControls[3]}', 'RESET TO ${Controls.realControls[4]}'];

            thoseThings.remove(thoseThings.members[curSelected]);
            var controlLabel:Alphabet = new Alphabet(0, (70 * curSelected) + 30, daControls[curSelected], true, false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = 0;
            thoseThings.add(controlLabel);

            if (lastKey != curSelected)
            {
                thoseThings.remove(thoseThings.members[lastKey]);
                var controlLabel:Alphabet = new Alphabet(0, (70 * lastKey) + 30, daControls[lastKey], true, false);
                controlLabel.isMenuItem = true;
                controlLabel.targetY = lastKey - curSelected;
                thoseThings.add(controlLabel);
            }
        }
        else
        {
            Controls.realControls[curSelected] = curKeyPressed;

            Controls.reloadControls();

            controls.setKeyboardScheme(KeyboardScheme.Solo, true);
            daControls = ['LEFT TO ${Controls.realControls[0]}', 'DOWN TO ${Controls.realControls[1]}', 'UP TO ${Controls.realControls[2]}', 'RIGHT TO ${Controls.realControls[3]}', 'RESET TO ${Controls.realControls[4]}'];
            thoseThings.remove(thoseThings.members[curSelected]);
            var controlLabel:Alphabet = new Alphabet(0, (70 * curSelected) + 30, daControls[curSelected], true, false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = 0;
            thoseThings.add(controlLabel);
        }
        new FlxTimer().start(0.1, function(endingTimer:FlxTimer){
            isWaitingInput = false;
        });
    }
}