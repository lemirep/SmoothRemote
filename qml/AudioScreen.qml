import QtQuick 2.1

Rectangle
{
    id : audio_screen
    anchors.fill: parent
    //    color : "#e8e8e8"
    color : "#1e2124"

    ListModel
    {
        id : artist_index

    }


    function build_artist_index()
    {
        for (var i = 0; i < 26; i++)
            artist_index.append({"display" : String.fromCharCode(65 + i), "artistIdx" : -1});
        for (i = 0; i < artists_cover_flow.model.count; i++)
        {
            var idx = artist_index.get(artists_cover_flow.model.get(i).artist.charAt(0).toUpperCase().charCodeAt(0) - 65);
            if (idx.artistIdx === -1 || idx.artistIdx > i)
                idx.artistIdx = i;
        }
    }

    CoverFlow
    {
        id : artists_cover_flow
        model : core.audioArtistsModel

        onModelChanged : {console.log(">>> Count " + model.count); index_timer.start()}

        Timer
        {
            id : index_timer
            interval : 4000
            running : false
            repeat: false
            onTriggered: build_artist_index();
        }


        delegate : Component {

            Image {
                id : artist_delegate
                property real rotAngle : PathView.onPath ? PathView.delAngle : 0
                property real delScale : PathView.onPath ? PathView.delScale : 0
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property string artistName : model.artist

                asynchronous: true

                width : mainScreen.portrait ? PathView.view.height * 0.5 : PathView.view.width * 0.4
                height : width
                onStatusChanged : if (status === Image.Ready) pic_anim.start();
                NumberAnimation {id : pic_anim; target : artist_delegate; property : "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                scale : delScale
                z : PathView.onPath ? PathView.delZ : -1
                transform: Rotation {
                    angle : rotAngle
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                onIsCurrentItemChanged :
                {
                    if (isCurrentItem)
                    {
                        artist_text_label.text = model.artist;
                        artist_idx_listview.currentIndex = model.artist.charAt(0).toUpperCase().charCodeAt(0) - 65;
                    }
                }
                source : model.thumbnail
                fillMode: Image.PreserveAspectCrop
                smooth : true

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if (isCurrentItem)
                        {
                            artist_albums.shown = true;
                            artist_albums.artist = model;
                        }
                        else
                            artists_cover_flow.currentIndex = index;
                    }
                }
            }
        }
    }

    ListView
    {
        id : artist_idx_listview
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            leftMargin : 50
            rightMargin : 50
            topMargin : 50
        }
        orientation: ListView.Horizontal
        model : artist_index
        height : 100 * mainScreen.dpiMultiplier
        highlight : Component {
            Rectangle
            {
                width : ListView.view.width / 26
                height : width
                color : "#336699";
            }
        }

        delegate : Component {
            Item
            {
                width : ListView.view.width / 26 * mainScreen.dpiMultiplier
                height : width
                Rectangle
                {
                    anchors.fill: parent
                    radius : 5
                    color : "black"
                    opacity : model.artistIdx !== -1 ? 0.4 : 0.1
                    border
                    {
                        width : 1
                        color : "white"
                    }
                }
                Text
                {
                    text : model.display
                    color : "white"
                    anchors.centerIn: parent
                    font.pointSize: 12
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log("Going to " + model.artistIdx);
                        if (artistIdx !== -1)
                        {
                            artists_cover_flow.currentIndex = model.artistIdx
                           artist_idx_listview.currentIndex = index;
                        }
                     }
                }
            }
        }
    }

    Text
    {
        id : artist_text_label
        anchors
        {
            horizontalCenter : parent.horizontalCenter
            bottom : parent.bottom
            bottomMargin : 25
        }
        font.pointSize: 35
        style: Text.Outline
        styleColor: "#e8e8e8"
        color : "white"
    }

    ArtistAlbumsScreen
    {
        id : artist_albums
        anchors.fill: parent
        shown : false
    }
}
