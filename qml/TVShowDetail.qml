import QtQuick 2.1
import "Utils.js" as Utils

Image
{
    property bool shown;
    property QtObject show : null
    property bool episodeView : false;
    property QtObject selectedSeason : null
    signal seasonSelected();

    onShowChanged: {if (show !== undefined) core.refreshSeasonsForShow(show.tvshowid);}
    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    asynchronous: true
    enabled : shown
    source : (show) ? show.fanartUrl : ""

    Rectangle
    {
        anchors.fill: parent
        opacity : 0.4
        color : "black"
    }

    Flickable
    {
        id : show_flickable
        contentHeight: seasons_listview.height + tv_show_data.childrenRect.height * mainScreen.dpiMultiplier
        clip : true
        boundsBehavior: Flickable.DragOverBounds
        anchors.fill: parent
        ScrollBar {flickable: show_flickable}

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
                id : title_text
                style: Text.Sunken
                styleColor:"#cc6600"
                color : "#cc2200"
                font.pointSize: 35
                font.bold: true
                font.italic: true
                font.capitalization: Font.Capitalize
                width : parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide : Text.ElideRight
                text : show.title
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
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
                model : show.seasonsModel
                clip : true

                delegate: VideoCoverDelegate {
                    transform: Rotation {
                        angle : 15
                        axis {x : 0; y: 1; z : 0}
                    }
                    width : seasons_listview.height
                    height: width
                    source : model.thumbnailUrl
                    text : "Season " + model.season
                    anchors.margins: 15
                    onClicked: {selectedSeason = model; seasonSelected();}
                }
                ScrollBar {flickable: seasons_listview}
            }
            Text
            {
                id : show_summary
                color : "#e8e8e8"
                text : show.plot
                width: parent.width
                font.pointSize: 12 * mainScreen.dpiMultiplier
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
