import QtQuick 2.1
import "Utils.js" as Utils

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
            PropertyChanges {target: tvshow_detail; showCoverPic : false}
            when : episodeView
        },
        State
        {
            AnchorChanges {target : seasons_view; anchors.bottom : parent.bottom}
            PropertyChanges {target: tvshow_detail; showCoverPic : true}
            when : !episodeView
        }
    ]

    transitions:
        [
        Transition {AnchorAnimation {duration : 500} NumberAnimation {duration : 500}}
    ]

    Keys.onReleased:
    {
        console.log("Detail 2 Key Released");
        if (episodeView && event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
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
            contentHeight: seasons_listview.height + tv_show_data.childrenRect.height * mainScreen.dpiMultiplier
            clip : true
            boundsBehavior: Flickable.DragOverBounds
            anchors
            {
                left : parent.left
                top : parent.top
                right : parent.right
                bottom : parent.bottom
            }

            Column
            {
                id : tv_show_data
                anchors
                {
                    left : parent.left
                    right : parent.right
                    top : parent.top
                    topMargin : 25
                    bottom : parent.bottom
                    leftMargin : mainScreen.portrait ? 10 : 25
                    rightMargin : mainScreen.portrait ? 10 : 25
                }
                spacing: 15

                Text
                {
                    color : "#e8e8e8"
                    anchors.horizontalCenter: parent.horizontalCenter
                    text : tvShow.title
                    font.pointSize: 18 * mainScreen.dpiMultiplier
                }
                Text
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color : "#e8e8e8"
                    text : tvShow.year
                    font.pointSize: 16 * mainScreen.dpiMultiplier
                }
                ListView
                {
                    id : seasons_listview
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                    }
                    height : 0.4 * show_flickable.height
                    orientation: ListView.Horizontal
                    model : tvShow.seasonsModel
                    clip : true

                    delegate: VideoCoverDelegate {
                        width : seasons_listview.height
                        height: width
                        source : model.thumbnailUrl
                        text : "Season " + model.season
                        anchors.margins: 15
                        onClicked: {episode_listview.model = model.episodeModel; episodeView = true;}
                    }
                    ScrollBar {flickable: seasons_listview}
                }
                Text
                {
                    id : show_summary
                    color : "#e8e8e8"
                    text : tvShow.plot
                    width: parent.width
                    font.pointSize: 12 * mainScreen.dpiMultiplier
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }
    }

    ListView
    {
        id : episode_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : seasons_view.bottom
            bottom : parent.bottom
        }
//        width : tvshow_detail.width
//        height : tvshow_detail.height
//        x : 0
        clip: true
        snapMode: GridView.SnapToRow
        model : showSeason.episodeModel
        delegate : Component {
            Item
            {
                property bool editMode : false
                width : ListView.view.width
                height : mainScreen.portrait ? ListView.view.height * 0.15 * mainScreen.dpiMultiplier : ListView.view.width * 0.15 * mainScreen.dpiMultiplier
                Rectangle
                {
                    anchors.fill: parent
                    opacity : 0.5
                    color : episode_del_ma.pressed ? "#a0a0a0" : index % 2 === 0 ? "#151515" : "#080808"
                }
                Image
                {
                    id : episode_cover_pic
                    anchors
                    {
                        left : parent.left
                        leftMargin : 15
                        verticalCenter : parent.verticalCenter
                    }
                    height : parent.height * 0.8
                    width : parent.width * 0.25
                    fillMode: Image.PreserveAspectFit
                    source : model.thumbnailUrl
                }
                Text
                {
                    id : episode_title_text
                    color : "white"
                    text : model.episode + " " + model.title
                    anchors
                    {
                        left : episode_cover_pic.right
                        verticalCenter : parent.verticalCenter
                        leftMargin : 15
                    }
                    height : parent.height * 0.3
                    width : parent.width - (episode_cover_pic.width + 25)
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    font.pointSize: 14 * mainScreen.dpiMultiplier
                    opacity : mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                }
                Text
                {
                    color : "white"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    width : parent.width - (episode_cover_pic.width + 25)
                    elide: Text.ElideRight
                    opacity : mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    text : Utils.printDuration(model.runtime)
                    font.pointSize: 11 * mainScreen.dpiMultiplier
                    anchors
                    {
                        top : episode_title_text.bottom
                        topMargin : 5
                        left : episode_title_text.left
                    }

                }

                MouseArea
                {
                    id : episode_del_ma
                    anchors.fill: parent
                    onClicked: {editMode = true}
                }
                MediaActionBar
                {
                    id : media_action_bar
                    onPlayClicked: core.buttonAction(14, model.file);
                    onAddClicked: {console.log("TTTTTTTTTTTTTTTT " + model.episode); core.buttonAction(17, model.episodeid);}
                    onStreamClicked:  mainView.launchMediaPlayer(model.streamingFile); /*core.buttonAction(27, model.streamingFile);*/
                    opacity : editMode ? 1 : 0
                    Behavior on opacity {NumberAnimation {duration : 250}}
                }
                Timer
                {
                    running : editMode
                    interval : 3000
                    repeat : false
                    onTriggered: editMode = !editMode
                }
            }
        }
        ScrollBar {flickable: episode_listview}
    }
}
