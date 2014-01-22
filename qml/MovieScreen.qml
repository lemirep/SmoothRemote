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

    FocusScope
    {
        anchors.fill: parent
        Component.onCompleted: forceActiveFocus()

        MediaDetailScreen
        {
            id : movie_detail
            anchors.fill: parent
            background: holder.fanart
            cover : holder.thumbnail
            contentComponent: MovieDetail {}
            hasActionBar: true

            actionBarComponent: Row   {
                spacing : 25
                height : 55 * mainScreen.dpiMultiplier

                Image
                {
                    height: parent.height - 15
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source : "Resources/play_inv.png"
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: core.buttonAction(14, movie_detail.holder.file);
                    }
                }
                Image
                {
                    height: parent.height - 15
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source : "Resources/plus_inv.png"
                    scale : add_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : add_ma
                        anchors.fill: parent
                        onClicked: core.buttonAction(26, movie_detail.holder.movieid);
                    }
                }
                Image
                {
                    height: parent.height - 15
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source : "Resources/cloud_inv.png"
                    scale : cloud_ma.pressed ? 0.9 : 1
                    MouseArea
                    {
                        id : cloud_ma
                        anchors.fill: parent
                        onClicked: core.buttonAction(27, movie_detail.holder.streamingFile);
                    }
                }
            }
        }

        //    Player
        //    {
        //        id : movie_player;
        //    }
    }
}
