import QtQuick 2.2


ShaderEffect
{
    id : grid_view_shader
    property bool shown;
    property QtObject selectedMovie : null;
    signal movieSelected();

    property variant src : shader_source
    onStatusChanged: console.log(log)
    width: grid_view.width
    height: grid_view.height

    mesh : GridMesh {
        resolution: Qt.size(20,20);
    }

    vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            uniform highp float width;

            void main()
            {
                highp vec4 pos = qt_Vertex;
//                highp float wx = smoothstep(0, 1, qt_MultiTexCoord0.x)
                pos.y += 0.5;

                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * pos;
            }
        "

    fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;

            void main()
            {
                gl_FragColor = texture2D(src, coord) * qt_Opacity;
            }
        "

    ShaderEffectSource
    {
        id : shader_source
        sourceItem: grid_view
        width: grid_view.width
        height: grid_view.height
        anchors.fill: parent
        hideSource: true
        live : true
    }

    GridView
    {
        id : grid_view

        property real swipeAngle : horizontalVelocity * 0.02

        cacheBuffer: width * 2
        anchors.fill: parent
        flow : GridView.TopToBottom
        model : core.movieModel
        cellHeight : Math.floor(height * 0.5)
        cellWidth : Math.floor(0.675 * cellHeight)
        snapMode : GridView.SnapToRow

        Behavior on swipeAngle { SpringAnimation {spring : 1.5; damping : 0.8; epsilon: 0.25} }

        //    transform: Rotation {
        //        angle : Math.abs(grid_view.swipeAngle) < 30 ? grid_view.swipeAngle : (grid_view.swipeAngle < 0) ? -30 : 30
        //        axis {x : 0; y: 1; z : 0}
        //        origin.x : width * 0.5
        //        origin.y : height * 0.5
        //    }

        delegate : VideoCoverDelegate {
            width : GridView.view.cellWidth
            height: GridView.view.cellHeight
            fillMode: Image.PreserveAspectCrop
            source: model.thumbnailUrl
            text : model.title + " (" + model.year + ")"
            opacity : 1 - (Math.abs(grid_view.swipeAngle) * 0.01)
            onClicked:
            {
                grid_view_shader.selectedMovie = model;
                grid_view_shader.movieSelected();
            }
        }
        ScrollBar    {flickable: grid_view}
    }
}
