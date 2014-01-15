import QtQuick 2.0

Item
{
    id : mainView
    property int oldIdx : -1;
    focus : true

    onActiveFocusChanged:
    {
        console.log("Main Active Focus "  + activeFocus)
    }

    onFocusChanged:
    {
        console.log("Main Focus " + focus)
    }

    Keys.onReleased:
    {
        console.log("Main Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
            slideMenu.setMenuItemIndex(0);
    }

    ListModel
    {
        id : sectionsModel
        ListElement
        {
            sectionName : "Remote"
            sectionSource : "RemoteScreen.qml"
            sectionColor : "yellow"
        }
        ListElement
        {
            sectionName : "Audio"
            sectionSource : "AudioScreen.qml"
            sectionColor : "red"
        }
        ListElement
        {
            sectionName : "Movies"
            sectionSource : "MovieScreen.qml"
            sectionColor : "purple"
        }
        ListElement
        {
            sectionName : "TV Shows"
            sectionSource : "TVShowScreen.qml"
            sectionColor : "blue"
        }
        ListElement
        {
            sectionName : "Settings"
            sectionSource : "SettingsScreen.qml"
            sectionColor : "grey"
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
        delegate : SlideMenuDelegate {}
        onCurrentIndexChanged:
        {
            topBanner.text = sectionsModel.get(index).sectionName;
            screenLoader.source = sectionsModel.get(index).sectionSource;
        }
    }
}
