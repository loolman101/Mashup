package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic('assets/images/iconGrid.png', true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('theo', [4, 5], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('theo-lemon', [19, 20], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}
}
