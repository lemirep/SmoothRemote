import QtQuick 2.1

Image
{
    id : detail_pic
    fillMode: Image.PreserveAspectFit
    asynchronous: false
    cache : true
    signal clicked();

    Rectangle
    {
        z: -1
        color : "black"
        opacity: 0.3
        width : detail_pic.paintedWidth
        height: detail_pic.paintedHeight
        scale : detail_pic.scale
        anchors
        {
            top : detail_pic.top
            left : detail_pic.left
            leftMargin : 8
            topMargin : 8
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: detail_pic.clicked();
    }
}
