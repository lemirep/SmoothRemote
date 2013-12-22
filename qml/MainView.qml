import QtQuick 2.0

Item
{
    ListModel
    {
        id : sectionsModel
        ListElement
        {
            sectionName : "Remote"
            sectionSource : "RemoteScreen.qml"
        }
        ListElement
        {
            sectionName : "Audio"
            sectionSource : "AudioScreen.qml"
        }
        ListElement
        {
            sectionName : "Movies"
            sectionSource : "MovieScreen.qml"
        }
        ListElement
        {
            sectionName : "TV Shows"
            sectionSource : "TVShowScreen.qml"
        }
        ListElement
        {
            sectionName : "Settings"
            sectionSource : "SettingsScreen.qml"
        }
    }

    Loader
    {
        id : screenLoader
        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
            top : topBanner.bottom
        }
    }

    TopBanner
    {
        id : topBanner
    }

    SlideMenu
    {
        id : slideMenu
        anchors
        {
            left : parent.left
            right : parent.right
            bottom : parent.bottom
            top : topBanner.bottom
        }

        model : sectionsModel
        delegate : Component{
            Item
            {
                id : slideMenuSectionDelegate
                property bool isCurrent : (ListView.view.currentIndex === index)
                width : ListView.view.width
                height : 70
                Rectangle {height : isCurrent ? 4 : 1; width : parent.width; anchors.top: parent.top; color : isCurrent ? "#0066cc" : "#c8c8c8"}
                Text
                {
                    text: model.sectionName
                    color : "#505050"
                    anchors
                    {
                        left : parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 25
                    }
                    font.pointSize: 15
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        slideMenuSectionDelegate.ListView.view.currentIndex = index;
                        screenLoader.source = model.sectionSource;
                        slideMenu.deployed = false;
                    }
                }
            }
        }
        onCurrentIndexChanged:
        {
            console.log(index);
            topBanner.text = sectionsModel.get(index).sectionName
        }
    }
}
