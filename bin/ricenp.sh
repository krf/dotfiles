#!/bin/bash
# ricenp, one np script to rule them all -- version 1.1
# created by Hunter <hunterm.haxxr@gmail.com> 2010-2012
#
# Continue down for configuration. Arguments are below too.
#
# Current version:
# 7-29-2012 -- let's start numbering our versions. this is version 1.1.
#              multiple formats! listing is below arguments.
#              writes errors to stderr like it should now
#              notify-send is no longer needed
# 7-25-2012 -- fixed totem support... again
#              changed name to ricenp because this script is extremely riced
# 7-23-2012 -- added support for xfce4-genmon-plugin
#              added support for choosing a player manually
#              added lastfm user querying from arguments
#              added play/pause toggling for most players
#                    ...not yet supported for vlc, decibel, or pogo
#              using getopt for argument reading now
#              fixed some players that had broken now playing parsing
#
# Arguments:
#   -p <player>  -- provide a player from the $apps variable and we will try to
#                   query that player instead of a player we've detected
#   -l           -- uses lastfm for showing now playing instead of a local player
#   -u <user>    -- uses <user> instead instead of the lastfm_user specified
#                   in the configuration variable $lastfm_user
#   -x           -- adjusts output format for use with xfce4-genmon-plugin
#   -t           -- toggle playing status of detected or specified player
#   -f <format>  -- uses format instead of format currently in configuration
#   -o           -- list valid formats
#   -h           -- show this help message
#
# Formats:
#   Explanation:
#       I would make the formats customizable by syntax and variables, but once you
#       get into that much customizability and you want mpc-style syntax is becomes
#       very complicated to do. Espically in shell script. But, it might be put in
#       some time. Until then, here's the formats that are available.
#   
#   Normal:
#       np: artist - title (On album/stream <album/stream title>)
#   Compact:
#       np: artist - title [album]
#   Full:
#       now playing: artist - title (On album/stream <album/stream title>)
#   Wordy1:
#       Now Playing: title by artist on <album/stream title>       
#   Wordy2:
#       Now Playing: title by artist [<album/stream title>]
#   Wordy3:
#       np: title by artist on <album/stream title>       
#   Wordy4:
#       np: title by artist [<album/stream title>]
#
# Changelog:
# 7-04-2012 -- added support for pretty much any player anyone uses
#              TODO: support for mplayer (if possible) and dragon player?
#
# 6-21-2012 -- added lastfm support
#              added clementine support (on request of iSpawn)
#
# 6-20-2012 -- fixed some weird bug with mpc
# 6-17-2012 -- updated banshee support
# 2-22-2012 -- added mpd password support
# 2-10-2012 -- added mocp support
# 2-04-2012 -- added spotify support



## Configuration Variables
MPD_HOST="localhost" # <password>@<host> or just <host>, nothing = localhost with no password
MPD_PORT= # uses normal port if empty
lastfm_user="krf" # uses this name if you don't provide one to -l
format="compact2"

# xfce4-genmon related
use_genmon_img=true # if you'd like to show an image in addition to the np stuff
genmon_img="/usr/share/icons/gnome-colors-common/22x22/apps/gmusicbrowser.png"
use_genmon_click=true # if you want to be able to click on the image and execute
                      # the player toggle command

# You may adjust priority in which apps will be checked here.
# You can take out an app if you're sure you won't ever use it.
# Capitalization doesn't matter.
apps="tomahawk clementine totem gmusicbrowser mpd quodlibet rhythmbox pithos amarok spotify vlc pogo mocp nuvolaplayer guayadeque exaile decibel banshee deadbeef audacious2 audacious" 



## Nothing to configure below here.


verdate="July 29th, 2012"
ver="1.1"
all_supported_apps="totem gmusicbrowser mpd clementine quodlibet rhythmbox amarok spotify vlc tomahawk pogo mocp nuvolaplayer guayadeque exaile decibel banshee deadbeef audacious2 audacious xnoise pithos"
formats="normal compact compact2 full wordy1 wordy2 wordy3 wordy4"
format=$(echo "$format" | tr 'A-Z' 'a-z')
while getopts ":f:p:oahtxlu:" opt; do
    case $opt in
        x)
        genmon=true
        ;;
        u)
        lfm_user="$OPTARG"
        ;;
        l)
        if [[ -z "$lfm_user" ]];then
            lfm_user="$lastfm_user"
        fi
        lfm=true
        ;;
        p)
        player="$OPTARG"
        use_specified_player=true
        ;;
        f)
        format="$OPTARG"
        ;;
        o)
        echo "Valid Formats: "
        format2=$(for format3 in $formats;do echo -n "$format3, ";done)
        format2_length=$(echo "$format2" | wc -c)
        format2=$(echo "$format2" | cut -c-$(( $format2_length - 3 )))
        echo -n "$format2."
        echo
        exit
        ;;
        a)
        echo "Supported players: "
        apps2=$(for app in $all_supported_apps;do echo -n "$app, ";done)
        apps2_length=$(echo "$apps2" | wc -c)
        apps2=$(echo "$apps2" | cut -c-$(( $apps2_length - 3 )))
        echo -n "$apps2."
        echo
        exit
        ;;
        t)
        toggle=true
        ;;
        h)
        echo 'ricenp: a now playing script'
        echo "version $ver -- last updated on $verdate"
        echo '(c) 2010-2012 Hunter <hunterm.haxxr@gmail.com>'
        echo
        echo -e "Arguments:
-p <player>\t-- provide a player from the \$apps variable and we will try to
           \t   query that player instead of a player we've detected
-l\t\t-- uses lastfm for showing now playing instead of a local player
-u <user>\t-- uses <user> instead instead of the lastfm user specified
         \t   in the configuration variable \$lastfm_user
-x\t\t-- adjusts output format for use with xfce4-genmon-plugin
-t\t\t-- toggle playing status of detected or specified player
-f <format>\t-- uses format instead of format currently in configuration
-o\t\t-- list valid formats
-h\t\t-- show this help message"
        echo 
        exit
        ;;
        \?)
        echo "-$OPTARG is not a valid option." >&2
        exit 2
        ;;
    esac
done

apikey="57caa77e0d0a2f2adaa8d2c82d19b9b3"
if [[ "$lfm" == 'true' ]];then
    shift
    data=$(wget -qO - "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&nowplaying=true&user=$lfm_user&api_key=$apikey&limit=1&format=json") 
    case "$data" in
        '{"error":6,"message":"No user with that name was found"}')
        echo "ricenp: It appears that that LastFM username is not valid." >&2
        exit 2
        ;;
        '{"error"'*)
        echo "ricenp: There was an error while trying to reach LastFM." >&2
        exit 3
        ;;
    esac
        
    artist=$(echo "$data" | sed 's/.*"artist":{"#text":"//;s/","mbid":".*"name":".*//')
    album=$(echo "$data" | sed 's/.*"streamable".*,"album":{"#text":"//;s/","mbid".*,"url":.*//')
    title=$(echo "$data" | sed 's/.*"},"name":"//;s/","streamable".*//')
    case "$format" in
        normal)
        echo "np: $artist - $title (On album $album)"
        ;;
        compact)
        echo "np: $artist - $title [$album]"
        ;;
        compact2)
        echo "np: $artist ($album) - $title"
        ;;
        full)
        echo "Now Playing: $artist - $title (On album $album)"
        ;;
        wordy1)
        echo "Now Playing: $title by $artist on $album"
        ;;
        wordy2)
        echo "Now Playing: $title by $artist [$album]"
        ;;
        wordy3)
        echo "np: $title by $artist on $album"
        ;;
        wordy4)
        echo "np: $title by $artist [$album]"
        ;;
        *)
        echo "ricenp: \"$format\" is not a valid format. Use -o for a listing of valid formats."
        ;;
    esac
    exit
fi

shopt -u extglob
export MPD_HOST
export MPD_PORT

imlast() {
    if [[ -z $(pgrep -f ".*$lc.*") ]];then
        if [[ "$genmon" == 'true' ]];then
            echo
            exit
        fi
        echo "ricenp: It appears you're not playing anything." >&2
        exit 1
    fi
}


dochecks() {
    if [[ -z "$type" ]];then
        type='album'
    fi
    
    if [[ -z "$title" ]];then
        title="<no title>"
    elif [[ "$type" == "stream" ]];then
        title="$stream_title"
    else
        title="$title"
    fi

    if [[ -z "$artist" || "$type" == "stream" ]];then
        artist="<no artist>"
    fi

    if [[ -z "$album" ]];then
        album="<no album>"
    else
        album="$album"
    fi
    
    if [[ -z "$album" && -z "$artist" && -z "$title" ]];then
        if [[ "$genmon" == 'true' ]];then
            echo
            exit
        fi
        echo "ricenp: It appears you're not playing anything." >&2
        exit 1
    fi
}

saynp() {
    case "$format" in
        normal)
        np="np: $artist - $title (On $type $album)"
        ;;
        compact)
        np="np: $artist - $title [$album]"
        ;;
        compact2)
        np="np: $artist ($album) - $title"
        ;;
        full)
        np="Now Playing: $artist - $title (On $type $album)"
        ;;
        wordy1)
        np="Now Playing: $title by $artist on $album"
        ;;
        wordy2)
        np="Now Playing: $title by $artist [$album]"
        ;;
        wordy3)
        np="np: $title by $artist on $album"
        ;;
        wordy4)
        np="np: $title by $artist [$album]"
        ;;
        *)
        np="ricenp: \"$format\" is not a valid format. Use -o for a listing of valid formats."
        ;;
    esac
    if [[ "$genmon" == "true" ]];then
        if [[ "$use_genmon_img" == "true" ]];then
            img="<img>$genmon_img</img>"
        fi
        if [[ "$use_genmon_click" == "true" ]];then
            if [[ -z "$player_toggle_command" ]];then
                player_toggle_command="echo 'ricenp: This player does not have a toggle command... yet.' >&2"
            fi
            click="<click>$player_toggle_command</click>"
        fi
        echo "$click$img<txt>$np</txt>"
    else
        echo "$np"
    fi
}

checkandnp() {
    dochecks
    if [[ "$toggle" == 'true' ]];then
        if [[ -z "$player_toggle_command" ]];then
            echo 'ricenp: This player does not have a toggle command... yet.' >&2
        fi
        exec -- $player_toggle_command 2>/dev/null >/dev/null
    fi
    saynp
}

amount=$(echo "$apps" | wc -w)
if [[ "$use_specified_player" == 'true' ]];then
    lc=$(echo "$player" | tr '[A-Z]' '[a-z]')
else
    for app in $apps;do
        lc=$(echo "$app" | tr '[A-Z]' '[a-z]')
        if [[ ! -z $(pgrep -f ".*$lc.*") ]];then
            APP="$app"
            lc=$(echo "$APP" | tr '[A-Z]' '[a-z]')
            app="$lc"
            break
        fi
    done
fi

case $lc in
    totem)
    imlast
    player_toggle_command="totem --play-pause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.totem /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*"mpris:trackid" variant string "file:\/\///;s/" ) .*//'))
    album=
    artist=
    checkandnp
    ;;
    vlc)
    imlast
    player_toggle_command= # not currently implemented
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) dict entry( .*//'))
    album=
    artist=
    checkandnp
    ;;
    tomahawk)
    imlast
    player_toggle_command="dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.tomahawk /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) ].*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:album" variant string "//;s/" ) dict entry( .*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:artist" variant array \[ string "//;s/" \] ) dict entry( .*//'))
    checkandnp
    ;;  
    pogo)
    imlast
    player_toggle_command= # couldn't find a command or a dbus-send way of doing it that worked correctly
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.pogo /Player org.freedesktop.MediaPlayer.GetMetadata 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "title" variant string "//;s/" ) dict entry( .*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "album" variant string "//;s/" ) dict entry( .*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "artist" variant string "//;s/" ) dict entry( .*//'))
    checkandnp
    ;;
    pithos)
    imlast
    player_toggle_command="dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.pithos /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.pithos /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'MetaData' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) dict entry( .*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:album" variant string "//;s/" ) dict entry( .*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:artist" variant array \[ string "//;s/" \] ) dict entry( .*//'))
    checkandnp
    ;;
    nuvolaplayer)
    imlast
    player_toggle_command="dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.nuvolaplayer /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.nuvolaplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) dict entry( string ".*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:album" variant string "//;s/" ) dict entry( string ".*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:artist" variant string "//;s/" ) dict entry( string ".*//'))
    checkandnp
    ;;
    guayadeque)
    imlast
    player_toggle_command="dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.guayadeque /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    data=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.guayadeque /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null)
    title=$(echo $(echo $data | sed 's/.*xesam:title" variant string "//;s/" ) dict entry( .*//'))
    album=$(echo $(echo $data | sed 's/.*xesam:album" variant string "//;s/" ) dict entry( .*//'))
    artist=$(echo $(echo $data | sed 's/.*xesam:artist" variant array \[ string "//;s/" ] ) dict entry(.*//'))
    checkandnp
    ;;
    xnoise)
    imlast
    player_toggle_command="dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.xnoise /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.xnoise /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) ]*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:album" variant string "//;s/" ) dict.*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:artist" variant array \[ string "//;s/" \] ) dict.*//'))
    checkandnp
    ;;
    gmusicbrowser)
    imlast
    player_toggle_command="gmusicbrowser -cmd PlayPause"
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.gmusicbrowser /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' 2>/dev/null | tr -d '\n' 2>/dev/null))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:title" variant string "//;s/" ) dict.*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:album" variant string "//;s/" ) dict.*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "xesam:artist" variant array \[ string "//;s/" \] ) dict.*//'))
    checkandnp
    ;;
    exaile)
    imlast
    player_toggle_command="exaile --play-pause"
    artist=$(exaile --get-artist 2>/dev/null)
    album=$(exaile --get-album 2>/dev/null)
    title=$(exaile --get-title 2>/dev/null)
    checkandnp
    ;;
    decibel)
    imlast
    player_toggle_command= # couldn't find a command or a dbus-send way of doing it that worked correctly
    data=$(echo $(dbus-send --print-reply --session --dest=org.mpris.dap /Player org.freedesktop.MediaPlayer.GetMetadata))
    title=$(echo $(echo "$data" | sed 's/.*dict entry( string "title" variant string "//;s/" ) dict entry( .*//'))
    album=$(echo $(echo "$data" | sed 's/.*dict entry( string "album" variant string "//;s/" ) dict entry( .*//'))
    artist=$(echo $(echo "$data" | sed 's/.*dict entry( string "artist" variant string "//;s/" ) dict entry( .*//'))
    checkandnp
    ;;
    mocp)
    imlast
    player_toggle_command="mocp -G"
    artist=$(mocp --format "%artist" 2>/dev/null)
    album=$(mocp --format "%album" 2>/dev/null)
    title=$(mocp --format "%song" 2>/dev/null)
    checkandnp
    ;;
    spotify)
    imlast
    data=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')
    url=$(echo $(echo "$data" | sed 's/.*xesam:url".*variant.*string "//;s/".*//'))
    title=$(echo $(echo "$data" | sed 's/.*xesam:title"//;s/).*//;s/.*string "//;s/"//'))
    album=$(echo $(echo "$data" | sed 's/.*xesam:album"//;s/).*//;s/.*string "//;s/"//'))
    artist=$(echo $(echo "$data" | sed 's/.*xesam:artist"//;s/).*//;s/.*string "//;s/"//;s/]//'))
    checkandnp
    ;;
    mpd)
    imlast
    player_toggle_command="mpc toggle"
    title=$(mpc -f '%title%' current 2>/dev/null)
    artist=$(mpc -f '%artist%' current 2>/dev/null)
    album=$(mpc -f '%album%' current 2>/dev/null)
    checkandnp
    ;;
    rhythmbox)
    imlast
    player_toggle_command="rhythmbox-client --play-pause"
    title=$(rhythmbox-client --print-playing-format "%tt" 2>/dev/null)
    artist=$(rhythmbox-client --print-playing-format "%aa" 2>/dev/null)
    album=$(rhythmbox-client --print-playing-format "%at" 2>/dev/null)
    stream_title=$(rhythmbox-client --print-playing-format "%st" 2>/dev/null)
    
    if [[ ! -z "$stream_title" ]];then
        artist=
        album="$title"
        title="$stream_title"
        checkandnp
    else
        checkandnp
    fi
    ;;
    banshee)
    imlast
    player_toggle_command="banshee --toggle-playing"
    info=$(banshee --query-title --query-artist --query-album --query-current-state 2>/dev/null || banshee-1 --query-title --query-artist --query-album --query-current-state 2>/dev/null)
    title=$(echo "$info" | cut -d' ' -f2- | head -n1)
    artist=$(echo "$info" | grep "artist: " | cut -d' ' -f2-)
    album=$(echo "$info" | grep "album: " | cut -d' ' -f2-)
    checkandnp

    ;;
    deadbeef)
    imlast
    player_toggle_command="deadbeef --play-pause"
    artist=$(deadbeef --nowplaying "%a" 2>/dev/null)
    album=$(deadbeef --nowplaying "%b" 2>/dev/null)
    title=$(deadbeef --nowplaying "%t" 2>/dev/null)
    checkandnp
    ;;
    quodlibet)
    imlast
    player_toggle_command="quodlibet --play-pause"
    artist=$(quodlibet --print-playing "<artist>" 2>/dev/null)
    album=$(quodlibet --print-playing "<album>" 2>/dev/null)
    title=$(quodlibet --print-playing "<title>" 2>/dev/null)
    checkandnp
    ;;
    clementine)
    imlast
    player_toggle_command="clementine -t"
    data=$(qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata 2>/dev/null)
    artist=$(echo "$data" | grep ":artist: " | cut -d' ' -f2-)
    album=$(echo "$data" | grep ":album: " | cut -d' ' -f2-)
    title=$(echo "$data" | grep ":title: " | cut -d' ' -f2-)
    checkandnp
    ;;
    amarok)
    imlast
    player_toggle_command="amarok -t"
    data=$(qdbus org.kde.amarok /Player GetMetadata 2>/dev/null)
    artist=$(echo "$data" | grep "^artist: " | cut -d' ' -f2-)
    album=$(echo "$data" | grep "^album: " | cut -d' ' -f2-)
    title=$(echo "$data" | grep "^title: " | cut -d' ' -f2-)
    checkandnp
    ;;
    audacious)
    imlast
    player_toggle_command="audtool playback-playpause"
    artist=$(audtool current-song-tuple-data artist)
    album=$(audtool current-song-tuple-data album)
    title=$(audtool current-song-tuple-data title)
    checkandnp
    ;;
esac
exit
