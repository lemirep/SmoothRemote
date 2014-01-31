import QtQuick 2.1

Row
{
    id : media_action
    spacing : 25
    anchors
    {
        verticalCenter : parent.verticalCenter
        right : parent.right
        rightMargin : 25
    }
    enabled: opacity === 1
    signal playClicked();
    signal downloadClicked();
    signal streamClicked();
    signal addClicked();

    height : 55 * mainScreen.dpiMultiplier
    Image
    {
        height: parent.height - 15
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        source : "Resources/play_inv.png"
        scale : play_button_ma.pressed ? 0.9 : 1
        MouseArea
        {
            id : play_button_ma
            anchors.fill: parent
            onClicked: playClicked();
        }
    }
    Image
    {
        height: parent.height - 15
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        source : "Resources/plus_inv.png"
        scale : add_button_ma.pressed ? 0.9 : 1
        MouseArea
        {
            id : add_button_ma
            anchors.fill: parent
            onClicked: addClicked();
        }
    }
    Image
    {
        height: parent.height - 15
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        source : "Resources/cloud_inv.png"
        scale : cloud_button_ma.pressed ? 0.9 : 1
        MouseArea
        {
            id : cloud_button_ma
            anchors.fill: parent
            onClicked: streamClicked();
        }
    }
//    Image
//    {
//        height: parent.height - 15
//        rotation : 180
//        anchors.verticalCenter: parent.verticalCenter
//        fillMode: Image.PreserveAspectFit
//        horizontalAlignment: Image.AlignHCenter
//        verticalAlignment: Image.AlignVCenter
//        source : "Resources/download_inv.png"
//        scale : dl_button_ma.pressed ? 0.9 : 1
//        MouseArea
//        {
//            id : dl_button_ma
//            anchors.fill: parent
//            onClicked: downloadClicked();
//        }
//    }
}
