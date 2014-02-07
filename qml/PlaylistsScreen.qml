import QtQuick 2.1

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
        cacheItemCount: 12
        anchors
        {
            bottom : parent.bottom
            left : playlist_menu.right
            right : parent.right
            top : playlists_listview.bottom
        }
        delegate : Component {
            Image
            {
                id : artist_delegate
                height : mainScreen.portrait ? PathView.view.width * 0.25 : PathView.view.height * 0.4
                width : height
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? (isCurrentItem) ? 1.25 : PathView.delScale : 0

                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}

                asynchronous: true
                fillMode: Image.PreserveAspectFit
                onStatusChanged : if (status === Image.Ready) pic_anim.start();
                NumberAnimation {id : pic_anim; target : artist_delegate; property : "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                scale : del_ma.pressed ? delScale * 1.2 : delScale
                z : isCurrentItem ? 1 : 0
                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                source : model.thumbnailUrl
                smooth : true
                Text
                {
                    id : del_text
                    font.pointSize: 20
                    style: parent.isCurrentItem ? Text.Sunken : Text.Outline
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.title
                    width : 2 * parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.capitalization: Font.Capitalize
                    anchors
                    {
                        top : parent.bottom
                        left : mainScreen.portrait ? undefined : parent.left
                        right : !mainScreen.portrait ? undefined : parent.right
                    }
                }
                MouseArea
                {
                    id : del_ma
                    anchors.fill: parent
                    scale : 1.25
                    onClicked:
                    {
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
}
