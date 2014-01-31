import QtQuick 2.1

Rectangle
{
    color : "#e8e8e8"
    anchors.fill: parent

    Component.onCompleted: forceActiveFocus();

    Component.onDestruction: core.saveSettings();

    Keys.onReleased:
    {
        if (event.key === Qt.Key_Backspace)
            event.accepted = true;
    }

    Grid
    {
        anchors.centerIn: parent
        columns : mainScreen.portrait ? 1 : 2
        rows : mainScreen.portrait ? 8 : 4
        spacing : 15

        Text
        {
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server URL :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerUrl
            onAccepted:  {core.xbmcServerUrl = text}
        }


        Text
        {
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Port :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerPort
            onAccepted:  {core.xbmcServerPort = text}
        }

        Text
        {
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Username :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerUserName
            onAccepted:  {core.xbmcServerUserName = text}
        }

        Text
        {
            height: 28 * mainScreen.dpiMultiplier
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Password :";
            font.pointSize: 11 * mainScreen.dpiMultiplier
        }
        TextInputComponent
        {
            width : 250 * mainScreen.dpiMultiplier
            text : core.xbmcServerPassword
            echoMode: TextInput.PasswordEchoOnEdit
            onAccepted:  {core.xbmcServerPassword = text}
        }
    }
}
