import QtQuick 2.2
import "Utils.js" as Utils

Item
{
    id : album_songs_item
    property alias model : songs_listview.model
    property int albumId;
    property bool shown : false

    enabled: shown

    states : [
        State
        {
            PropertyChanges {target: album_songs_item; opacity : 1}
            when : shown
        }
    ]

    transitions: [
        Transition
        {
            NumberAnimation { target: album_songs_item; property: "opacity"; duration: 800; easing.type: Easing.InOutQuad }
        }
    ]

    ActionBar
    {
        id : action_bar
        Row
        {
            spacing : 25
            anchors
            {
                right : parent.right
                verticalCenter : parent.verticalCenter
                rightMargin : 25
            }
            height : 55 * mainScreen.dpiMultiplier

            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/play_inv.png"
                scale : play_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : play_ma
                    anchors.fill: parent
                    onClicked: core.buttonAction(-1);
                }
            }
            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/plus_inv.png"
                scale : add_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : add_ma
                    anchors.fill: parent
                    onClicked: core.buttonAction(16, albumId);
                }
            }
            Image
            {
                height: parent.height - 15
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source : "Resources/cloud_inv.png"
                scale : cloud_ma.pressed ? 0.9 : 1
                MouseArea
                {
                    id : cloud_ma
                    anchors.fill: parent
                }
            }
        }
    }

    ListViewFlow
    {
        id : songs_listview
        pathItemCount: mainScreen.portrait ? 4 : 6
        leftToRight: false
        flickDeceleration: 75
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
            bottom : action_bar.top
        }

        delegate : Component {
            Item
            {
                property bool editMode : false
                property bool isCurrentItem : index === PathView.view.currentIndex;
                property real delScale : PathView.onPath ? PathView.delScale : 0
                transform: Rotation {
                    angle : -45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5
                    origin.y : height * 0.5
                }
                height : mainScreen.portrait ? PathView.view.width * 0.7 : PathView.view.height * 0.7
                width : height
                scale: delScale
                z : PathView.onPath ? PathView.delZ : 0
                Behavior on delScale {SpringAnimation {spring : 5; damping: 1; epsilon: 0.005}}
                Image
                {
                    id : song_cover_pic
                    fillMode: Image.PreserveAspectFit
                    source : model.thumbnailUrl
                    asynchronous : true
                    width : parent.width * 0.5
                    height : width
                    anchors
                    {
                        horizontalCenter : parent.horizontalCenter
                        verticalCenter : parent.verticalCenter
                    }
                    onStatusChanged : if (status === Image.Ready) pic_anim.start();
                    NumberAnimation {id : pic_anim; target : song_cover_pic; property : "scale"; from : 0; to : 1; duration : 500; easing.type: Easing.InOutQuad}
                }
                ShaderEffect
                {
                    property variant source : ShaderEffectSource {
                        sourceItem: song_cover_pic
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
                        angle : 75
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
                    id : song_title_text
                    style: Text.Sunken
                    styleColor: parent.isCurrentItem ? "#cc6600" : "#cc2200"
                    color : parent.isCurrentItem ? "#ff2200" :"white"
                    text : model.title
                    anchors
                    {
                        left : parent.horizontalCenter
                        right : parent.right
                        bottom : duration_text.top
                    }
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    width : parent.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideLeft
                    font.pointSize: 45
                    fontSizeMode: Text.Fit
                    font.capitalization: Font.Capitalize
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                }
                Text
                {
                    id : duration_text
                    style: Text.Sunken
                    styleColor: "#ff2200"
                    color : "white"
                    font.family : "Helvetica";
                    font.bold: true
                    font.italic: true
                    font.pointSize: 20 * mainScreen.dpiMultiplier
                    width : parent.width
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignBottom
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    opacity: mainScreen.portrait ? 1 - media_action_bar.opacity : 1
                    text : Utils.printDuration(model.runtime)
                    anchors
                    {
                        bottom : parent.bottom
                        right : parent.right
                    }
                }

                MouseArea
                {
                    id : song_del_ma
                    anchors.fill: parent
                    onClicked:
                    {
                        if (parent.isCurrentItem)
                            editMode = true;
                    }
                }

                MediaActionBar
                {
                    id : media_action_bar
                    opacity : editMode ? 1 : 0
                    onPlayClicked: core.buttonAction(14, model.file);
                    onAddClicked:  core.buttonAction(25, model.songid);
                    onStreamClicked: core.buttonAction(27, model.streamingFile);
                    anchors
                    {
                        right : parent.right
                        bottom : song_title_text.top
                    }

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
    }

    ListViewFlow
    {
        id : tracks_listview
        leftToRight: false
        cacheItemCount: 10
        flickDeceleration: 150
        anchors
        {
            left : parent.left
            right : parent.horizontalCenter
            top : parent.top
            bottom : parent.verticalCenter
            bottomMargin : parent.height * 0.1
            rightMargin : parent.width * 0.1
        }
        model : songs_listview.model
        pathItemCount: songs_listview.pathItemCount
        currentIndex : songs_listview.currentIndex
        onMovingChanged :
        {
            if (!moving)
                songs_listview.positionViewAtIndex(currentIndex, PathView.Center)
        }

        delegate : Component {
            Item
            {
                width : 100
                height : width
                property bool isCurrentItem : index === PathView.view.currentIndex;
                z : isCurrentItem ? 1 : 0

                transform: Rotation {
                    angle : -45
                    axis {x : 0; y: 1; z : 0}
                    origin.x : width * 0.5;
                    origin.y : height * 0.5
                }

                Text
                {
                    text : model.track
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
                        songs_listview.positionViewAtIndex(index, PathView.Center);
                    }
                }
            }
        }
    }
}
