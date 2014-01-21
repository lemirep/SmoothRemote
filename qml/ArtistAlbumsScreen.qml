import QtQuick 2.1

Item
{
    id : artist_albums_rec
    anchors.fill: parent
    property variant artist;
    property bool shown : false
    opacity : 2 * artist_albums_item.width / width
    focus : shown && !songs_listview.focus
    onArtistChanged: core.refreshAlbumsForArtist(artist.artistid)
    enabled: shown

    onShownChanged:
    {
        if (shown)
        {
            topBanner.menuComponent = back_arrow;
            forceActiveFocus();
        }
        else
            topBanner.menuComponent = undefined;
    }

    Component
    {
        id : back_arrow
        Image
        {
            anchors
            {
                left : parent.left
                top : parent.top
                bottom : parent.bottom
            }
            fillMode: Image.PreserveAspectFit
            source : "Resources/back_arrow.png"
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (songs_listview.shown)
                        songs_listview.shown = false;
                    else
                        shown = false;
                }
            }
        }
    }

    Keys.onReleased:
    {
        console.log("Detail Key Released");
        if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace)
        {
            shown = false;
            event.accepted = true;
        }
    }

    Rectangle
    {
        color : "black"
        anchors.fill: parent
        opacity : 0.5
    }

    states: [
        State
        {
            AnchorChanges
            {
                target : artist_albums_item
                anchors.left : artist_albums_rec.left
            }
            when : shown;
        },
        State
        {
            AnchorChanges
            {
                target : artist_albums_item
                anchors.left : artist_albums_rec.right
            }
            when : !shown
        }]

    transitions: Transition {
        AnchorAnimation
        {
            duration : 750
            easing.type: Easing.InOutQuad
        }
    }

    Rectangle
    {
        id : artist_albums_item
        color : "#1e2124"
        anchors
        {
            top : parent.top
            bottom : parent.bottom
            right : parent.right
            left : parent.left
        }
        Rectangle
        {
            height : 5
            width : parent.height
            x : -5
            y : -5

            gradient : Gradient {
                GradientStop {position : 0.0; color : "#aa000000"}
                GradientStop {position : 1.0; color : "#00000000"}
            }
            rotation : 90
            transformOrigin: Item.BottomLeft
        }

        Text
        {
            id : artist_text_label
            anchors
            {
                horizontalCenter : parent.horizontalCenter
                top : parent.top
                topMargin : 25
            }
            font.pointSize: 25 * mainScreen.dpiMultiplier
            text : artist.artist
            style: Text.Outline
            styleColor: "#e8e8e8"
            elide: Text.ElideRight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width : parent.width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color : "white"
        }

        Text
        {
            id : album_text_label
            anchors
            {
                horizontalCenter : parent.horizontalCenter
                bottom : parent.bottom
                bottomMargin : 25
            }
            font.pointSize: 25 * mainScreen.dpiMultiplier
            style: Text.Outline
            styleColor: "#e8e8e8"
            elide: Text.ElideRight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width : parent.width
            color : "white"
        }

        CoverFlow
        {
            id : albums_gridview
            anchors.fill: parent
            model : artist.albumsModel

            delegate : Component {
                Image
                {
                    id : album_delegate
                    property real rotAngle : PathView.onPath ? PathView.delAngle : 0
                    property real delScale : PathView.onPath ? PathView.delScale : 0
                    property bool isCurrentItem : index === PathView.view.currentIndex;

                    width : mainScreen.portrait ? PathView.view.height * 0.5 : PathView.view.width * 0.4
                    height : width
                    scale : delScale
                    z : PathView.onPath ? PathView.delZ : -1
                    onStatusChanged: if (status === Image.Ready) scale_anim.start();
                    source : model.thumbnail
                    smooth : true

                    NumberAnimation {id : scale_anim; target : album_delegate; property: "scale"; from : 0; to : delScale; duration : 500; easing.type: Easing.InOutQuad}
                    NumberAnimation {id : flip_animation; target: flip_rotation; property: "angle"; duration:800; from : 0; to : 360; easing.type: Easing.InOutQuad }

                    transform: [Rotation {id : rotation; angle : rotAngle; axis {x : 0; y: 1; z : 0} origin.x : width * 0.5; origin.y : height * 0.5},
                        Rotation {id : flip_rotation; axis {x : 0; y: 1; z : 0} origin.x : width * 0.5; origin.y : height * 0.5}]

                    onIsCurrentItemChanged :
                    {
                        if (isCurrentItem)
                            album_text_label.text = model.title
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            if (isCurrentItem)
                            {
                                flip_animation.start();
                                songs_listview.model = model.songsModel;
                                songs_listview.shown = true;
                                songs_listview.albumId = model.albumid;
                            }
                            else
                                albums_gridview.currentIndex = index;
                        }
                    }
                }
            }
        }
    }

    AlbumSongsScreen
    {
        id : songs_listview
        anchors.fill: parent
    }
}
