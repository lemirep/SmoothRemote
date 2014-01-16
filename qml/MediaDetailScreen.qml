import QtQuick 2.0

Item
{
    id : detail_view
    anchors.fill: parent

    property alias background : background_pic.source
    property alias cover : detail_pic.source
    property alias contentComponent : description_loader.sourceComponent
    property variant holder;
    property bool portrait : mainScreen.portrait
    property bool shown : false;
    property bool hasActionBar : false
    property var backFunction : function() {shown = false};
    enabled : shown

    function animateCover(x)
    {
        detail_pic.x = x;
        shown = true;
    }

    focus : shown

    onShownChanged:
    {
        if (shown)
            topBanner.menuComponent = back_arrow
        else
            topBanner.menuComponent = undefined
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
                    console.log("clicked");
                    backFunction();
                }
            }
        }
    }

    onActiveFocusChanged:
    {
        console.log("Active Focus "  + activeFocus)
    }

    onFocusChanged:
    {
        console.log("Focus " + focus)
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

    states : [State {
            PropertyChanges {target : detail_pic; scale : 1; x : 50}
            when : shown
        }]

    transitions: [
        Transition
        {
            SmoothedAnimation {duration : 500; velocity : 5; target: detail_pic; property: "x"}
            NumberAnimation {duration : 750; target: detail_pic; property: "scale"}
        }]

    Image
    {
        id : background_pic
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        opacity : detail_pic.scale
        enabled: detail_pic.scale === 1
        asynchronous: true
        MouseArea
        {
            anchors.fill: parent
            onClicked: {}
            onPressed: {}
        }
        Rectangle
        {
            anchors.fill: parent
            opacity : 0.4
            color : "black"
        }
    }

    ActionBar
    {
        id : action_bar
        opacity : detail_pic.scale
        enabled: detail_pic.scale === 1 && hasActionBar
    }

    Item
    {
        anchors
        {
            left : parent.left
            top : parent.top
            right : parent.right
            bottom : action_bar.top
        }

        states : [
            State
            {
                AnchorChanges
                {
                    target : detail_pic;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: undefined;
                    anchors.top: undefined
                }
                PropertyChanges {
                    target: detail_pic
                    x : 50
                }
                AnchorChanges
                {
                    target : show_detail
                    anchors.left: detail_pic.right
                    anchors.top: parent.top
                    anchors.right: parent.right
                }
                when : !portrait
            },
            State
            {
                AnchorChanges
                {
                    target : detail_pic;
                    anchors.verticalCenter: undefined;
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                }
                AnchorChanges
                {
                    target : show_detail
                    anchors.left: parent.left
                    anchors.top: detail_pic.bottom
                }
                when : portrait
            }
        ]

        CoverImage
        {
            id : detail_pic
            scale : 0
            enabled: scale === 1
            onClicked: shown = false;
            horizontalAlignment : (portrait) ? Image.AlignHCenter : Image.AlignLeft
            width : parent.width * 0.2
            anchors.topMargin: 25
        }

        Item
        {
            id : show_detail
            enabled: opacity === 1
            opacity: (detail_pic.scale === 1) ? 1 : 0
            anchors
            {
                right: parent.right
                bottom: parent.bottom
                leftMargin : 50
                rightMargin : 50
            }

            Loader
            {
                id : description_loader
                anchors.fill: parent
                function getHolder() {return detail_view.holder}
            }
        }
    }
}
