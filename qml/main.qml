import QtQuick 2.1
import QtQuick.Window 2.1

Window
{
    id : mainScreen
    width: Screen.width
    height: Screen.height
    //    minimumWidth : 240;
    //    minimumHeight : 240;
    //    maximumWidth: Screen.width
    //    maximumHeight: Screen.height
    //    contentOrientation: Qt.Pr

    property bool portrait : height > width;
    property bool mediaPlaying : false;
    property string screenSize : setScreenSize(Screen.pixelDensity)

    onPortraitChanged:
    {
        if (!portrait)
        {
            width = Screen.width
            height = Screen.height
        }
        else
        {
            width = Screen.height
            height = Screen.width
        }
    }

    property real dpiMultiplier : 1;

    function setScreenSize(dpi)
    {
        dpi *= 25.4;
        console.log("DPI " + dpi);
        if (dpi >= 320)
        {
            dpiMultiplier = 1.75;
            return "xhdpi";
        }
        if (dpi >= 240)
        {
            dpiMultiplier = 1.5;
            return "hdpi";
        }
        if (dpi >= 160)
        {
            dpiMultiplier = 1.25;
            return "mdpi";
        }
        dpiMultiplier = 1;
        return "ldpi";
    }

    MainView
    {
        id : mainView
        anchors.fill: parent
    }
}
