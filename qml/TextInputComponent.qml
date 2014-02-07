import QtQuick 2.1

Item
{
    id : textFocusScope

    property alias placeHolder : placeHolderText.text
    property alias echoMode : textInput.echoMode
    property alias text : textInput.text
    signal accepted()
    height : 28 * mainScreen.dpiMultiplier

    property color focusColor : "#0099cc";
    property color unfocusColor :  "#404040";
    property alias backgroundColor : back_rec.color
    property alias textColor : textInput.color
    property alias placeHolderColor : placeHolderText.color

    Rectangle
    {
        id : back_rec
        height: parent.height
        anchors.fill: parent
        radius : 5
        border
        {
            width : 1
            color : textInput.activeFocus ? focusColor : unfocusColor
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
