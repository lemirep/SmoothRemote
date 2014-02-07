import QtQuick 2.2
import QtGraphicalEffects 1.0

Item
{
    id : audio_screen
    anchors.fill: parent
    Component.onCompleted: {audio_screen.state = "artists"; forceActiveFocus();}

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
            onClicked: {audio_screen.goToPreviousState();}
        }
    }

    function    goToPreviousState()
    {
        if (audio_screen.state === "albums")
            audio_screen.state = "artists";
        else if (audio_screen.state == "songs")
            audio_screen.state = "albums";
    }

    Keys.onReleased:
    {
        console.log("Audio : Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            goToPreviousState();
            event.accepted = true;
        }
    }

    states : [
        State
        {
            name : "artists"
            PropertyChanges {target: artist_albums_screen; shown : false; scale : 0; x_trans : width; opacity : 0}
            PropertyChanges {target: album_songs_screen; shown : false; scale : 0; x_trans : width; opacity : 0}
            PropertyChanges {target: artists_screen; shown : true; scale : 1; x_trans : 0; opacity : 1}
            PropertyChanges {target: back_arrow; opacity : 0}
        },
        State
        {
            name: "albums"
            PropertyChanges {target: artists_screen; shown : false; scale : 3; x_trans : -width; opacity : 0}
            PropertyChanges {target: album_songs_screen; shown : false; scale : 0; x_trans : width; opacity : 0}
            PropertyChanges {target: artist_albums_screen; shown : true; scale : 1; x_trans : 0; opacity : 1}
            PropertyChanges {target: back_arrow; opacity : 1}
        },
        State
        {
            name : "songs"
            PropertyChanges {target: artists_screen; shown : false; scale : 3; x_trans : -width; opacity : 0}
            PropertyChanges {target: artist_albums_screen; shown : false; scale : 3; x_trans : -width; opacity : 0}
            PropertyChanges {target: album_songs_screen; shown : true; scale : 1; x_trans : 0; opacity : 1}
            PropertyChanges {target: back_arrow; opacity : 1}
        }
    ]

    transitions: [
        Transition {from: "artists"; to: "albums"
            ParallelAnimation
            {
                NumberAnimation { target: artists_screen; properties: "scale, x_trans, opacity"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: artist_albums_screen; properties: "x_trans, scale, opacity"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "albums"; to: "artists"
            ParallelAnimation
            {
                NumberAnimation { target: artist_albums_screen; properties: "x_trans, scale, opacity"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: artists_screen; properties: "scale, x_trans, opacity"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "albums"; to: "songs"
            ParallelAnimation
            {
                NumberAnimation { target: artist_albums_screen; properties: "x_trans, scale, opacity"; duration: 750; easing.type: Easing.InOutQuad }
                NumberAnimation { target: album_songs_screen; properties: "scale, x_trans, opacity"; duration: 1000; easing.type: Easing.InOutQuad }
            }
        },
        Transition {from: "songs"; to: "albums"
            ParallelAnimation
            {
                NumberAnimation { target: artist_albums_screen; properties: "x_trans, scale, opacity"; duration: 1000; easing.type: Easing.InOutQuad }
                NumberAnimation { target: album_songs_screen; properties: "scale, x_trans, opacity"; duration: 750; easing.type: Easing.InOutQuad }
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
        text : "Music"
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

    ArtistsScreen
    {
        id : artists_screen
        anchors.fill: parent
        property int x_trans : 0
        transform: Translate {x : artists_screen.x_trans}

        onArtistSelected:
        {
            artist_albums_screen.artist = artists_screen.selectedArtist;
            parent.state = "albums";
        }
    }

    ArtistAlbumsScreen
    {
        id : artist_albums_screen
        property int x_trans : 0
        transform: Translate {x : artist_albums_screen.x_trans}
        anchors.fill: parent

        onAlbumSelected:
        {
            album_songs_screen.model = artist_albums_screen.selectedAlbum.songsModel;
            parent.state = "songs"
        }
    }

    AlbumSongsScreen
    {
        id : album_songs_screen
        property int x_trans : 0
        transform: Translate {x : album_songs_screen.x_trans}
        anchors.fill: parent
    }
}
