import QtQuick 2.1

Item
{
    id : textFocusScope

    property alias placeHolder : placeHolderText.text
    property alias echoMode : textInput.echoMode
    property alias text : textInput.text
    signal accepted()
    height : 28 * mainScreen.dpiMultiplier

    Rectangle
    {
        height: parent.height
        anchors.fill: parent
        radius : 5
        border
        {
            width : 1
            color : textInput.activeFocus ? "#0099cc" : "#404040"
        }
    }

    Text
    {
        id : placeHolderText
        anchors.fill: parent
        anchors.leftMargin: 8
        verticalAlignment: Text.AlignVCenter
        text: "Type something..."
        color: "gray"
        font.italic: true
        visible : textInput.text.length === 0
        font.pointSize: 11 * mainScreen.dpiMultiplier
    }

    TextInput
    {
        id : textInput
        clip : true
        anchors
        {
            left : parent.left
            right : parent.right
            leftMargin : 8
            rightMargin : 8
            verticalCenter : parent.verticalCenter
        }
        selectByMouse: true
        onAccepted: {textFocusScope.accepted(); textInput.focus = false}
        onFocusChanged: textFocusScope.accepted()
        font.pointSize: 11 * mainScreen.dpiMultiplier
    }
}
