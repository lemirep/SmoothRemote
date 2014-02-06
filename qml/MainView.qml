import QtQuick 2.1

Item
{
    id : mainView
    property int oldIdx : -1;
    property string movieToPlay : "";
    focus : true

    function launchMediaPlayer(fileToPlay)
    {
        movieToPlay = fileToPlay;
        slideMenu.setMenuItemIndex(0);
    }

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
        console.log("MainView Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            slideMenu.setMenuItemIndex(0);
            event.accepted = true;
        }
    }

    ListModel
    {
        id : sectionsModel
        ListElement
        {
            sectionName : "Remote"
            sectionSource : "RemoteScreen.qml"
            sectionColor : "yellow"
            sectionIcon : "Resources/move2.png"
        }
        ListElement
        {
            sectionName : "Audio"
            sectionSource : "AudioScreen.qml"
            sectionColor : "red"
            sectionIcon : "Resources/headphones.png"
        }
        ListElement
        {
            sectionName : "Movies"
            sectionSource : "MovieScreen.qml"
            sectionColor : "purple"
            sectionIcon : "Resources/movie.png"
        }
        ListElement
        {
            sectionName : "TV Shows"
            sectionSource : "TVShowScreen.qml"
            sectionColor : "blue"
            sectionIcon : "Resources/television.png"
        }
        ListElement
        {
            sectionName : "Settings"
            sectionSource : "SettingsScreen.qml"
            sectionColor : "grey"
            sectionIcon : "Resources/cog.png"
        }
    }

    Loader
    {
        id : screenLoader
        anchors
        {
            top : topBanner.bottom
            left : parent.left
            right : parent.right
            bottom : parent.bottom
        }
        onSourceChanged: topBanner.menuComponent = undefined;
    }

    TopBanner
    {
        id : topBanner
    }

//    FileBrowser
//    {
//        shown: true
//    }

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
