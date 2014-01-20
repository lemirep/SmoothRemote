import QtQuick 2.1

Item
{
    anchors.fill: parent

    ListView
    {
        anchors.fill: parent
        model : core.playlistsModel
    }
}
