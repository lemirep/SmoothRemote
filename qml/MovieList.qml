import QtQuick 2.2

GridView
{
    id : grid_view
    property bool shown;
    property QtObject selectedMovie : null;
    property real swipeAngle : horizontalVelocity * 0.02
    signal movieSelected();

    anchors.fill: parent
    flow : GridView.TopToBottom
    model : core.movieModel
    cellHeight : Math.floor(height * 0.5)
    cellWidth : Math.floor(0.675 * cellHeight)
    snapMode : GridView.SnapToRow

    Behavior on swipeAngle { SpringAnimation {spring : 1.5; damping : 0.8; epsilon: 0.25} }

    transform: Rotation {
        angle : Math.abs(grid_view.swipeAngle) < 30 ? grid_view.swipeAngle : (grid_view.swipeAngle < 0) ? -30 : 30
        axis {x : 0; y: 1; z : 0}
        origin.x : width * 0.5
        origin.y : height * 0.5
    }

    delegate : VideoCoverDelegate {
        width : GridView.view.cellWidth
        height: GridView.view.cellHeight
        fillMode: Image.PreserveAspectCrop
        source: model.thumbnailUrl
        text : model.title + " (" + model.year + ")"
        opacity : 1 - (Math.abs(swipeAngle) * 0.01)
        onClicked:
        {
            grid_view.selectedMovie = model;
            grid_view.movieSelected();
//            movie_detail.holder = model;
//            movie_detail.animateCover(x - grid_view.contentX)
        }
    }
    ScrollBar    {flickable: grid_view}
}
