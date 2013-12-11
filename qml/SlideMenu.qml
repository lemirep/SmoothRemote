import QtQuick 2.0

Item
{
    id : slideMenu
    property bool deployed : false
    property alias color : slideMenuPanel.color
    property alias model : slideMenuListView.model
    property alias delegate : slideMenuListView.delegate
    signal currentIndexChanged(int index)

    QtObject
    {
        id : d
        property int  dragOffset : 20
    }

    onDeployedChanged: {checkDeployMenu(deployed)}

    function checkDeployMenu(deploy)
    {
        if (deployed !== deploy)
            deployed = deploy;
        else
            d.dragOffset = (deploy) ? (slideMenuPanel.width) : (20);
    }
    Rectangle
    {
        anchors.fill: parent
        opacity : (d.dragOffset / 1000)
        color : "black"
    }

    Rectangle
    {
        id : slideMenuPanel
        width : 400
        height : parent.height
        x : d.dragOffset - width
        color : "#e5e5e5"
        opacity : (deployed || slideMenuMA.dragging) ? 1 : 0
        Behavior on x {SmoothedAnimation {velocity : 5; duration : 250}}
        Behavior on opacity {SmoothedAnimation {velocity : 5; duration : 500}}

        ListView
        {
            id : slideMenuListView
            anchors.fill: parent
            anchors.topMargin: 2
            clip : true
            onCurrentIndexChanged:  {slideMenu.currentIndexChanged(slideMenuListView.currentIndex);}
        }
        Rectangle
        {
            anchors
            {
                bottom: parent.bottom
                left: parent.right
                leftMargin: 5
            }
            width : parent.height
            height : 5
            rotation : -90
            transformOrigin: Item.BottomLeft
            gradient : Gradient {
                GradientStop {position : 0.0; color : "#aa000000"}
                GradientStop {position : 1.0; color : "#00000000"}
            }
        }
    }
    MouseArea
    {
        id : slideMenuMA
        anchors.fill: parent
        property int    oldOffset
        property bool   dragging

        propagateComposedEvents: true

        onPressed :
        {
            if (mouseX >= slideMenu.x && mouseX <= d.dragOffset)
            {
                oldOffset = mouseX - d.dragOffset;
                dragging = true;
                mouse.accepted = true;
            }
            else
            {
                checkDeployMenu(false);
                mouse.accepted = false;
            }
        }
        onPositionChanged:
        {
            if (!dragging)
                mouse.accepted = false;
            else
            {
                d.dragOffset = mouseX - oldOffset;
                if (d.dragOffset > slideMenuPanel.width)
                    d.dragOffset = slideMenuPanel.width;
                if (d.dragOffset < 20)
                    d.dragOffset = 20;
                mouse.accepted = true;
            }
        }
        onReleased:
        {
            if (!dragging)
                mouse.accepted = false;
            else
            {
                checkDeployMenu(d.dragOffset > 0.5 * slideMenuPanel.width);
                mouse.accepted = true;
                dragging = false;
            }
        }
    }
}
