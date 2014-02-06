import QtQuick 2.1
import "Utils.js" as Utils

Item
{
    id : album_songs_item
    property alias model : songs_listview.model
    property int albumId;
    property bool shown : false

    enabled: shown

    states : [
        State
        {
            PropertyChanges {target: album_songs_item; opacity : 1}
            when : shown
        }
    ]

    transitions: [
        Transition
        {
            NumberAnimation { target: album_songs_item; property: "opacity"; duration: 800; easing.type: Easing.InOutQuad }
        }
    ]

    ActionBar
    {
        id : action_bar
        Row
        {
            spacing : 25
            anchors
            {
                right : parent.right
                verticalCenter : parent.verticalCenter
                rightMargin : 25
            }
            height : 55 * mainScreen.dpiMultiplier

            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/play_inv.png"
                scale : play_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : play_ma
                    anchors.fill: parent
                    onClicked: core.buttonAction(-1);
                }
            }
            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/plus_inv.png"
                scale : add_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : add_ma
                    anchors.fill: parent
                    onClicked: core.buttonAction(16, albumId);
                }
            }
            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/cloud_inv.png"
                scale : cloud_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : cloud_ma
                    anchors.fill: parent
                }
            }
        }
    }

    ListViewFlow
    {
        id : songs_listview
        pathItemCount: mainScreen.portrait ? 4 : 6
        cacheItemCount: 8
        leftToRight: false
        flickDeceleration: 75
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            bottom : action_bar.top
        }

        delegate : Component {
            Image
            {
                id : song_cover_pic

                property bool editMode : false
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? (isCurrentItem) ? 1.25 : PathView.delScale : 0

                height : mainScreen.portrait ? PathView.view.width * 0.25 : PathView.view.height * 0.4
                width : height
                scale: delScale
                opacity : 0.8
                fillMode: Image.PreserveAspectFit
                source : model.thumbnailUrl
                asynchronous : true
                z : isCurrentItem ? 1 : 0

                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}
                onStatusChanged : if (status === Image.Ready) pic_anim.start();
                NumberAnimation {id : pic_anim; target : song_cover_pic; property : "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}

                transform: Rotation {
                    angle : -45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5
                    origin.y : height * 0.5
                }

                Text
                {
                    id : song_title_text
                    z : isCurrentItem ? 1 : 0
                    style: Text.Sunken
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.title
                    anchors
                    {
                        left : song_cover_pic.right
                        leftMargin : 5
                        top : song_cover_pic.verticalCenter
                        topMargin : 15
                    }
                    width : parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 15
                    font.capitalization: Font.Capitalize
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
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
                    font.pointSize: 18 * mainScreen.dpiMultiplier
                    width : parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    text : Utils.printDuration(model.runtime)
                    anchors
                    {
                        top : song_title_text.bottom
                        left : song_cover_pic.right
                    }
                }

                MouseArea
                {
                    id : song_del_ma
                    scale : 1.25
                    anchors.fill: parent
                    onClicked:
                    {
                        if (parent.isCurrentItem)
                            editMode = true;
                        else
                            songs_listview.currentIndex = index;
                    }
                }

                MediaActionBar
                {
                    id : media_action_bar
                    opacity : editMode ? 1 : 0
                    onPlayClicked: core.buttonAction(14, model.file);
                    onAddClicked:  core.buttonAction(25, model.songid);
                    onStreamClicked: core.buttonAction(27, model.streamingFile);
                    width : parent.width
                    anchors
                    {
                        left : song_title_text.left
                        top : duration_text.bottom
                    }

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
        id : tracks_listview
        leftToRight: false
        cacheItemCount: 8
        flickDeceleration: 150
        anchors
        {
            left : parent.left
            right : parent.horizontalCenter
            top : parent.top
            bottom : parent.verticalCenter
        }
        model : songs_listview.model
        pathItemCount: songs_listview.pathItemCount
        currentIndex : songs_listview.currentIndex

        onMovingChanged :
        {
            if (!moving)
                songs_listview.positionViewAtIndex(currentIndex, PathView.Center)
        }

        delegate : Component {
            Item
            {
                width : 100
                height : width
                property bool isCurrentItem : index === PathView.view.currentIndex;
                z : isCurrentItem ? 1 : 0

                transform: Rotation {
                    angle : -45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Text
                {
                    text : model.track
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
                        songs_listview.positionViewAtIndex(index, PathView.Center);
                    }
                }
            }
        }
    }
}
