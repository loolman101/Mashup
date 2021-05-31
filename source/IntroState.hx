package;

import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import lime.app.Application;
import openfl.Assets;
import polymod.Polymod;

using StringTools;

class IntroState extends MusicBeatState
{
    var introCool:FlxSprite;
    var introConfirme:FlxSprite;
    var isAllowed:Bool = true;

    override public function create()
    {

        FlxG.sound.playMusic('assets/music/title.ogg', 1);

        FlxG.mouse.visible = false;


        introCool = new FlxSprite(340,191);
        introCool.frames = FlxAtlasFrames.fromSparrow('assets/images/Intro.png', 'assets/images/Intro.xml');
        introCool.animation.addByPrefix('INTRO', 'awesomeIntro', 24);
        introCool.setGraphicSize(Std.int(introCool.width * 2.13333333));
        introCool.antialiasing = true;
        add(introCool);

        introConfirme = new FlxSprite(340,191);
        introConfirme.frames = FlxAtlasFrames.fromSparrow('assets/images/Intro.png', 'assets/images/Intro.xml');
        introConfirme.animation.addByPrefix('INTRO', 'Intro Confirm', 12, false);
        introConfirme.setGraphicSize(Std.int(introCool.width * 2.13333333));
        introConfirme.antialiasing = true;

        introCool.animation.play('INTRO'); 
        
        Conductor.changeBPM(102);
		persistentUpdate = true;
		persistentDraw = true;
        PlayerSettings.init();
    }
//stinky
    override function update(elapsed:Float)
    {

        if (FlxG.keys.justPressed.ENTER && isAllowed == true)
        {
            add(introConfirme);
            introCool.alpha = 0;
            isAllowed = false;
            FlxG.sound.music.stop();
            trace('ddrrt');

            introConfirme.animation.play('INTRO', true);
            FlxG.sound.play('assets/music/titleShoot.ogg', 1, false, null, true, function()
            {
                FlxG.switchState(new TitleState());
             });
        }

        super.update(elapsed);
    }
}