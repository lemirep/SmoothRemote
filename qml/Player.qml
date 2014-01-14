import QtQuick 2.0
import QtMultimedia 5.0

VideoOutput
{
    id : player_output
    property alias player : player
    property bool osd : false;
    property bool playing : player.playbackState === MediaPlayer.PlayingState
    opacity : playing ? 1 : 0
    anchors.fill: parent
    source: player

    focus : playing

    onPlayingChanged: {if (playing) forceActiveFocus()}

    onActiveFocusChanged:
    {
        console.log("Player Active Focus "  + activeFocus)
    }

    onFocusChanged:
    {
        console.log("Player Focus " + focus)
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

    Rectangle
    {
        color : "black"
        anchors.fill: parent
        opacity: player.playbackState == MediaPlayer.StoppedState ? 0 : 1
        z: -1
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


    MouseArea
    {
        anchors.fill: parent
        enabled: player.playbackState !== MediaPlayer.StoppedState
        onClicked: {player_output.osd = !player_output.osd}
    }


    Item
    {
        id : osd_panel
        height: parent.height * 0.3

        opacity : player.status !== MediaPlayer.NoMedia && player.playbackState !== MediaPlayer.StoppedState && player_output.osd ? 1 : 0
        Behavior on opacity {NumberAnimation {duration : 750} }

        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }

        Column
        {
            width : parent.width

            Item
            {
                height : 40
                anchors
                {
                    left : parent.left
                    right : parent.right
                    margins : 50
                }

                Rectangle
                {
                    color : "grey"
                    radius : 5
                    width : parent.width
                    height : 5
                    opacity : 0.8
                    border
                    {
                        width : 1
                        color : "darkgrey"
                    }

                    anchors.centerIn: parent
                }

                Rectangle
                {
                    id : advance_slide
                    color : "#0099ff"
                    border
                    {
                        width : 1
                        color : "#6699ff"
                    }

                    radius : 5
                    width : parent.width * (player.position / (player.duration > 0 ? player.duration : 1))
                    height : 7
                    opacity : 0.8
                    anchors.verticalCenter : parent.verticalCenter
                    anchors.left: parent.left
                }
            }

            Row
            {
                height : 128
                anchors.horizontalCenter: parent.horizontalCenter

                Image
                {
                    id : fbackward_button
                    height: parent.height
                    source : "Resources/player_fbackward.png"
                    fillMode: Image.PreserveAspectFit
                    scale : fbackward_button_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : fbackward_button_ma
                        anchors.fill: parent
                        onClicked: {if (player.seekable) player.seek(player.position - 1000)}
                        onPressAndHold: {if (player.seekable) player.seek(player.position - 10000)}
                    }
                }

                Image
                {
                    id : stop_button
                    height: parent.height
                    source : "Resources/player_stop.png"
                    fillMode: Image.PreserveAspectFit
                    scale : stop_button_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : stop_button_ma
                        anchors.fill: parent
                        onClicked: {player.stop()}
                    }
                }

                Image
                {
                    id : play_button
                    height: parent.height
                    source : player_output.playing ? "Resources/player_pause.png" : "Resources/player_play.png"
                    fillMode: Image.PreserveAspectFit
                    scale : play_button_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : play_button_ma
                        anchors.fill: parent
                        onClicked: {player_output.playing ? player.pause() : player.play()}
                    }
                }

                Image
                {
                    id : fforward_button
                    height: parent.height
                    source : "Resources/player_fforward.png"
                    fillMode: Image.PreserveAspectFit
                    scale : fforward_button_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : fforward_button_ma
                        anchors.fill: parent
                        onClicked: {if (player.seekable) player.seek(player.position + 1000)}
                        onPressAndHold: {if (player.seekable) player.seek(player.position + 10000)}
                    }
                }
            }
        }
    }

    LoadIndicator
    {
        height: 150
        width: height
        anchors.centerIn: parent
        running : player.status === MediaPlayer.Loading
        loadText: player.bufferProgress * 10000 / 100 + " %"
    }
}
