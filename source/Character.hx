package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var outFitModifier:String;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false, ?isPreview:Bool = false, outFitModifier:String = '')
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;
		this.outFitModifier = outFitModifier;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		// trace(curCharacter);

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/characters/Calliope_Assets.png', 'assets/images/characters/Calliope_Assets.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				if (isPreview)
					animation.addByPrefix('idle', 'Calliope Idle', 24, true);
				else
				{
					animation.addByPrefix('idle', 'Calliope Idle', 24, false);
				}
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -22);
				addOffset('idle', -250, 0);

				addOffset("singUP", 0, 0);
				addOffset("singRIGHT", 0, -9);
				addOffset("singLEFT", 0, -22);
				addOffset("singDOWN", 0, -25);
				addOffset('hairBlow', 0, -9);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -11);

				playAnim('idle');
			case 'speakers':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/Speaker_Alone.png', 'assets/images/characters/Speaker_Alone.xml');
				animation.addByPrefix('idle', 'speaker going boom boom', 24, isPreview);
				playAnim('idle');
			case 'calliope':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/CalliopeStanding.png', 'assets/images/characters/CalliopeStanding.xml');
				animation.addByPrefix('idle', 'calliope idle', 24, isPreview);
				animation.addByPrefix('singUP', 'calliope up', 24, false);
				animation.addByPrefix('singDOWN', 'calliope down', 24, false);
				animation.addByPrefix('singLEFT', 'calliope left', 24, false);
				animation.addByPrefix('singRIGHT', 'calliope right', 24, false);

				addOffset('idle');
				addOffset("singUP", -4, 10);
				addOffset("singRIGHT", 25, -8);
				addOffset("singLEFT", 13, -2);
				addOffset("singDOWN", -14, -10);

				playAnim('idle');
			case 'theo-lemon':
				tex = FlxAtlasFrames.fromSparrow('assets/images/characters/TheoDemon_FINISHED_Assets.png', 'assets/images/characters/TheoDemon_FINISHED_Assets.xml');
				frames = tex;
				if (isPreview)
					animation.addByPrefix('idle', 'monster idle', 24, true);
				else
					animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);
				animation.addByPrefix('meAndAcidicWhenAmongUs', 'laughter', 24, false);
				animation.addByPrefix('swipe', 'thankyourocket', 24, false);

				addOffset('idle', -70, 130);
				addOffset("singUP", 45, 118);
				addOffset("singRIGHT", 0, -10);
				addOffset("singLEFT", -6, 160);
				addOffset("singDOWN", -11, -22);
				addOffset('meAndAcidicWhenAmongUs', -30, 6);
				addOffset('swipe', 46, 289);
				playAnim('idle');

			case 'bf-breakdown':

					var tex = FlxAtlasFrames.fromSparrow('assets/images/characters/bfThatSong.png', 'assets/images/characters/bfThatSong.xml');
					frames = tex;

					animation.addByPrefix('idle', 'BF idle dance', 24, isPreview);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);

					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					animation.addByPrefix('scared', 'BF idle shaking', 24);

					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);

					playAnim('idle');

					if (!isPreview)
						flipX = true;

			case 'bf':
					var bfType:String = 'bf';

					if (!isPreview)
					{
						switch(PlayState.SONG.song.toLowerCase())
						{
							case 'dread':
								//bfType = 'scared';
								trace('imagine forgetting to wake lancey up!');
						}
					}

					var tex = FlxAtlasFrames.fromSparrow('assets/images/boyfriend/$bfType$outFitModifier.png', 'assets/images/boyfriend/$bfType$outFitModifier.xml');
					frames = tex;

					animation.addByPrefix('idle', 'BF idle dance', 24, isPreview);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);

					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					animation.addByPrefix('scared', 'BF idle shaking', 24);

					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);

					playAnim('idle');

					if (!isPreview)
						flipX = true;
			case 'theo':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/Theo_FINISHED_Assets.png', 'assets/images/characters/Theo_FINISHED_Assets.xml');
				animation.addByPrefix('vore', 'theo VORE', 24, false);
				if (isPreview)
					animation.addByPrefix('idle', 'theo idle', 24, true);
				else
					animation.addByPrefix('idle', 'theo idle', 24, false);
				animation.addByPrefix('singUP', 'theo up', 24, false);
				animation.addByPrefix('singRIGHT', 'theo right', 24, false);
				animation.addByPrefix('singLEFT', 'theo left', 24, false);
				animation.addByPrefix('singDOWN', 'theo down', 24, false);
				animation.addByPrefix('creppy', 'creppy', 24 ,false);

				addOffset('vore');
				addOffset('idle', 0, 11);
				addOffset('singUP', 19, 54);
				addOffset('singRIGHT', -24, 37);
				addOffset('singLEFT', 53, 5);
				addOffset('singDOWN', 13, -30);
				addOffset('creppy', -11, 12);

				playAnim('idle');
			case 'theo-breakdown':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/theoThatSong.png', 'assets/images/characters/theoThatSong.xml');
				animation.addByPrefix('idle', 'theo idle', 24, isPreview);
				animation.addByPrefix('singUP', 'theo up', 24, false);
				animation.addByPrefix('singRIGHT', 'theo right', 24, false);
				animation.addByPrefix('singLEFT', 'theo left', 24, false);
				animation.addByPrefix('singDOWN', 'theo down', 24, false);

				addOffset('idle', 0, 11);
				addOffset('singUP', 60, 64);
				addOffset('singRIGHT', -14, 37);
				addOffset('singLEFT', 51, 7);
				addOffset('singDOWN', 13, -30);

				playAnim('idle');
			case 'gene':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/Gene_Assets.png', 'assets/images/characters/Gene_Assets.xml');
				animation.addByPrefix('idle', 'gene idle', 24, isPreview);
				animation.addByPrefix('singUP', 'gene up', 24, false);
				animation.addByPrefix('singDOWN', 'gene down', 24, false);
				animation.addByPrefix('singLEFT', 'gene left', 24, false);
				animation.addByPrefix('singRIGHT', 'gene right', 24, false);
				animation.addByPrefix('lightning', 'gene lightning', 24, false);
				animation.addByPrefix('what', 'gene let the bass go', 24, false);

				addOffset('idle');
				addOffset('singUP', -3, 22);
				addOffset('singDOWN', 51, -49);
				addOffset('singLEFT', 39, -13);
				addOffset('singRIGHT', -16, -3);
				addOffset('lightning', 35, 34);
				addOffset('what', 60, 61);
			case 'bf-pixel': // why they decided to use actual week 6 is beyond me
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/bfPixel.png', 'assets/images/characters/bfPixel.xml');
				animation.addByPrefix('idle', 'BF IDLE', 24, isPreview);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				if (!isPreview)
					flipX = true;
			case 'bf-pixel-dead':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/bfPixelsDEAD.png', 'assets/images/characters/bfPixelsDEAD.xml');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				if (!isPreview)
					flipX = true;
			case 'gf-pixel':
				tex = FlxAtlasFrames.fromSparrow('assets/images/characters/gfPixel.png', 'assets/images/characters/gfPixel.xml');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'senpai':
				frames = FlxAtlasFrames.fromSparrow('assets/images/characters/senpai.png', 'assets/images/characters/senpai.xml');
				animation.addByPrefix('idle', 'Senpai Idle', 24, isPreview);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'og-gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'spooky' | 'gf-pixel':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				case 'gf':
					danced = !danced;

					if (!danced)
						playAnim('idle', true);
					else if (PlayState.SONG != null) {if (PlayState.SONG.song == 'Fear-the-Funk') 
						playAnim('idle', true);
					}	
					else
						playAnim('idle', false);
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		// trace(animOffsets);

		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'og-gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
