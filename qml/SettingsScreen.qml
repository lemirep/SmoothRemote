import QtQuick 2.2
import QtGraphicalEffects 1.0

Item
{
    anchors.fill: parent

    Component.onCompleted: forceActiveFocus();
    Component.onDestruction: core.saveSettings();

    Keys.onReleased:
    {
        if (event.key === Qt.Key_Backspace)
            event.accepted = true;
    }

    LinearGradient
    {
        anchors.fill: parent
        start: Qt.point(width, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop {position: 0; color: "#25282d"}
            GradientStop {position: 1; color: "black"}
        }
    }

    Text
    {
        fontSizeMode: Text.Fit
        font.bold: true
        font.italic: true
        font.family: "Helvetica"
        style: Text.Sunken
        styleColor: "#44ff2200";
        color : "#44111111";
        text : "Settings"
        font.pointSize: 200
        anchors
        {
            top : parent.top
            bottom : parent.verticalCenter
            left : parent.horizontalCenter
            right : parent.right
            margins : 25
        }
    }

    Grid
    {
        anchors.centerIn: parent
        columns : mainScreen.portrait ? 1 : 2
        rows : mainScreen.portrait ? 8 : 4
        spacing : 15

        Text
        {
            font.bold: true
            font.italic: true
            font.family: "Helvetica"
            styleColor: "#44ff2200";
            style: Text.Outline
            color : "white";
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server URL :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            focusColor: "#ff3300"
            backgroundColor: "#333333"
            textColor: "white"
            placeHolderColor: "#aaaaaa"
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerUrl
            onAccepted:  {core.xbmcServerUrl = text}
        }


        Text
        {
            font.bold: true
            font.italic: true
            font.family: "Helvetica"
            styleColor: "#44ff2200";
            style: Text.Outline
            color : "white";
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Port :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            focusColor: "#ff3300"
            backgroundColor: "#333333"
            textColor: "white"
            placeHolderColor: "#aaaaaa"
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerPort
            onAccepted:  {core.xbmcServerPort = text}
        }

        Text
        {
            font.bold: true
            font.italic: true
            font.family: "Helvetica"
            styleColor: "#44ff2200";
            style: Text.Outline
            color : "white";
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Username :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            focusColor: "#ff3300"
            backgroundColor: "#333333"
            textColor: "white"
            placeHolderColor: "#aaaaaa"
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerUserName
            onAccepted:  {core.xbmcServerUserName = text}
        }

        Text
        {
            font.bold: true
            font.italic: true
            font.family: "Helvetica"
            styleColor: "#44ff2200";
            style: Text.Outline
            color : "white";
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Password :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            focusColor: "#ff3300"
            backgroundColor: "#333333"
            textColor: "white"
            placeHolderColor: "#aaaaaa"
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerPassword
            echoMode: TextInput.PasswordEchoOnEdit
            onAccepted:  {core.xbmcServerPassword = text}
        }
    }
}
