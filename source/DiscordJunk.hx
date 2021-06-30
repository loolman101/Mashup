package;

import Discord.DiscordClient;

// JUST MAKIN THIS CLASS SO I DONT HAVE TO IMPORT DISCORDCLIENT IN EVERY STATE
class DiscordJunk
{
    public static function change(swagText:String, swagSubText:String = null, swagImage:String = 'mashusap', miniImage:String = '')
    {
        DiscordClient.changePresence(swagText, swagSubText, swagImage, 'mashup', miniImage);
    }
}