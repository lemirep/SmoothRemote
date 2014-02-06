import QtQuick 2.1

Item
{
    id : slideMenuSectionDelegate
    property bool isCurrent : (ListView.view.currentIndex === index)
    width : ListView.view.width
    height : 70 * mainScreen.dpiMultiplier
    Rectangle {height : isCurrent ? 2 : 1; width : parent.width; anchors.bottom: parent.bottom; color : isCurrent ? "#aa2200": "#333333"}
    Text
    {
        id : delegate_text
        style: Text.Outline
        styleColor: parent.isCurrent ? "#22cc2200" : "#66cc2200"
        color : parent.isCurrent ? "#cc2200" :"white"
        text : model.sectionName
        anchors
        {
            left : parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 25
        }
//        font.family : "Helvetica"
        font.bold: true
        font.capitalization: Font.Capitalize
        font.italic: true
        font.pointSize: 20
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
