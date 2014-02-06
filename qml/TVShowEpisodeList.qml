import QtQuick 2.2
import "Utils.js" as Utils

Item
{

    property bool shown;
    property alias model : episode_listview.model
    enabled : shown;

    ListViewFlow
    {
        id : episode_listview
        anchors.fill: parent
        delegate : Component {
            Image
            {
                id : episode_cover_pic
                property bool editMode : false
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? (isCurrentItem) ? 1.25 : PathView.delScale : 0

                z : isCurrentItem ? 1 : 0
                scale : delScale * 1
                width : episode_listview.width * 0.25
                height : mainScreen.portrait ? episode_listview.height * 0.15 * mainScreen.dpiMultiplier : episode_listview.width * 0.1 * mainScreen.dpiMultiplier
                fillMode: Image.PreserveAspectCrop
                source : model.thumbnailUrl
                asynchronous: true

                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}

                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                }

                Text
                {
                    id : episode_title_text
                    text : model.title
                    anchors
                    {
                        right : episode_cover_pic.horizontalCenter
                        top : parent.bottom
                    }
                    style: parent.isCurrentItem ? Text.Sunken : Text.Outline
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    width : parent.width * 1.5
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 14 * mainScreen.dpiMultiplier
                    opacity : mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                }
                Text
                {
                    id : duration_text
                    style: Text.Sunken
                    z : isCurrentItem ? 1 : 0
                    styleColor: "#ff2200"
                    color : "white"
                    font.family : "Helvetica";
                    font.bold: true
                    font.italic: true
                    font.pointSize: 12 * mainScreen.dpiMultiplier
                    width : parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    text : Utils.printDuration(model.runtime)
                    anchors
                    {
                        top : episode_title_text.bottom
                        right : episode_title_text.right
                    }
                }

                MouseArea
                {
                    id : episode_del_ma
                    anchors.fill: parent
                    onClicked: {editMode = true}
                }
                MediaActionBar
                {
                    id : media_action_bar
                    anchors
                    {
                        left : episode_title_text.left
                        top : duration_text.bottom
                    }

                    onPlayClicked: core.buttonAction(14, model.file);
                    onAddClicked: {core.buttonAction(17, model.episodeid);}
                    onStreamClicked:  mainView.launchMediaPlayer(model.streamingFile); /*core.buttonAction(27, model.streamingFile);*/
                    opacity : editMode ? 1 : 0
                    Behavior on opacity {NumberAnimation {duration : 250}}
                }
                Timer
                {
                    running : editMode
                    interval : 3000
                    repeat : false
                    onTriggered: editMode = !editMode
                }
            }
        }
    }

    ListViewFlow
    {
        id : episode_idx_listview
        pathItemCount: mainScreen.portrait ? 7 : 9
        cacheItemCount: 10
        anchors
        {
            left : parent.horizontalCenter
            right : parent.right
            top : parent.top
            bottom : parent.verticalCenter
        }
        flickDeceleration: 150
        model : episode_listview.model
        currentIndex: episode_listview.currentIndex

        onMovingChanged :
        {
            if (!moving)
                episode_listview.positionViewAtIndex(currentIndex, PathView.Center);
        }

        delegate : Component {
            Item
            {
                width : 100
                height : width
                property bool isCurrentItem : index === PathView.view.currentIndex;
                z : isCurrentItem ? 1 : 0

                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Text
                {
                    text : model.episode
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    anchors.centerIn: parent
                    style: Text.Sunken
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#ff2200"
                    font.pointSize: 45
                    font.family : "Helvetica";
                    font.bold: true
                    scale : parent.isCurrentItem ? 1.5 : 0.8
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        episode_listview.positionViewAtIndex(index, PathView.Center);
                        artist_idx_listview.currentIndex = index;
                    }
                }
            }
        }
    }
}
