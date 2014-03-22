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
        angle : 0
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
                property real delScale : PathView.onPath ? PathView.delScale : 0.5
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

    ShaderEffect
    {
        property variant source : ShaderEffectSource {
            sourceItem: albums_gridview
            live : true
            width : artists_cover_flow.width
            height : artists_cover_flow.height
        }
        z : -5
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.verticalCenter
            topMargin : 1.25 * album_delegate.width
        }
        height : parent.height

        vertexShader: "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;
                attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 coord;
                uniform highp float width;

                void main()
                {
                    coord = qt_MultiTexCoord0;
                    gl_Position = qt_Matrix * qt_Vertex;
                }
            "

        fragmentShader: "
                varying highp vec2 coord;
                uniform sampler2D source;
                uniform lowp float qt_Opacity;

                void main()
                {
                    gl_FragColor = texture2D(source, vec2(coord.x, 1.0 - coord.y)) * (0.6 - coord.y) * sin(3.14 * coord.x);
                }
            "

    }
}
