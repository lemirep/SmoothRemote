import QtQuick 2.0

Item
{
    id : delegate_item
    property alias source : delegate_pic.source
    property alias text : delegate_text.text
    property alias fillMode : delegate_pic.fillMode
    signal clicked();

    Image
    {
        id : delegate_pic
        fillMode: Image.PreserveAspectFit
        scale : status === Image.Ready ? 1 : 0
        Behavior on scale {NumberAnimation {duration : 500; easing.type: Easing.InOutQuad}}
        horizontalAlignment: Image.AlignHCenter
        anchors.centerIn: parent
        anchors.fill: parent
    }
    Text
    {
        id: delegate_text
        color : "white"
        visible: delegate_pic.status === Image.Ready
        width : delegate_pic.width
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.HorizontalFit
        style: Text.Raised
        styleColor: "black"
        font.pointSize : 13
        anchors
        {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin : 15
        }
    }
    MouseArea
    {
        anchors.fill: parent
        onClicked: {delegate_item.clicked()}
    }
}
