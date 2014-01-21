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
        onModelChanged: playlists_listview.currentIndex = 0;
        orientation: ListView.Horizontal
        interactive : false
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
        model : playlists_listview.model.get(playlists_listview.currentIndex).playlistItemsModel
        delegate : Component {
            Rectangle
            {
                width : ListView.view.width
                height : 70
                color : index % 2 === 0?  "#101010" : "#505050"
                Text
                {
                    anchors.centerIn: parent
                    color : "white"
                    text: model.title
                }
            }
        }
    }
}
