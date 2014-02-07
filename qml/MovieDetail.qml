import QtQuick 2.2
import "Utils.js" as Utils


Image
{
    id : background_pic

    property QtObject movie : null;
    property bool shown : false;

    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    asynchronous: true
    enabled : shown
    source : (movie) ? movie.fanartUrl : ""

    Rectangle
    {
        anchors.fill: parent
        opacity : 0.4
        color : "black"
    }

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
                leftMargin : 25
                rightMargin : 25
            }
            spacing: 15

            Text
            {
                id : title_text
                style: Text.Sunken
                styleColor:"#cc6600"
                color : "#cc2200"
                font.pointSize: 35
                font.bold: true
                font.italic: true
                font.capitalization: Font.Capitalize
                width : parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide : Text.ElideRight
                text : movie.title
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text
            {
                id : studio_text
                style: Text.Outline
                styleColor:"#66cc2200"
                color : "white"
                font.italic: true
                font.bold: true
                font.pointSize: 25
                font.capitalization: Font.Capitalize
                width : parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide : Text.ElideRight
                text : movie.studio
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text
            {
                style: Text.Outline
                styleColor:"#66cc2200"
                color : "white"
                font.bold: true
                font.family: "Helvetica"
                font.italic: true
                anchors.horizontalCenter: parent.horizontalCenter
                text : Utils.printDuration(movie.runtime);
                font.pointSize: 15 * mainScreen.dpiMultiplier
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

            MediaActionBar
            {
                id : media_action_bar
                anchors.right : parent.right

                onPlayClicked: core.buttonAction(14, model.file);
                onAddClicked: {core.buttonAction(17, model.movieid);}
                onStreamClicked:  mainView.launchMediaPlayer(model.streamingFile); /*core.buttonAction(27, model.streamingFile);*/
            }
        }
        ScrollBar {flickable: movie_flickable}
    }
}
