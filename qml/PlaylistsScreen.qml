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

    ListView
    {
        id : playlist_items_listview
        anchors
        {
            bottom : parent.bottom
            left : playlist_menu.right
            right : parent.right
            top : playlists_listview.bottom
        }
        clip : true
        ScrollBar {flickable: playlist_items_listview}

        remove : Transition {
            ParallelAnimation
            {
                NumberAnimation {property : "x"; to : width; duration : 500}
                NumberAnimation {property : "opacity"; to : 0; duration : 500}
            }
        }

        displaced : Transition {
            NumberAnimation {property : "y"; duration : 500}
        }

        delegate : Component {
            Rectangle
            {
                width : ListView.view.width
                height : mainScreen.portrait ? playlist_items_listview.height * 0.1 * mainScreen.dpiMultiplier : playlist_items_listview.width * 0.075 * mainScreen.dpiMultiplier
                color : del_ma.pressed ? "#a0a0a0" : index % 2 === 0 ? "#151515" : "#080808"
                Image
                {
                    id : pic
                    anchors
                    {
                        left : parent.left
                        leftMargin : 15
                        verticalCenter : parent.verticalCenter
                    }
                    height : parent.height * 0.8
                    fillMode: Image.PreserveAspectFit
                    source : model.thumbnailUrl
                }
                Text
                {
                    color : "white"
                    text : model.title
                    anchors
                    {
                        left : pic.right
                        verticalCenter : parent.verticalCenter
                        right : remove_button.left
                        rightMargin : 10
                        leftMargin : 15
                    }
                    width : parent.width - (pic.width + 25)
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 14
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    clip : true
                }
                MouseArea
                {
                    id : del_ma
                    anchors.fill: parent
                    onClicked:
                    {
                        core.buttonAction(30, Qt.point(playlists_listview.model.get(playlists_listview.currentIndex).playlistid, index));
                    }
                }
                Image
                {
                    id : remove_button
                    anchors
                    {
                        right : parent.right
                        rightMargin : 10
                        verticalCenter : parent.verticalCenter
                    }
                    height :  Math.min(55, parent.height * 0.8) * mainScreen.dpiMultiplier
                    fillMode: Image.PreserveAspectFit
                    source : "Resources/remove_inv.png"
                    scale : rm_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : rm_ma
                        anchors.fill: parent
                        onClicked:
                        {
                            core.buttonAction(22, Qt.point(playlists_listview.model.get(playlists_listview.currentIndex).playlistid, index));
                        }
                    }
                }
            }
        }
    }
}
