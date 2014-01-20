import QtQuick 2.1

Item
{
    anchors.fill: parent

    ListModel
    {
        id : remote_model
        ListElement
        {
            tabName : "Remote"
            delegateComponent : "RemoteControls.qml"
        }
        ListElement
        {
            tabName : "Playlist"
            delegateComponent : "PlaylistsScreen.qml"
        }
        ListElement
        {
            tabName : "Player"
            delegateComponent : ""
        }
    }

    ListView
    {
        id : section_switcher_listview
        height : 70 * mainScreen.dpiMultiplier
        model : remote_model
        orientation : ListView.Horizontal
        interactive: false
        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        delegate: Component {
            Rectangle
            {
                width : ListView.view.width / 3
                height : ListView.view.height
                color : "#e5e5e5"
                Text
                {
                    anchors.centerIn: parent
                    color : "black"
                    text : model.tabName
                    font.pointSize: 15 * mainScreen.dpiMultiplier
                }
                Rectangle
                {
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                        bottom : parent.bottom
                    }
                    height : 10
                    color : "#00ccff"
                    visible: index === remote_listview.currentIndex
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: remote_listview.currentIndex = index;
                }
            }
        }

        Rectangle
        {
            anchors
            {
                bottom : parent.top
                left : parent.left
                right : parent.right
            }
            height : 5
            gradient : Gradient {
                GradientStop {position : 0.0; color : "#aa000000"}
                GradientStop {position : 1.0; color : "#00000000"}
            }
        }
    }

    ListView
    {
        id : remote_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            bottom : section_switcher_listview.top
        }
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        model : remote_model
        orientation : ListView.Horizontal
        delegate : Component {
            Loader
            {
                width : ListView.view.width
                height : ListView.view.height
                source: model.delegateComponent
            }
        }
    }
}
