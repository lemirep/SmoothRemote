import QtQuick 2.1
import QtMultimedia 5.0

Rectangle
{
    id : player_area
    color : "#1e2124"
    anchors.fill: parent
    property alias player : player
    property bool osd : false;
    property bool playing : player.playbackState === MediaPlayer.PlayingState
    property bool local : false
    focus : playing
    onPlayingChanged: {if (playing) forceActiveFocus()}

    Component.onCompleted:
    {
        if (mainView.movieToPlay)
        {
            player.source = mainView.movieToPlay;
            mainView.movieToPlay = "";
            player.play();
            playLocalMedia();
        }
    }

    function playLocalMedia()
    {
        local = true;
        osd_panel.duration = player.duration;
        osd_panel.advance = player.position;
    }

    function playXBMCMedia()
    {
        local = false;
    }

    Keys.onReleased:
    {
        console.log("Player Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            player.stop();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_VolumeUp)
        {
            player.volume
            event.accepted = true;
            if (volume < 1.0)
                volume += 0.1;
        }
        else if (event.key === Qt.Key_VolumeDown)
        {
            event.accepted = true;
            if (volume > 0.0)
                volume -= 0.1;
        }
    }

    MediaPlayer
    {
        id : player;
        onErrorStringChanged: console.log(errorString);
        volume : 0.3
        onPlaybackStateChanged:
        {
            if (player.playbackState === MediaPlayer.PlayingState)
                mainScreen.mediaPlaying = true;
            else
                mainScreen.mediaPlaying = false;
        }
    }

    PinchArea
    {
        anchors.fill: parent
        pinch.maximumScale: 2
        pinch.minimumScale: 0.5
        pinch.target: player_output

        property real oldScale;
        onPinchStarted: oldScale = player_output.scale;
    }

    VideoOutput
    {
        id : player_output
        opacity :  player.playbackState !== MediaPlayer.StoppedState ? 1 : 0
        anchors.fill: parent
        source: player
        enabled : (opacity === 1)

        MouseArea
        {
            anchors.fill: parent
            enabled: player.playbackState !== MediaPlayer.StoppedState
            onClicked: {osd = !osd;}
        }

        LoadIndicator
        {
            height: 150
            width: height
            anchors.centerIn: parent
            running : player.status === MediaPlayer.Loading
            loadText: Math.floor(player.bufferProgress * 100) + " %"
        }
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
        playing : local ? player_area.playing : false

        onPlayPressed:
        {

        }

        onStopPressed:
        {

        }

        onForwardPressed:
        {

        }

        onBackwardPressed:
        {

        }
    }
}
