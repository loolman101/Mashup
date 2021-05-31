package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState, 1, 120, 120)); // AMONG US

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
