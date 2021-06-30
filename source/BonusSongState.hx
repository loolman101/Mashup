package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import Song.SwagSong;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class BonusSongState extends MusicBeatState
{
    var songs:Array<String> = ['Corruption-BSides', 'GIG', 'Contemplating-Space', 'Breakdown'];
    var poopoo:FlxTypedGroup<Alphabet>;
    var micdUpIRL:FlxBackdrop;

    var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

    var coolDadPreviews:FlxTypedGroup<Character>;
    var coolBfPreviews:FlxTypedGroup<Character>;

    var fullComboCoin:FlxSprite;
    var scoreText:FlxText;

    override function create()
    {
        super.create();

        DiscordJunk.change('In Menus');

        var ui_tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');
        
        add(new FlxSprite().loadGraphic('assets/images/menuBG.png'));

        micdUpIRL = new FlxBackdrop('assets/images/Literal_Micd_Up.png', 1, 1, true, true);
		micdUpIRL.alpha = 0.35;
		add(micdUpIRL);

        fullComboCoin = new FlxSprite(-95, FlxG.height - 250);
		fullComboCoin.frames = FlxAtlasFrames.fromSparrow('assets/images/fullCombo.png', 'assets/images/fullCombo.xml');
		fullComboCoin.animation.addByPrefix('idle', 'Shiny', 24, true);
		fullComboCoin.animation.play('idle');
		fullComboCoin.setGraphicSize(Std.int(fullComboCoin.width * 0.4));
		fullComboCoin.updateHitbox();
        fullComboCoin.screenCenter(X);
		fullComboCoin.antialiasing = true;
		fullComboCoin.visible = false;
        add(fullComboCoin);

        var titleText:FlxSprite = new FlxSprite(0, 25);
		titleText.frames = FlxAtlasFrames.fromSparrow('assets/images/Freeplay_Junk.png', 'assets/images/Freeplay_Junk.xml');
		titleText.animation.addByPrefix('idle', 'story mode white', 24, true);
		titleText.animation.play('idle');
		titleText.setGraphicSize(0, 150);
		titleText.updateHitbox();
		titleText.antialiasing = true;
		titleText.screenCenter(X);
		add(titleText);

        scoreText = new FlxText(FlxG.width * 0.7, titleText.height + 35, 0, "", 45);
		scoreText.setFormat("assets/fonts/vcr.ttf", 45, FlxColor.BLACK, RIGHT);
        add(scoreText);

        poopoo = new FlxTypedGroup<Alphabet>();
        add(poopoo);

        coolDadPreviews = new FlxTypedGroup<Character>();
        add(coolDadPreviews);

        coolBfPreviews = new FlxTypedGroup<Character>();
        add(coolBfPreviews);

        for (i in 0...songs.length)
        {
            var evanAndAcidicAreArguing:Alphabet = new Alphabet(0, 70 * i + 30, songs[i], true, false);
            evanAndAcidicAreArguing.isSpoar = true;
            evanAndAcidicAreArguing.targetX = i;
            evanAndAcidicAreArguing.ID = i;
            poopoo.add(evanAndAcidicAreArguing);

            var daSong:SwagSong = Song.loadFromJson(songs[i].toLowerCase(), songs[i].toLowerCase());

            var coolSwagThing:String = 'bf';

            switch (daSong.song.toLowerCase())
            {
                case 'breakdown':
                    coolSwagThing = 'scared';
            }

            var coolBfChar:Character = new Character(732, 392, daSong.player1, false, true, FlxG.save.data.curOutfit, coolSwagThing);
            var poopAndFart = coolBfChar.height;
            coolBfChar.setGraphicSize(0, 320);
            coolBfChar.updateHitbox();
            coolBfChar.ID = i;
            coolBfPreviews.add(coolBfChar);

            var coolDadChar:Character = new Character(252, 384, daSong.player2, false, true);
            if (daSong.player2 == 'senpai')
            {
                coolDadChar.setGraphicSize(0, 544);
                coolDadChar.x -= 115;
            }
            else if (daSong.player2 == 'vanus')
            {
                coolDadChar.setGraphicSize(0, Std.int(coolDadChar.height / (poopAndFart / coolBfChar.height)));
                coolDadChar.x -= 125;
            }
            else
                coolDadChar.setGraphicSize(0, Std.int(coolDadChar.height / (poopAndFart / coolBfChar.height)));
            coolDadChar.updateHitbox();
            coolDadChar.ID = i;
            coolDadPreviews.add(coolDadChar);
        }

        repositionCrap();

        leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.screenCenter();
		leftArrow.x -= FlxG.width / 2.5;
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.screenCenter();
		rightArrow.x += FlxG.width / 2;
		add(rightArrow);

        changeSelection(0);
    }

    function repositionCrap()
    {
        return null;
    }

    override function update(njdsmk:Float)
    {
        micdUpIRL.x -= -0.27/(120/60); // POOOOOOOP!!!
		micdUpIRL.y -= 0.63/(120/60);

        lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

        scoreText.text = 'PERSONAL BEST: $lerpScore';
        scoreText.screenCenter(X);

        fullComboCoin.visible = Highscore.getSongFC(songs[curSelected]);

        if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
        
        if (controls.LEFT_P)
            changeSelection(-1);

        if (controls.RIGHT_P)
            changeSelection(1);

        if (controls.RIGHT)
            rightArrow.animation.play('press')
        else
            rightArrow.animation.play('idle');

        if (controls.LEFT)
            leftArrow.animation.play('press');
        else
            leftArrow.animation.play('idle');

        if (controls.BACK)
        {
            FlxG.sound.music.stop();
            FlxG.switchState(new MainMenuState());
        }

        coolBfPreviews.forEach(function(char:Character){
            FlxTween.cancelTweensOf(char);
            if (char.ID == curSelected)
                FlxTween.tween(char, {y: 392}, 0.075, {ease: FlxEase.bounceOut});
            else
                FlxTween.tween(char, {y: 740}, 0.075, {ease: FlxEase.bounceOut});
        });

        coolDadPreviews.forEach(function(char:Character){
            FlxTween.cancelTweensOf(char);
            if (char.ID == curSelected)
            {
                if (char.curCharacter == 'senpai')
                    FlxTween.tween(char, {y: FlxG.height - char.height + 20}, 0.075, {ease: FlxEase.bounceOut});  
                else
                    FlxTween.tween(char, {y: FlxG.height - (char.height + 20)}, 0.075, {ease: FlxEase.bounceOut});
            }
            else
                FlxTween.tween(char, {y: 740}, 0.075, {ease: FlxEase.bounceOut});
        });

        if (controls.ACCEPT)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), 1);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
			PlayState.isStoryMode = false;
            PlayState.isBonusSong = true;
			PlayState.storyDifficulty = 1;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
        
        super.update(njdsmk);
    }

    var curSelected:Int = 0;
    var lerpScore:Int = 0;
	var intendedScore:Int = 0;

    function changeSelection(change:Int)
    {
        curSelected += change;

        if (curSelected > songs.length - 1)
            curSelected = 0;

        if (curSelected < 0)
            curSelected = songs.length - 1;

        poopoo.forEach(function(item:Alphabet){
            item.targetX = item.ID - curSelected;
        });

        intendedScore = Highscore.getScore(songs[curSelected], 1);

        FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

        FlxG.sound.playMusic('assets/music/' + songs[curSelected] + "_Inst" + TitleState.soundExt, 0);
    }
}