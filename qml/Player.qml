import QtQuick 2.1
import QtMultimedia 5.0

Rectangle
{
    id : player_area
    color : "#1e2124"
    anchors.fill: parent
    property alias player : player
    property bool osd : false;
    property bool xbmcPlaying : false
    property real xbmcAdvance : 0;
    property int  xbmcRuntime : 0;
    property bool localPlaying : player.playbackState === MediaPlayer.PlayingState
    property bool playing : localPlaying || xbmcPlaying
    property bool local : (player.playbackState !== MediaPlayer.StoppedState)
    focus : playing
    onPlayingChanged: {if (playing) forceActiveFocus()}
    onLocalPlayingChanged: mainScreen.mediaPlaying = localPlaying;
    Component.onCompleted:
    {
        if (mainView.movieToPlay)
        {
            player.source = mainView.movieToPlay;
            mainView.movieToPlay = "";
            player.play();
        }
    }

    Timer
    {
        interval: 1000
        running : !local
        repeat : true
        onTriggered: {core.refreshPlayers();}
    }

    Keys.onReleased:
    {
        console.log("Player Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            if (local)
                player.stop();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_VolumeUp)
        {
            if (!local)
                return ;
            player.volume
            event.accepted = true;
            if (volume < 1.0)
                volume += 0.1;
        }
        else if (event.key === Qt.Key_VolumeDown)
        {
            if (!local)
                return ;
            event.accepted = true;
            if (volume > 0.0)
                volume -= 0.1;
        }
    }

    ListView
    {
        id : xbmc_player
        anchors.fill: parent
        model : core.xbmcPlayersModel
        opacity : local ? 0 : 1
        interactive : false
        delegate : Component {
            Image
            {
                id: back_img

                source : model.playerItemsModel.get(0).thumbnailUrl
                fillMode: Image.PreserveAspectFit
                width : xbmc_player.width
                height : xbmc_player.height

                property int speed : model.speed;
                property real advance : model.percentage * 0.01;
                property real duration : model.playerItemsModel.get(0).runtime

                onDurationChanged: {xbmcRuntime = duration; console.log("Duration << " + duration)}
                onSpeedChanged: {xbmcPlaying = speed > 0}
                onAdvanceChanged: {xbmcAdvance = advance * duration;}

                Text
                {
                    anchors
                    {
                        horizontalCenter : parent.horizontalCenter
                        top : parent.top
                        topMargin : 50
                    }
                    color : "white"
                    font.pointSize: 15 * mainScreen.dpiMultiplier
                    text : model.playerItemsModel.get(0).title
                }
            }
        }
    }

    MediaPlayer
    {
        id : player;
        onErrorStringChanged: console.log(errorString);
        volume : 0.3
    }

    VideoOutput
    {
        id : player_output
        opacity :  player.playbackState !== MediaPlayer.StoppedState ? 1 : 0
        anchors.fill: parent
        source: player
        enabled : (opacity === 1)

        LoadIndicator
        {
            height: 150
            width: height
            anchors.centerIn: parent
            running : player.status === MediaPlayer.Loading
            loadText: Math.floor(player.bufferProgress * 100) + " %"
        }
    }

    MouseArea
    {
        anchors.fill: parent
        enabled: playing || !local
        onClicked: {osd = !osd;}
    }

    Timer
    {
        running : osd
        interval: 5000
        repeat: false
        onTriggered: {osd = !osd}
    }

    OSDPanel
    {
        id : osd_panel
        height : parent.height * 0.3
        shown : osd
        playing : local ? localPlaying : xbmcPlaying
        advance: local ? player.position * 0.001 : xbmcAdvance
        duration : local ? player.duration * 0.001: xbmcRuntime

        onPlayPressed:
        {
            if (local)
            {
                if (localPlaying)
                    player.pause();
                else
                    player.play();
            }
            else
                core.buttonAction(7);
        }

        onStopPressed:
        {
            if (local)
                player.stop();
            else
                core.buttonAction(8);
        }

        onForwardPressed:
        {
            if (!local)
            {
                core.buttonAction(9);
            }
        }

        onBackwardPressed:
        {
            if (!local)
            {
                core.buttonAction(10);
            }
        }

        onDurationSeek:
        {
            if (!local)
            {
                core.buttonAction(11, percentage * 100)
            }
        }
    }
}
