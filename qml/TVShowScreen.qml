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
        model : core.tvShowModel

        delegate : Component {
            Image
            {
                id : delegate_pic
                fillMode: Image.PreserveAspectFit
                source: model.thumbnail
                height : tvShowScreen.height * 0.5

                Text
                {
                    color : "white"
                    text : model.title
                    visible: delegate_pic.status === Image.Ready
                    anchors.centerIn: parent
                    width : delegate_pic.width
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        detail_view.tvShow = model;
                        detail_view.animateCover(delegate_pic.x - grid_view.contentX)
                    }
                }
            }
        }
    }

    TVShowDetailScreen
    {
        id : detail_view
        anchors.fill: parent
    }
}
