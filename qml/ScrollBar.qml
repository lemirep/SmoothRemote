import QtQuick 2.1

Item
{
    property Flickable flickable
    Item
    {
        id : vertical_scroll_bar
        opacity: (flickable.movingVertically) ? 0.8 : 0
        Behavior on opacity {NumberAnimation {duration : 750}}
        width : 5
        height: flickable.height
        x : flickable.width - width
        clip : true

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
        opacity: (flickable.movingHorizontally) ? 0.8 : 0
        Behavior on opacity {NumberAnimation {duration : 750}}
        width : flickable.width
        height: 5
        y : flickable.height - height
        clip : true

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
