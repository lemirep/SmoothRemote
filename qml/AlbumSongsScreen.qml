import QtQuick 2.1

Item
{
    id : album_songs_item
    property alias model : songs_listview.model
    property bool shown : false

    opacity : 0
    enabled: shown
    focus : shown

    onShownChanged:
    {
        if (shown)
            forceActiveFocus();
    }

    Keys.onReleased:
    {
        console.log("Detail Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            shown = false;
            event.accepted = true;
        }
    }

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

    Rectangle
    {
        anchors.fill: parent
        color : "#1e2124"
        opacity: 1
    }

   ActionBar
   {
       id : action_bar
   }

    ListView
    {
        id : songs_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            bottom : action_bar.top
        }
        clip : true

        ScrollBar {flickable: songs_listview}

        delegate : Component {
            Item
            {
                width : songs_listview.width
                height : mainScreen.portrait ? songs_listview.height * 0.1 * mainScreen.dpiMultiplier : songs_listview.width * 0.075 * mainScreen.dpiMultiplier
                Rectangle
                {
                    anchors.fill: parent
                    color : index % 2 === 0 ? "#101010" : "#080808"
                }
                Image
                {
                    id : song_cover_pic
                    anchors
                    {
                        left : parent.left
                        leftMargin : 15
                        verticalCenter : parent.verticalCenter
                    }
                    height : parent.height * 0.8
                    fillMode: Image.PreserveAspectFit
                    source : model.thumbnail
                }
                Text
                {
                    color : "white"
                    text : model.title
                    anchors
                    {
                        left : song_cover_pic.right
                        verticalCenter : parent.verticalCenter
                        leftMargin : 15
                    }
                    width : parent.width - song_cover_pic.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 14
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        core.buttonAction(14, model.file);
                    }
                }
            }
        }
    }
}
