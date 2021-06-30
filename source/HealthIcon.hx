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
		addIcon('bf-breakdown', 2);
		addIcon('theo', 4);
		addIcon('theo-lemon', 6);
		addIcon('gf', 10);
		addIcon('calliope', 10);
		addIcon('gene', 8);
		addIcon('theo-bsides', 12);
		addIcon('theo-breakdown', 14);
		addIcon('senpai', 20);
		addIcon('bf-pixel', 22);
		
		animation.play('bf'); // fix so it doesnt crash when junking djunking ! ! ! 
		animation.play(char);
		scrollFactor.set();
	}

	function addIcon(char:String, cell:Int)
	{
		animation.add(char, [cell, cell + 1], 0, false, isPlayer);
	}
}
