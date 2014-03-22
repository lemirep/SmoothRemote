import QtQuick 2.2

Item
{
    anchors.fill: parent
    property bool shown : true;
    property QtObject selectedArtist : null;
    signal artistSelected();
    enabled : shown;

    ListModel {id : artist_index}

    function build_artist_index()
    {
        artist_index.clear();
        for (var i = 0; i < 26; i++)
            artist_index.append({"display" : String.fromCharCode(65 + i), "artistIdx" : -1});
        for (i = 0; i < artists_cover_flow.model.count; i++)
        {
            var idx = artist_index.get(artists_cover_flow.model.get(i).artist.charAt(0).toUpperCase().charCodeAt(0) - 65);
            if (idx.artistIdx === -1 || idx.artistIdx > i)
                idx.artistIdx = i;
        }
    }

    ListViewFlow
    {
        id : artists_cover_flow
        model : core.audioArtistsModel
        property int modelCount : model.count
        onModelCountChanged: build_artist_index();
        leftToRight: true
        flickDeceleration: 40
        anchors.fill: parent

        delegate : Component {
            Item
            {
                id : artist_delegate
                height : mainScreen.portrait ? PathView.view.width * 0.6 : PathView.view.height * 0.6
                width : height
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? PathView.delScale : 0.6
                z : PathView.onPath ? PathView.delZ : 0

                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}
                scale : delScale

                onIsCurrentItemChanged :
                {
                    if (isCurrentItem)
                        artist_idx_listview.currentIndex = model.artist.charAt(0).toUpperCase().charCodeAt(0) - 65;
                }
                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Image
                {
                    id : artist_img
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    onStatusChanged : if (status === Image.Ready) pic_anim.start();
                    NumberAnimation {id : pic_anim; target : artist_img; property : "scale"; from : 0; to : 1; duration : 500; easing.type: Easing.InOutQuad}
                    source : model.thumbnailUrl
                    smooth : true
                    width : parent.width * 0.75
                    height : width
                    anchors
                    {
                        right : parent.right
                        top : parent.top
                    }
                }

                ShaderEffect
                {
                    property variant source : ShaderEffectSource {
                        sourceItem: artist_img
                        live : true
                    }
                    z : -5
                    anchors
                    {
                        horizontalCenter : parent.horizontalCenter
                        top : parent.verticalCenter
                    }
                    width : parent.width * 0.5
                    height : parent.height * 0.5
                    transform: Rotation {
                        angle : -75
                        axis {x : 1; y: 0; z : 0}
                        origin.x : width * 0.5;
                        origin.y : height * 0.5
                    }

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
                                gl_FragColor = texture2D(source, vec2(coord.x, 1.0 - coord.y)) * (0.95 - coord.y) * 0.5;
                            }
                        "
                }

                Text
                {
                    id : del_text
                    font.pointSize: 35
                    fontSizeMode: Text.Fit
                    style: parent.isCurrentItem ? Text.Sunken : Text.Outline
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.artist
                    width :parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.capitalization: Font.Capitalize
                    anchors
                    {
                        bottom : parent.bottom
                        left : parent.left
                    }
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if (isCurrentItem)
                        {
                            selectedArtist = model;
                            artistSelected();
                        }
                        else
                            artists_cover_flow.currentIndex = index;
                    }
                }
            }
        }
    }

    ListViewFlow
    {
        id : artist_idx_listview
        pathItemCount: mainScreen.portrait ? 6 : 8
        cacheItemCount: 10
        anchors
        {
            left : parent.horizontalCenter
            right : parent.right
            top : parent.top
            bottom : parent.verticalCenter
            leftMargin : parent.width * 0.1
            bottomMargin : parent.height * 0.1
        }
        flickDeceleration: 150
        model : artist_index

        onMovingChanged :
        {
            if (!moving && currentItem.idx !== -1)
                artists_cover_flow.positionViewAtIndex(currentItem.idx, PathView.Center);
        }

        delegate : Component {
            Item
            {
                width : 100
                height : width
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property int idx : model.artistIdx
                z : isCurrentItem ? 1 : 0

                transform: Rotation {
                    angle : 45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }
                Text
                {
                    text : model.display
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    anchors.centerIn: parent
                    style: Text.Sunken
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#ff2200"
                    font.pointSize: 45
                    font.family : "Helvetica";
                    font.bold: true
                    scale : parent.isCurrentItem ? 1.5 : 0.8
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log("Going to " + model.artistIdx);
                        if (artistIdx !== -1)
                        {
                            artists_cover_flow.positionViewAtIndex(model.artistIdx, PathView.Center);
                            artist_idx_listview.currentIndex = index;
                        }
                    }
                }
            }
        }
    }
}
