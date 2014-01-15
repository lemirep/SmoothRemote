import QtQuick 2.1

Rectangle
{
    id : action_bar
    anchors
    {
        left : parent.left
        right : parent.right
        bottom : parent.bottom
    }
    height : (enabled) ? 70 * mainScreen.dpiMultiplier : 0
    color : "#101010"
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
            GradientStop {position : 1.0; color : "#aa101010"}
            GradientStop {position : 0.0; color : "#00101010"}
        }
    }
}
