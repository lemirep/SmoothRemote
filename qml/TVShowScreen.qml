import QtQuick 2.1

Rectangle
{
    id : tvShowScreen
    anchors.fill: parent
    color : "#e8e8e8"

    GridView
    {
        id : grid_view
        anchors.fill: parent
        model : core.tvShowModel
        flow : GridView.TopToBottom
        cellHeight : Math.floor(tvShowScreen.height * 0.5)
        cellWidth : Math.floor(0.675 * cellHeight)
        snapMode : GridView.SnapToRow
        enabled : !tvshow_detail.shown

        delegate : VideoCoverDelegate {
            width : GridView.view.cellWidth
            height: GridView.view.cellHeight
            source: model.thumbnail
            text : model.title
            fillMode: Image.PreserveAspectCrop
            onClicked:
            {
                tvshow_detail.holder = model;
                tvshow_detail.animateCover(x - grid_view.contentX)
            }
        }
    }

    ScrollBar    {flickable: grid_view}

    FocusScope
    {
        anchors.fill: parent
        Component.onCompleted: forceActiveFocus()

        MediaDetailScreen
        {
            id : tvshow_detail
            anchors.fill: parent
            background: holder.fanart
            cover : holder.thumbnail
            contentComponent: TVShowDetail {

            }
            focus : !tv_show_player.focus && shown
        }

        Player
        {
            id : tv_show_player;
            enabled : (tv_show_player.focus === true)
        }
    }
}
