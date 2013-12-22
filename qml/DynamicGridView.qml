import QtQuick 2.0

Item
{
    id : gridview_item
    property alias delegate : repeater.delegate
    property alias model : repeater.model
    property bool horizontalScrollBar : true;
    property bool verticalScrollBar : true;
    property bool horizontal : false
    property alias contentX : flickable.contentX
    property alias contentY : flickable.contentY
    property alias contentWidth : flickable.contentWidth
    property alias contentHeight : flickable.contentHeight

    Flickable
    {
        id : flickable
        anchors.fill: parent
        contentHeight : (horizontal) ? parent.height : flow.childrenRect.height
        contentWidth : (!horizontal) ? parent.width : flow.childrenRect.width

        Flow
        {
            id : flow
            flow : (horizontal) ? Flow.TopToBottom : Flow.LeftToRight
            width : (!horizontal) ? parent.width : width;
            height : (horizontal) ? parent.height : height;

            Repeater
            {
                id : repeater
            }
        }
    }

    Item
    {
        id : vertical_scroll_bar
        enabled : verticalScrollBar
        opacity: (flickable.movingVertically) ? 0.8 : 0
        Behavior on opacity {NumberAnimation {duration : 750}}
        width : 5
        height: flickable.height
        x : flickable.width - width

        Rectangle
        {
            anchors.fill: parent
            color : "white"
        }
        Rectangle
        {
            width : 5
            height : flickable.visibleArea.heightRatio * vertical_scroll_bar.height
            color : "black"
            radius : 3
            y : flickable.visibleArea.yPosition * vertical_scroll_bar.height
        }
    }

    Item
    {
        id : horizontal_scroll_bar
        enabled : horizontalScrollBar
        opacity: (flickable.movingHorizontally) ? 0.8 : 0
        Behavior on opacity {NumberAnimation {duration : 750}}
        width : flickable.width
        height: 5
        y : flickable.height - height

        Rectangle
        {
            anchors.fill: parent
            color : "white"
        }
        Rectangle
        {
            width : flickable.visibleArea.widthRatio * horizontal_scroll_bar.width
            height : 5
            color : "black"
            radius : 3
            x : flickable.visibleArea.xPosition * (horizontal_scroll_bar.width)
        }
    }

}
