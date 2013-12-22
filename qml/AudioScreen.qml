import QtQuick 2.0

Rectangle
{
    id : audio_screen
    anchors.fill: parent
    color : "#e8e8e8"

    DynamicGridView
    {
        id : grid_view
        anchors.fill: parent
        horizontal : true
        model : core.audioArtistsModel

        delegate : Component {
            Item
            {
                height : 300; width : 300
                Text
                {
                    anchors.centerIn: parent
                    text : model.artist
                }
            }
//            Image
//            {
//                fillMode: Image.PreserveAspectFit
//                source: model.thumbnail
//                cache: true
//                asynchronous: true
//                scale : (status == Image.Ready) ? 1 : 0
//                Behavior on scale {NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }}
//                verticalAlignment: Image.AlignVCenter
//                horizontalAlignment: Image.AlignHCenter
//                height : audio_screen.height * 0.5
//                Text
//                {
//                    color : "white"
//                    text : model.title + " (" + model.year + ")"
//                    anchors
//                    {
//                        horizontalCenter: parent.horizontalCenter
//                        bottom: parent.bottom
//                        bottomMargin : 15
//                    }
//                }
//            }
        }
    }

}
