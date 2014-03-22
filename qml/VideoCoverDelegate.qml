import QtQuick 2.1

Item
{
    id : delegate_item
    property alias source : delegate_pic.source
    property alias text : delegate_text.text
    property alias fillMode : delegate_pic.fillMode
    signal clicked();
    scale : delegate_ma.pressed ? 0.9 : 1
    Behavior on scale {NumberAnimation {duration : 250}}

    Image
    {
        id : delegate_pic
        fillMode: Image.PreserveAspectFit
        scale : status === Image.Ready ? 1 : 0
        Behavior on scale {NumberAnimation {duration : 500; easing.type: Easing.InOutQuad}}
        horizontalAlignment: Image.AlignHCenter
        anchors.fill: parent
        cache : true
    }
    MouseArea
    {
        id : delegate_ma
        anchors.fill: parent
        onClicked: {delegate_item.clicked()}
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
}
