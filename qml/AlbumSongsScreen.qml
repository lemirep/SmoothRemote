import QtQuick 2.1

Item
{
    id : album_songs_item
    property alias model : songs_listview.model
    property int albumId;
    property bool shown : false

    opacity : 0
    enabled: opacity !== 0
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
        Row
        {
            spacing : 25
            anchors
            {
                right : parent.right
                top : parent.top
                bottom : parent.bottom
                rightMargin : 25
            }

            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/play_inv.png"
                MouseArea
                {
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
                MouseArea
                {
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
            }
        }
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
                property bool editMode : false
                width : songs_listview.width
                height : mainScreen.portrait ? songs_listview.height * 0.1 * mainScreen.dpiMultiplier : songs_listview.width * 0.075 * mainScreen.dpiMultiplier
                Rectangle
                {
                    anchors.fill: parent
                    color : song_del_ma.pressed ? "#a0a0a0" : index % 2 === 0 ? "#151515" : "#080808"
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
                    width : parent.width - (song_cover_pic.width + 25)
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 14
                }
                MouseArea
                {
                    id : song_del_ma
                    anchors.fill: parent
                    onClicked: {editMode = true}
                }
                Row
                {
                    id : songs_action
                    spacing : 25
                    anchors
                    {
                        verticalCenter : parent.verticalCenter
                        right : parent.right
                        rightMargin : 25
                    }
                    opacity : editMode ? 1 : 0
                    enabled : editMode
                    Behavior on opacity {NumberAnimation {duration : 250}}
                    height : 65
                    Image
                    {
                        height: parent.height - 15
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source : "Resources/play_inv.png"
                        scale : play_button_ma.pressed ? 0.9 : 1
                        MouseArea
                        {
                            id : play_button_ma
                            anchors.fill: parent
                            onClicked: core.buttonAction(14, model.file);
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
                        scale : add_button_ma.pressed ? 0.9 : 1
                        MouseArea
                        {
                            id : add_button_ma
                            anchors.fill: parent
                            onClicked: core.buttonAction(25, model.songid);
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
                        scale : cloud_button_ma.pressed ? 0.9 : 1
                        MouseArea
                        {
                            id : cloud_button_ma
                            anchors.fill: parent
                            onClicked: ;
                        }
                    }
                    Image
                    {
                        height: parent.height - 15
                        rotation : 180
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source : "Resources/download_inv.png"
                        scale : dl_button_ma.pressed ? 0.9 : 1
                        MouseArea
                        {
                            id : dl_button_ma
                            anchors.fill: parent
                            onClicked: ;
                        }
                    }
                }
                Timer
                {
                    running : editMode
                    interval : 5000
                    repeat : false
                    onTriggered: editMode = !editMode
                }
            }
        }
    }
}
