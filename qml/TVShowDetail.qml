import QtQuick 2.0

Item
{
    property variant tvShow : parent.getHolder();

    onTvShowChanged: {if (tvShow !== undefined) core.refreshSeasonsForShow(tvShow.tvshowid); episode_listview.model = undefined;}

    Column
    {
        id : tv_show_data
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            topMargin : 25
        }
        spacing: 15

        Text
        {
            color : "#e8e8e8"
            anchors.horizontalCenter: parent.horizontalCenter
            text : tvShow.title
            font.pointSize: 15 * mainScreen.dpiMultiplier
        }
        Text
        {
            anchors.horizontalCenter: parent.horizontalCenter
            color : "#e8e8e8"
            text : tvShow.year
            font.pointSize: 15 * mainScreen.dpiMultiplier
        }
        Text
        {
            id : show_summary
            color : "#e8e8e8"
            text : tvShow.plot
            width: parent.width
            font.pointSize: 11 * mainScreen.dpiMultiplier
            elide: Text.ElideRight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }
    }

    ListView
    {
        id : seasons_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : tv_show_data.bottom
            margins : 50
        }
        height: seasons_listview.width * 0.3
        orientation: ListView.Horizontal
        model : tvShow.seasonsModel

        delegate: VideoCoverDelegate {
            width : seasons_listview.height
            height: width
            source : model.thumbnail
            text : "Season " + model.season
            anchors.margins: 15
            onClicked:
            {
                episode_listview.model = model.episodeModel;
                console.log("Count " + model.episodeModel.count)
            }
        }
        ScrollBar {flickable: seasons_listview}
    }

    GridView
    {
        id : episode_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : seasons_listview.bottom
        }
        height: seasons_listview.width * 0.5
        cellWidth: height
        cellHeight: height
        clip: true
        snapMode: GridView.SnapToRow

        model : showSeason.episodeModel
        delegate : VideoCoverDelegate {
            width : GridView.view.cellWidth
            height: GridView.view.cellHeight
            source : model.thumbnail
            text : model.episode
            onClicked:
            {
                console.log(model.file)
                tv_show_player.player.source = model.file;
                tv_show_player.player.play();
            }
        }
        ScrollBar {flickable: episode_listview}
    }
}
