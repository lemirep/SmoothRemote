import QtQuick 2.1

Item
{
    anchors.fill: parent
    property variant movie : parent.getHolder();
    ScrollBar {flickable: movie_flickable}

    onMovieChanged: action_bar_loader.sourceComponent = action_bar_component;

    Flickable
    {
        id : movie_flickable
        contentHeight: movie_data.childrenRect.height * mainScreen.dpiMultiplier
        clip : true
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds

        Column
        {
            id : movie_data
            anchors
            {
                left : parent.left
                right : parent.right
                top : parent.top
                topMargin : 25
            }
            spacing: 15

            Text
            {
                color : "#e8e8e8"
                anchors.horizontalCenter: parent.horizontalCenter
                text : movie.title
                font.pointSize: 15 * mainScreen.dpiMultiplier
            }
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#e8e8e8"
                text : movie.year
                font.pointSize: 15 * mainScreen.dpiMultiplier
            }
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#e8e8e8"
                text : movie.studio
                font.pointSize: 12 * mainScreen.dpiMultiplier
            }
            Text
            {
                id : show_summary
                color : "#e8e8e8"
                text : movie.plot
                width: parent.width
                font.pointSize: 11  * mainScreen.dpiMultiplier
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
