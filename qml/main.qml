import QtQuick 2.1
import QtQuick.Window 2.0

Item
{
    id : mainScreen
    width: Screen.width
    height: Screen.height

    property bool portrait : height > width;
    property bool mediaPlaying : false;
    property string screenSize : setScreenSize(Screen.pixelDensity)

    property real dpiMultiplier;

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
