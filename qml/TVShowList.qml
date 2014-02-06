import QtQuick 2.2

GridView
{
    id : grid_view
    property real swipeAngle : horizontalVelocity * 0.02
    property QtObject selectedShow : null
    property bool shown;
    signal showSelected();

    model : core.tvShowModel
    flow : GridView.TopToBottom
    cellHeight : Math.floor(height * 0.5)
    cellWidth : Math.floor(0.675 * cellHeight)
    snapMode : GridView.SnapToRow
    enabled : shown

    Behavior on swipeAngle { SpringAnimation {spring : 2.5; damping : 0.8; epsilon: 0.25} }

    transform: Rotation {
        angle : Math.abs(grid_view.swipeAngle) < 30 ? grid_view.swipeAngle : (grid_view.swipeAngle < 0) ? -30 : 30
        axis {x : 0; y: 1; z : 0}
        origin.x : width * 0.5
        origin.y : height * 0.5
    }

    delegate : VideoCoverDelegate {
        width : GridView.view.cellWidth
        height: GridView.view.cellHeight
        source: model.thumbnailUrl
        text : model.title
        fillMode: Image.PreserveAspectCrop
        opacity : 1 - (Math.abs(swipeAngle) * 0.01)
        onClicked:
        {
            selectedShow = model;
            showSelected();
        }
    }
    ScrollBar    {flickable: grid_view}
}
