import QtQuick 2.0
import QtQuick.Layouts 1.0

Item
{
    id : detail_view
    anchors.fill: parent
    property variant tvShow : detail_view.loader.tvShow
    property bool portrait : width < height
    property bool shown : false;

    onTvShowChanged: {core.refreshSeasonsForShow(tvShow.tvshowid);}

    function animateCover(x)
    {
        detail_pic.x = x;
        shown = true;
    }

    states : [State {
            PropertyChanges {target : detail_pic; scale : 1; x : 50}
            when : shown
        }]

    transitions: [
        Transition
        {
            SmoothedAnimation {duration : 500; velocity : 5; target: detail_pic; property: "x"}
            NumberAnimation {duration : 750; target: detail_pic; property: "scale"}
        }]

    Image
    {
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        opacity : detail_pic.scale
        enabled: detail_pic.scale === 1
        source : tvShow.fanart
        asynchronous: true
        MouseArea
        {
            anchors.fill: parent
            onClicked: {}
            onPressed: {}
        }
        Rectangle
        {
            anchors.fill: parent
            opacity : 0.3
            color : "black"
        }
    }

    Item
    {
        anchors.fill: parent
        states : [
            State
            {
                AnchorChanges
                {
                    target : detail_pic;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: undefined;
                    anchors.top: undefined
                }
                PropertyChanges {
                    target: detail_pic
                    x : 50
                }
                AnchorChanges
                {
                    target : show_flickable
                    anchors.left: detail_pic.right
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
                when : !portrait
            },
            State
            {
                AnchorChanges
                {
                    target : detail_pic;
                    anchors.verticalCenter: undefined;
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                }
                AnchorChanges
                {
                    target : show_flickable
                    anchors.left: parent.left
                    anchors.top: detail_pic.bottom
                }
                when : portrait
            }

        ]

        CoverImage
        {
            id : detail_pic
            scale : 0
            enabled: scale === 1
            source : tvShow.thumbnail
            onClicked: shown = false;
            horizontalAlignment : (portrait) ? Image.AlignHCenter : Image.AlignLeft
            width : parent.width * 0.3
            anchors.topMargin: 25
        }

        Flickable
        {
            id : show_flickable
            enabled: opacity === 1
            opacity: (detail_pic.scale === 1) ? 1 : 0
            contentHeight: tv_show_data.childrenRect.height + seasons_listview.height + seasons_listview.childrenRect.height + seasons_listview.contentHeight
            clip : true
            anchors
            {
                right: parent.right
                bottom: parent.bottom
                leftMargin : 50
                rightMargin : 50
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
                }
                spacing: 15

                Text
                {
                    color : "#e8e8e8"
                    anchors.horizontalCenter: parent.horizontalCenter
                    text : detail_view.tvShow.title
                    font.pointSize: 15
                }
                Text
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color : "#e8e8e8"
                    text : detail_view.tvShow.year
                    font.pointSize: 15
                }
                Text
                {
                    color : "#e8e8e8"
                    text : detail_view.tvShow.plot
                    width: parent.width
                    font.pointSize: 10.5
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
            GridView
            {
                id : seasons_listview
                anchors
                {
                    left : parent.left
                    right : parent.right
                    top : tv_show_data.bottom
                    margins : 50
                }
                model : detail_view.tvShow.seasonsModel
                cellWidth : seasons_listview.width * 0.3
                cellHeight : seasons_listview.width * 0.3
                delegate: season_delegate_component
            }
        }
    }

    Component
    {
        id : season_delegate_component
        Item
        {
            width : GridView.view.cellWidth
            height: GridView.view.cellHeight
            Image
            {
                id : season_pic
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                source : model.thumbnail
                anchors
                {
                    top : parent.top
                    bottom : parent.bottom
                    bottomMargin : 10
                }
                verticalAlignment: Image.AlignVCenter
            }
            Text
            {
                color : "white"
                text : "Season " +  model.season
                anchors
                {
                    left : parent.horizontalCenter
                    top : season_pic.bottom
                }
                font.pointSize: 10.5
            }
        }
    }
}
