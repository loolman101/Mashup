package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	var isPlayer:Bool;
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;

		loadGraphic('assets/images/iconGrid.png', true, 150, 150);

		antialiasing = true;
		addIcon('bf', 0);
		addIcon('bf-scared', 10);
		addIcon('theo', 4);
		addIcon('theo-lemon', 19);
		addIcon('gf', 17);
		addIcon('calliope', 17);
		addIcon('gene', 2);
		addIcon('senpai', 6);
		addIcon('bf-pixel', 8);
		
		animation.play('bf'); // fix so it doesnt crash when junking djunking ! ! ! 
		animation.play(char);
		scrollFactor.set();
	}

	function addIcon(char:String, cell:Int)
	{
		animation.add(char, [cell, cell + 1], 0, false, isPlayer);
	}
}
