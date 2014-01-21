import QtQuick 2.1

Item
{
    property variant tvShow : parent.getHolder()
    property bool episodeView : false;
    onTvShowChanged: {if (tvShow !== undefined) core.refreshSeasonsForShow(tvShow.tvshowid); episode_listview.model = undefined;}
    anchors.fill: parent

    Component.onCompleted:
    {
        tvshow_detail.backFunction = function()
        {
            if (episodeView)
                episodeView = false;
            else
                tvshow_detail.shown = false;
        }
    }

    onEpisodeViewChanged:
    {
        console.log("Episode View changed " + episodeView);
        if (episodeView)
            forceActiveFocus();
        else
            tvshow_detail.forceActiveFocus();
    }

    states : [
        State
        {
            AnchorChanges {target : seasons_view; anchors.bottom : parent.top}
            when : episodeView
        },
        State
        {
            AnchorChanges {target : seasons_view; anchors.bottom : parent.bottom}
            when : !episodeView
        }
    ]

    transitions:
    [
        Transition {AnchorAnimation {duration : 500}}
    ]

    Keys.onReleased:
    {
        console.log("Detail 2 Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            if (episodeView)
                episodeView = false;
            event.accepted = true;
        }
    }

    Item
    {
        id : seasons_view
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
        }
        ScrollBar {flickable: show_flickable}
        Flickable
        {
            id : show_flickable
            contentHeight: tv_show_data.childrenRect.height * mainScreen.dpiMultiplier
            clip : true
            boundsBehavior: Flickable.DragOverBounds
            anchors
            {
                left : parent.left
                top : parent.top
                right : parent.right
            }
            height : parent.height * 0.6

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
        }

        ListView
        {
            id : seasons_listview
            anchors
            {
                left : parent.left
                right : parent.right
                top : show_flickable.bottom
                bottom : parent.bottom
                margins : 15 * mainScreen.dpiMultiplier
            }
            orientation: ListView.Horizontal
            model : tvShow.seasonsModel
            clip : true

            delegate: VideoCoverDelegate {
                width : seasons_listview.height
                height: width
                source : model.thumbnail
                text : "Season " + model.season
                anchors.margins: 15
                onClicked: {episode_listview.model = model.episodeModel; episodeView = true;}
            }
            ScrollBar {flickable: seasons_listview}
        }
    }

    GridView
    {
        id : episode_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : seasons_view.bottom
            bottom : parent.bottom
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
