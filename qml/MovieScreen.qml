import QtQuick 2.2
import QtGraphicalEffects 1.0

Item
{
    id : movie_screen
    anchors.fill: parent
    Component.onCompleted: {movie_screen.state = "list"; forceActiveFocus();}

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
            onClicked: {movie_screen.goToPreviousState();}
        }
    }

    function goToPreviousState()
    {
        if (movie_screen.state === "detail")
            movie_screen.state = "list";
    }

    Keys.onReleased:
    {
        console.log("Movie : Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            goToPreviousState();
            event.accepted = true;
        }
    }

    states : [
        State
        {
            name : "list"
            PropertyChanges {target: movie_list; opacity : 1; shown : true; scale : 1}
            PropertyChanges {target: movie_detail; opacity : 0; shown : false; scale : 0}
            PropertyChanges {target: back_arrow; opacity : 0}
        },
        State
        {
            name : "detail"
            PropertyChanges {target: movie_list; opacity : 0; shown : false; scale : 4}
            PropertyChanges {target: movie_detail; opacity : 1; shown : true; scale : 1}
            PropertyChanges {target: back_arrow; opacity : 1}
        }
    ]

    transitions: [
        Transition {from: "list"; to: "detail"
            ParallelAnimation
            {
                NumberAnimation { target: movie_list; properties: "opacity, scale"; duration: 250; easing.type: Easing.InOutQuad }
                NumberAnimation { target: movie_detail; properties: "opacity, scale"; duration: 500; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "detail"; to: "list"
            ParallelAnimation
            {
                NumberAnimation { target: movie_detail; properties: "opacity, scale"; duration: 250; easing.type: Easing.InOutQuad }
                NumberAnimation { target: movie_list; properties: "opacity, scale"; duration: 500; easing.type: Easing.InOutQuad }
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
        text : "Movies"
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

    MovieList
    {
        id : movie_list
        anchors.fill: parent
        onMovieSelected:
        {
            movie_detail.movie = movie_list.selectedMovie;
            movie_screen.state = "detail";
        }
    }

    MovieDetail
    {
        id : movie_detail
        anchors.fill: parent
        shown : false
    }
}
