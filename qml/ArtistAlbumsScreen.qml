import QtQuick 2.2

Item
{
    id : artist_albums_rec
    anchors.fill: parent
    property QtObject artist;
    property QtObject selectedAlbum;
    property bool shown : false
    signal albumSelected();

    enabled : shown
    onArtistChanged: core.refreshAlbumsForArtist(artist.artistid)

    transform: Rotation {
        angle : -20
        axis {x : 0; y: 1; z : 0}
        origin.x : width * 0.5
        origin.y : height * 0.5
    }

    Text
    {
        id : artist_text_label
        anchors
        {
            horizontalCenter : parent.horizontalCenter
            top : parent.top
            topMargin : 25
        }
        font.pointSize: 25 * mainScreen.dpiMultiplier
        text : artist.artist
        style: Text.Outline
        styleColor: "#66ff2200"
        color : "white"
        font.bold: true
        font.family: "Helvetica"
        elide: Text.ElideRight
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        width : parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.capitalization: Font.Capitalize
    }

    CoverFlow
    {
        id : albums_gridview
        anchors.fill: parent
        model : artist.albumsModel

        delegate : Component {
            Image
            {
                id : album_delegate
                property real rotAngle : PathView.onPath ? PathView.delAngle : 0
                property real delScale : PathView.onPath ? PathView.delScale : 0
                property bool isCurrentItem : index === PathView.view.currentIndex;

                width : mainScreen.portrait ? PathView.view.width * 0.8 : PathView.view.height * 0.65
                height : width
                fillMode: Image.PreserveAspectFit
                scale : delScale
                z : PathView.onPath ? PathView.delZ : -1
                Behavior on rotAngle {SpringAnimation {spring : 5; damping: 0.7; epsilon: 0.025}}
                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}
                onStatusChanged: if (status === Image.Ready) scale_anim.start();
                source : model.thumbnailUrl
                smooth : true

                NumberAnimation {id : scale_anim; target : album_delegate; property: "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                transform: [Rotation {id : rotation; angle : rotAngle; axis {x : 0; y: 1; z : 0} origin.x : width * 0.5; origin.y : height * 0.5}]

                Text
                {
                    font.pointSize: 25
                    style: Text.Outline
                    styleColor: "#66ff2200"
                    color : "white"
                    font.bold: true
                    font.family: "Helvetica"
                    text : model.title
                    width : parent.width
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.capitalization: Font.Capitalize
                    anchors
                    {
                        top : parent.bottom
                        horizontalCenter : parent.horizontalCenter
                    }
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if (isCurrentItem)
                        {
                            selectedAlbum = model;
                            albumSelected();
                        }
                        else
                            albums_gridview.currentIndex = index;
                    }
                }
            }
        }
    }
}
