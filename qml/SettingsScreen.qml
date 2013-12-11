import QtQuick 2.0

Rectangle
{
    color : "#e8e8e8"
    anchors.fill: parent

    Grid
    {
        anchors.centerIn: parent
        columns : 2
        rows : 4
        spacing : 15

        Text
        {
            height: 28
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server URL :";
        }
        TextInputComponent
        {
            width : 200
            text : core.xbmcServerUrl
            onAccepted:  {core.xbmcServerUrl = text}
        }


        Text
        {
            height: 28
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Port :";
        }
        TextInputComponent
        {
            width : 200
            text : core.xbmcServerPort
            onAccepted:  {core.xbmcServerPort = text}
        }

        Text
        {
            height: 28
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Username :";
        }
        TextInputComponent
        {
            width : 200
            text : core.xbmcServerUserName
            onAccepted:  {core.xbmcServerUserName = text}
        }

        Text
        {
            height: 28
            verticalAlignment: Text.AlignVCenter
            text : "XBMC Server Password :";
        }
        TextInputComponent
        {
            width : 200
            text : core.xbmcServerPassword
            echoMode: TextInput.PasswordEchoOnEdit
            onAccepted:  {core.xbmcServerPassword = text}
        }
    }

}
