package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songFC:Map<String, Bool> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songFC:Map<String, Bool> = new Map<String, Bool>();
	#end


	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);


		#if !switch
		NGio.postScore(score, song);
		#end


		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveFC(song:String, fc:Bool = false):Void
	{
		var daSongCool:String = formatSong(song, 1);
	
	
		if (songFC.exists(daSongCool))
		{
			if (fc == true)
				setFC(daSongCool, fc);
		}
		else
			setFC(daSongCool, fc);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{

		#if !switch
		NGio.postScore(score, "Week " + week);
		#end


		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	public static function saveWeekFC(week:Int = 1, fc:Bool = false):Void
	{
		var daWeekCool:String = formatSong('week' + week, 1);
	
		if (songFC.exists(daWeekCool))
		{
			if (songFC.get(daWeekCool) == true)
				setFC(daWeekCool, fc);
		}
		else
			setFC(daWeekCool, fc);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setFC(song:String, fc:Bool):Void
	{
		// among us stinky imposter!!!!
		songFC.set(song, fc);
		FlxG.save.data.songFC = songFC;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function getSongFC(song:String):Bool
	{
		if (!songFC.exists(formatSong(song, 1)))
			setFC(formatSong(song, 1), false);
		
		return songFC.get(formatSong(song, 1));
	}

	public static function getWeekFC(week:Int):Bool
	{
		if (!songFC.exists(formatSong('week' + week, 1)))
			setFC(formatSong('week' + week, 1), false);
		
		return songFC.get(formatSong('week' + week, 1));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}

		if (FlxG.save.data.songFC != null)
		{
			songFC = FlxG.save.data.songFC;
		}
	}
}
