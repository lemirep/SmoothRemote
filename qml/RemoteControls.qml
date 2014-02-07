import QtQuick 2.2
import QtGraphicalEffects 1.0

Item
{
    anchors.fill: parent

    LinearGradient
    {
        anchors.fill: parent
        start: Qt.point(width, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop {position: 0; color: "#25282d"}
            GradientStop {position: 1; color: "black"}
        }
    }

    Text
    {
        fontSizeMode: Text.Fit
        font.bold: true
        font.italic: true
        font.family: "Helvetica"
        style: Text.Sunken
        styleColor: "#44ff2200";
        color : "#44111111";
        text : "Remote"
        font.pointSize: 200
        anchors
        {
            top : parent.top
            bottom : parent.verticalCenter
            left : parent.horizontalCenter
            right : parent.right
            margins : 25
        }
    }

    Row
    {
        spacing : 20 * mainScreen.dpiMultiplier
        anchors
        {
            bottom : arrow_controls.top
            top : parent.top
            horizontalCenter : parent.horizontalCenter
        }

        Image
        {
            source : "Resources/sync.png"
            rotation : -90
            height: 100
            width : 100
            fillMode: Image.PreserveAspectFit
            scale : refresh_ma.pressed ? 0.9 : 1

            anchors
            {
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : refresh_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(23);
                }
            }
        }

        Image
        {
            source : "Resources/info.png"
            scale : info_ma.pressed ? 0.9 : 1
            height: 100
            width : 100
            fillMode: Image.PreserveAspectFit
            anchors
            {
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : info_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(24);
                }
            }
        }
    }


    Item
    {
        id : arrow_controls
        width : 400
        height: width
        anchors.centerIn: parent

        Image
        {
            source : "Resources/arrow.png"
            rotation : -90
            scale : left_ma.pressed ? 0.9 : 1

            anchors
            {
                left : parent.left
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : left_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(2);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            scale : up_ma.pressed ? 0.9 : 1

            anchors
            {
                top : parent.top
                horizontalCenter : parent.horizontalCenter
            }

            MouseArea
            {
                id : up_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(0);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            rotation : 90
            scale : right_ma.pressed ? 0.9 : 1

            anchors
            {
                right : parent.right
                verticalCenter : parent.verticalCenter
            }

            MouseArea
            {
                id : right_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(3);
                }
            }
        }
        Image
        {
            source : "Resources/arrow.png"
            rotation : 180
            scale : down_ma.pressed ? 0.9 : 1

            anchors
            {
                bottom : parent.bottom
                horizontalCenter : parent.horizontalCenter
            }

            MouseArea
            {
                id : down_ma
                anchors.fill: parent
                onClicked:
                {
                    core.buttonAction(1);
                }
            }
        }

        Rectangle
        {
            anchors.centerIn: parent
            width : 128;
            height : 128
            radius : width
            color : "#2c2c2c"
            scale : validate_ma.pressed ? 0.9 : 1

            MouseArea
            {
                id : validate_ma
                anchors.fill: parent
                onClicked: core.buttonAction(4);
            }
        }
    }
    Image
    {
        source : "Resources/repeat.png"
        rotation : 90
        width : 100
        height : 100
        scale : back_button_ma.pressed ? 0.9 : 1
        fillMode: Image.PreserveAspectFit
        anchors
        {
            top : arrow_controls.bottom
            left : arrow_controls.left
        }

        MouseArea
        {
            id : back_button_ma
            anchors.fill: parent
            onClicked: core.buttonAction(5);
        }
    }
}
