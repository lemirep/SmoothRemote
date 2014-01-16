import QtQuick 2.0

Item
{
    id : slideMenuSectionDelegate
    property bool isCurrent : (ListView.view.currentIndex === index)
    width : ListView.view.width
    height : 70 * mainScreen.dpiMultiplier
    Rectangle {height : isCurrent ? 4 : 1; width : parent.width; anchors.bottom: parent.bottom; color : isCurrent ? model.sectionColor : "#c8c8c8"}
    Text
    {
        id : delegate_text
        color : "#505050"
        text : model.sectionName
        anchors
        {
            left : parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 25
        }
        font.pointSize: 15
    }
    Image
    {
        anchors
        {
            top : parent.top
            bottom : parent.bottom
            right : parent.right
            margins : 10 * mainScreen.dpiMultiplier
        }
        source : model.sectionIcon
        fillMode: Image.PreserveAspectFit
    }
    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            slideMenuSectionDelegate.ListView.view.currentIndex = index;
            slideMenu.deployed = false;
        }
    }
}
