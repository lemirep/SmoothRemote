import QtQuick 2.0

Rectangle
{
    id : tvShowScreen
    anchors.fill: parent
    color : "#e8e8e8"

    DynamicGridView
    {
        id : grid_view
        anchors.fill: parent
        horizontal : true
        model : core.movieModel

        delegate : Component {
            Image
            {
                fillMode: Image.PreserveAspectFit
                source: model.thumbnail
                cache: true
                asynchronous: true
                scale : (status == Image.Ready) ? 1 : 0
                Behavior on scale {NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }}
                verticalAlignment: Image.AlignVCenter
                horizontalAlignment: Image.AlignHCenter
                height : tvShowScreen.height * 0.5
                Text
                {
                    color : "white"
                    text : model.title + " (" + model.year + ")"
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin : 15
                    }
                }
            }
        }
    }
}
