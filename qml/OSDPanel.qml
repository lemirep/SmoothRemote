import QtQuick 2.1
import "Utils.js" as Utils

Item
{
    id : osd_panel
    Behavior on opacity {NumberAnimation {duration : 750} }
    enabled : opacity === 1
    opacity : shown ? 1 : 0
    anchors
    {
        left : parent.left
        right : parent.right
        bottom : parent.bottom
    }
    property bool shown : false

    property int duration;
    property real advance;
    property bool seekable : false;
    property bool playing;

    signal playPressed();
    signal forwardPressed();
    signal backwardPressed();
    signal stopPressed();
    signal durationSeek(real percentage);

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
                color : "#ff2200"
                border
                {
                    width : 1
                    color : "#ff8800"
                }

                radius : 5
                width : parent.width * (advance / (duration > 0 ? duration : 1))
                Behavior on width {NumberAnimation {duration : 1000}}
                height : 7
                opacity : 0.8
                anchors.verticalCenter : parent.verticalCenter
                anchors.left: parent.left
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    durationSeek(mouseX / width);
                }
            }

            Text
            {
                x : advance_slide.width - (width * 0.5)
                y : - advance_slide.height
                color : "white"
                style: Text.Outline
                styleColor: "#66ff2200"
                font.bold: true
                font.italic: true
                font.family: "Helvetica"
                font.pointSize: 10 * mainScreen.dpiMultiplier
                text : Utils.printDuration(advance)
            }

            Text
            {
                x : parent.width - (width * 0.5)
                y : - advance_slide.height
                color : "white"
                style: Text.Outline
                styleColor: "#66ff2200"
                font.bold: true
                font.italic: true
                font.family: "Helvetica"
                font.pointSize: 10 * mainScreen.dpiMultiplier
                text : Utils.printDuration(duration)
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
                    onClicked: backwardPressed();
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
                    onClicked: stopPressed();
                }
            }
            Image
            {
                id : play_button
                height: parent.height
                source : playing ? "Resources/player_pause.png" : "Resources/player_play.png"
                fillMode: Image.PreserveAspectFit
                scale : play_button_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : play_button_ma
                    anchors.fill: parent
                    onClicked: playPressed();
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
                    onClicked: forwardPressed();
                }
            }
        }
    }
}
