import QtQuick 2.1
import "Utils.js" as Utils

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
                leftMargin : 10
                rightMargin : 10
            }
            spacing: 15

            Text
            {
                color : "#e8e8e8"
                anchors.horizontalCenter: parent.horizontalCenter
                text : movie.title
                font.pointSize: 18 * mainScreen.dpiMultiplier
            }
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#e8e8e8"
                text : movie.year
                font.pointSize: 16 * mainScreen.dpiMultiplier
            }
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#e8e8e8"
                text : movie.studio
                font.pointSize: 14 * mainScreen.dpiMultiplier
            }
            Text
            {
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#e8e8e8"
                text : Utils.printDuration(movie.runtime);
                font.pointSize: 13 * mainScreen.dpiMultiplier
            }
            Text
            {
                id : show_summary
                color : "#e8e8e8"
                text : movie.plot
                width: parent.width
                font.pointSize: 12  * mainScreen.dpiMultiplier
                elide: Text.ElideRight
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
