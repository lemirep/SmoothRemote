import QtQuick 2.1
import Qt.labs.folderlistmodel 2.0

Rectangle
{
    color : "black"
    width: mainView.width
    height: mainView.height

    property bool shown : false;
    property url sourceDir : "/";
    property alias nameFilters : folder_model.nameFilters
    property bool selectDir : false
    signal fileSelected(string filePath);

    opacity : shown ? 1 : 0
    enabled : opacity === 1
    onShownChanged: if (shown) forceActiveFocus();

    Behavior on opacity {NumberAnimation {duration : 750}}

    Keys.onReleased:
    {
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            shown = false;
            event.accepted = true;
        }
    }

    FolderListModel
    {
        id : folder_model
        showDirs: true
        showDirsFirst: true
        showDotAndDotDot: true
        folder : "/"
    }

    Rectangle
    {
        id : header_bar
        height :70 * mainScreen.dpiMultiplier
        color : "#101010"
        anchors
        {
            left : parent.left
            right : parent.right
            top : parent.top
        }
        Image
        {
            source: "Resources/remove_inv.png"
            fillMode: Image.PreserveAspectFit
            anchors
            {
                top : parent.top
                bottom : parent.bottom
                right : parent.right
                margins : 15
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked: shown = false
            }
        }
        Image
        {
            id : check_folder
            opacity : 0
            source: "Resources/check_inv.png"
            fillMode: Image.PreserveAspectFit
            anchors
            {
                top : parent.top
                bottom : parent.bottom
                left : parent.left
                margins : 15
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    fileSelected(folder_model.folder);
                    shown = false;
                }
            }
        }
    }

    ListView
    {
        model : folder_model
        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
            top : header_bar.bottom
        }
        clip : true
        orientation: ListView.Vertical

        delegate : Component {
            Rectangle
            {
                color : del_ma.pressed ? "#a0a0a0" : model.fileIsDir ? "#151515" : "#080808"
                width : ListView.view.width
                height : selectDir ? (model.fileIsDir ? 70 * mainScreen.dpiMultiplier : 0) : 70 * mainScreen.dpiMultiplier
                Image
                {
                    id : del_img
                    height: parent.height - 20
                    fillMode: Image.PreserveAspectFit
                    anchors
                    {
                        left : parent.left
                        leftMargin : 15
                        verticalCenter : parent.verticalCenter
                    }
                    source : model.fileIsDir ? "Resources/folder_inv.png" : "Resources/page_inv.png";
                }
                Rectangle
                {
                    height: 1
                    anchors
                    {
                        left : parent.left
                        right : parent.right
                        bottom : parent.bottom
                    }
                    color : "#404040";
                }

                Text
                {
                    anchors
                    {
                        left : del_img.right
                        leftMargin : 15
                        right : parent.right
                        verticalCenter : parent.verticalCenter
                    }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    text : model.fileName
                    color : "white"
                }
                MouseArea
                {
                    id : del_ma
                    anchors.fill: parent
                    onClicked:
                    {
                        console.log(model.filePath);
                        if (model.fileIsDir)
                        {
                            folder_model.folder = "file://" + model.filePath;
                            if (selectDir)
                                check_folder.opacity = 1;
                        }
                        else
                        {
                            fileSelected(model.filePath);
                            shown = false;
                        }
                    }
                }
            }
        }
    }
}
