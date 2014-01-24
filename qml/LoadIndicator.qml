import QtQuick 2.1

Item
{
    id : load_indicator_item
    property alias loadText : load_text.text
    property bool running : false;

    opacity: running ? 1 : 0
    Behavior on opacity {NumberAnimation {duration: 500}}

    Rectangle
    {
        id : loader_ring
        radius : 180
        height : parent.height
        width : height
        anchors.centerIn: parent
        gradient : Gradient {
            GradientStop {position: 1.0; color : "#282828"}
            GradientStop {position: 0.0; color : "white"}
        }

        RotationAnimation on rotation
        {
            loops: Animation.Infinite
            running: load_indicator_item.running
            from : 0
            to : 360
            duration : 2000
        }
    }

    Rectangle
    {
        radius : 180
        height: parent.height - 40
        width: height
        anchors.centerIn: loader_ring
        color : "#1e2124"

        Text
        {
            id : load_text
            color : "white"
            anchors.centerIn: parent
        }
    }
}
