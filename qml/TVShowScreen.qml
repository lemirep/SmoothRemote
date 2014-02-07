import QtQuick 2.2
import QtGraphicalEffects 1.0


Item
{
    id : tvshow_screen
    anchors.fill: parent

    Component.onCompleted: {tvshow_screen.state = "show_list"; forceActiveFocus()}

    LinearGradient
    {
        anchors.fill: parent
        cached : true
        start: Qt.point(width, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop {position: 0; color: "#25282d"}
            GradientStop {position: 1; color: "black"}
        }
    }

    Image
    {
        id : back_arrow
        fillMode: Image.PreserveAspectFit
        source : "Resources/back_arrow.png"
        scale : back_ma.pressed ? 0.9 : 1
        anchors
        {
            left : parent.left
            top : parent.top
        }
        z : 10
        enabled : opacity === 1
        MouseArea
        {
            id : back_ma
            anchors.fill: parent
            onClicked: {tvshow_screen.goToPreviousState();}
        }
    }

    function goToPreviousState()
    {
        if (tvshow_screen.state === "show_detail")
            tvshow_screen.state = "show_list";
        else if (tvshow_screen.state === "episode_list")
            tvshow_screen.state = "show_detail";
    }

    Keys.onReleased:
    {
        console.log("TVShow : Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            goToPreviousState();
            event.accepted = true;
        }
    }

    states : [
        State
        {
            name : "show_list"
            PropertyChanges {target: show_list; shown : true; opacity : 1; scale : 1}
            PropertyChanges {target: show_detail; shown : false; opacity : 0; scale : 0}
            PropertyChanges {target: episode_list; shown : false; opacity : 0; scale : 0}
            PropertyChanges {target: back_arrow; opacity : 0}
        },
        State
        {
            name : "show_detail"
            PropertyChanges {target: show_detail; shown : true; opacity : 1; scale : 1}
            PropertyChanges {target: show_list; shown : false; opacity : 0; scale : 4}
            PropertyChanges {target: episode_list; shown : false; opacity : 0; scale : 0}
            PropertyChanges {target: back_arrow; opacity : 1}
        },
        State
        {
            name : "episode_list"
            PropertyChanges {target: episode_list; shown : true; opacity : 1; scale : 1}
            PropertyChanges {target: show_list; shown : false; opacity : 0; scale : 4}
            PropertyChanges {target: show_detail; shown : false; opacity : 0; scale : 4}
            PropertyChanges {target: back_arrow; opacity : 1}
        }
    ]

    transitions: [
        Transition {from: "show_list";to: "show_detail"
            ParallelAnimation
            {
                NumberAnimation { target: show_list ; properties: "opacity, scale"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: show_detail ; properties: "opacity, scale"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "show_detail";to: "show_list"
            ParallelAnimation
            {
                NumberAnimation { target: show_list; properties: "opacity, scale"; duration: 1000; easing.type: Easing.InOutQuad }
                NumberAnimation { target: show_detail ; properties: "opacity, scale"; duration: 750; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "show_detail";to: "episode_list"
            ParallelAnimation
            {
                NumberAnimation { target: show_detail ; properties: "opacity, scale"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: episode_list; properties: "opacity, scale"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "episode_list";to: "show_detail"
            ParallelAnimation
            {
                NumberAnimation { target: episode_list; properties: "opacity, scale"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: show_detail ; properties: "opacity, scale"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        }
    ]

    Text
    {
        fontSizeMode: Text.Fit
        font.bold: true
        font.italic: true
        font.family: "Helvetica"
        style: Text.Sunken
        styleColor: "#44ff2200";
        color : "#44111111";
        text : "TV Shows"
        font.pointSize: 200
        anchors
        {
            top : parent.top
            bottom : parent.verticalCenter
            left : parent.horizontalCenter
            right : parent.right
            margins : 25
        }
    }


    TVShowList
    {
        id : show_list
        anchors.fill: parent
        onShowSelected:
        {
            show_detail.show = selectedShow;
            tvshow_screen.state = "show_detail";
        }
    }

    TVShowDetail
    {
        id : show_detail
        anchors.fill: parent
        shown : false
        onSeasonSelected :
        {
            episode_list.model = selectedSeason.episodeModel
            tvshow_screen.state = "episode_list";
        }
    }

    TVShowEpisodeList
    {
        id : episode_list
        shown : false;
        anchors.fill: parent
    }
}
