import QtQuick 2.0

Rectangle
{
    id : tvShowScreen
    anchors.fill: parent
    color : "#e8e8e8"

    GridView
    {
        id : grid_view
        anchors.fill: parent
        flow : GridView.TopToBottom
        model : core.movieModel
        cellHeight : Math.floor(tvShowScreen.height * 0.5)
        cellWidth : Math.floor(0.675 * cellHeight)
        snapMode : GridView.SnapToRow

        delegate : VideoCoverDelegate {
            width : GridView.view.cellWidth
            height: GridView.view.cellHeight
            fillMode: Image.PreserveAspectCrop
            source: model.thumbnail
            text : model.title + " (" + model.year + ")"
            onClicked:
            {
                movie_detail.holder = model;
                movie_detail.animateCover(x - grid_view.contentX)
            }
        }
    }

    ScrollBar    {flickable: grid_view}

    MediaDetailScreen
    {
        id : movie_detail
        anchors.fill: parent
        background: holder.fanart
        cover : holder.thumbnail
        content : "MovieDetail.qml"
    }

    Player
    {
        id : movie_player;
    }
}
