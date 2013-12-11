import QtQuick 2.1
import QtQuick.Window 2.0

Item
{
    id : mainScreen
    width: Screen.width
    height: Screen.height

    MainView
    {
        id : mainView
        anchors.fill: parent
    }
}
