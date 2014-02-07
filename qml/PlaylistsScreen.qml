import QtQuick 2.2
import "Utils.js" as Utils

Rectangle
{
    color : "#1e2124"
    anchors.fill: parent

    ListView
    {
        id : playlists_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
        }
        height : 50 * mainScreen.dpiMultiplier
        model : core.playlistsModel
        onModelChanged: positionViewAtBeginning();
        orientation: ListView.Horizontal
        interactive : false
        onCurrentIndexChanged :
        {
            playlist_items_listview.model = playlists_listview.model ? playlists_listview.model.get(playlists_listview.currentIndex).playlistItemsModel : undefined
        }

        delegate : Component {
            Item
            {
                width : ListView.view.width / ListView.view.model.count
                height : ListView.view.height

                Rectangle
                {
                    visible : playlists_listview.currentIndex === index
                    color : "#00bbff"
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                        bottom : bottom_border.top
                    }
                    height: 5
                }
                Rectangle
                {
                    id : bottom_border
                    color : "#404040"
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                        bottom : parent.bottom
                    }
                    height: 1
                }

                Text
                {
                    id : playlist_text
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                        top : parent.top
                    }
                    height : parent.height
                    color : "white"
                    text : model.type
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: playlists_listview.currentIndex = index;
                }
            }
        }
    }

    Item
    {
        id : playlist_menu
        anchors
        {
            left : parent.left
            top : playlists_listview.bottom
            bottom : parent.bottom
        }
        width : 50 * mainScreen.dpiMultiplier
        Rectangle
        {
            anchors
            {
                bottom : parent.bottom
                top : parent.top
                right : parent.right
            }
            color : "#404040"
            width : 1
        }
    }

    ListViewFlow
    {
        id : playlist_items_listview
        cacheItemCount: 20
        pathItemCount: mainScreen.portrait ? 6 : 8
        anchors
        {
            bottom : parent.bottom
            left : playlist_menu.right
            right : parent.right
            top : playlists_listview.bottom
        }
        delegate : Component {
            Item
            {
                height : mainScreen.portrait ? PathView.view.width * 0.25 : PathView.view.height * 0.4
                width : height
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? PathView.delScale : 0
                z : PathView.onPath ? PathView.delZ : 0
                scale : del_ma.pressed ? delScale * 1.2 : delScale
                Behavior on scale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}
                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Image
                {
                    id : item_pic
//                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    onStatusChanged : if (status === Image.Ready) pic_anim.start();
                    NumberAnimation {id : pic_anim; target : item_pic; property : "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                    source : model.thumbnailUrl
                    width : parent.width * 0.75
                    height : width
                    anchors
                    {
                        right : parent.right
                        top : parent.top
                    }
                }
                Text
                {
                    id : del_text
                    font.pointSize: 20
                    style: parent.isCurrentItem ? Text.Sunken : Text.Outline
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.title
                    width : parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.capitalization: Font.Capitalize
                    anchors
                    {
                        bottom : duration_text.top
                        left : parent.left
                    }
                }
                Text
                {
                    id : duration_text
                    style: Text.Sunken
                    styleColor: "#ff2200"
                    color : "white"
                    font.family : "Helvetica";
                    font.bold: true
                    font.italic: true
                    font.pointSize: 15 * mainScreen.dpiMultiplier
                    width : parent.width
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    text : Utils.printDuration(model.runtime)
                    anchors
                    {
                        bottom : parent.bottom
                        left : parent.left
                    }
                }
                MouseArea
                {
                    id : del_ma
                    anchors.fill: parent
                    onClicked:
                    {
                        playlist_items_listview.currentIndex = index;
                        core.buttonAction(30, Qt.point(playlists_listview.model.get(playlists_listview.currentIndex).playlistid, index));
                    }
                    onPressAndHold:
                    {
                        core.buttonAction(22, Qt.point(playlists_listview.model.get(playlists_listview.currentIndex).playlistid, index));
                    }
                }
            }
        }
    }

    ListViewFlow
    {
        id : tracks_listview
        cacheItemCount: 10
        flickDeceleration: 150
        anchors
        {
            left : parent.horizontalCenter
            right : parent.right
            top : playlists_listview.bottom
            bottom : parent.verticalCenter
            leftMargin : parent.width * 0.1
            bottomMargin : parent.height * 0.1
        }
        model : playlist_items_listview.model
        pathItemCount: playlist_items_listview.pathItemCount
        currentIndex :playlist_items_listview.currentIndex
        onMovingChanged :
        {
            if (!moving)
                playlist_items_listview.positionViewAtIndex(currentIndex, PathView.Center)
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
                    text : index
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
                        playlist_items_listview.positionViewAtIndex(index, PathView.Center);
                    }
                }
            }
        }
    }
}
