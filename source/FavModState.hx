package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class FavModState extends MusicBeatState
{
    var junks:FlxTypedGroup<Alphabet>;

    var curSelected:Int = 0;

    var bgTiles:FlxBackdrop;

    var poops:Array<String> = ['FNF-NEO', 'RADICALONE'];

    var peeps:Array<String> = ['We all know neo, that one funny \nmod with funny and swag \nremixes! Go check it out \nif you havent!\nMade by:\nJellyfish\nMr.M0isty\nEvanClubYT', 'This mod isnt released yet, \nbut feel free to check the \nweb page for updates!\nMade by:\nLancey\nGrantare'];

    var poopoo:Array<FlxSprite> = [new FlxSprite(), new FlxSprite()];

    var penisFart:FlxText;

    override function create()
    {
        FlxG.sound.playMusic('assets/music/Fluffy.ogg');
        add(new FlxSprite().loadGraphic('assets/images/menuBG.png'));

        bgTiles = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		bgTiles.alpha = 0.2;
		bgTiles.scrollFactor.set(0.1, 0);
		add(bgTiles);

        junks = new FlxTypedGroup<Alphabet>();
        add(junks);

        penisFart = new FlxText(FlxG.width * 0.7 + 75, FlxG.height - 335, 0, '', 40);
        penisFart.setFormat("assets/fonts/vcr.ttf", 40, FlxColor.BLACK, CENTER);
        penisFart.screenCenter(X);
        add(penisFart);

        for (i in 0...poops.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, poops[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			junks.add(controlLabel);

            poopoo[i].loadGraphic('assets/images/${poops[i]}.png');
            poopoo[i].setGraphicSize(450);
            poopoo[i].updateHitbox();
            poopoo[i].screenCenter();
            poopoo[i].x += 300;
            poopoo[i].y -= 200;
            poopoo[i].ID = i;
            add(poopoo[i]);
        }

        changeSelection();

        super.create();
    }

    override function update(d:Float)
    {
        bgTiles.x -= -0.27/(120/60);
		bgTiles.y -= -0.63/(120/60);

        if (controls.ACCEPT)
        {
            switch (curSelected)
            {
                case 0:
                    FlxG.openURL('https://gamebanana.com/mods/44230');
                case 1:
                    FlxG.openURL('https://sites.google.com/view/radicalone/home');
            }
        }

        if (controls.UP_P)
            changeSelection(-1);
        if (controls.DOWN_P)
            changeSelection(1);

        if(controls.BACK)
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new MainMenuState());
        }

        super.update(d);
    }

    function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = junks.length - 1;
		if (curSelected >= junks.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

        for (thing in poopoo)
        {
            thing.visible = thing.ID == curSelected;
        }

        penisFart.text = peeps[curSelected];
        penisFart.screenCenter(X);
        penisFart.x += 275;

		for (item in junks.members)
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
}