import QtQuick 2.2

PathView
{
    id : path_view
    cacheItemCount : 20
    pathItemCount: mainScreen.portrait ? 4 : 5
    snapMode : PathView.SnapToItem
    preferredHighlightBegin : 0.5
    preferredHighlightEnd : 0.5
    property bool leftToRight : true
    highlightRangeMode : PathView.StrictlyEnforceRange

    path : Path  {
        startX : leftToRight ? 0 : width
        startY: 0
        PathAttribute {name : "delScale"; value : 0.3}
        PathAttribute {name : "delZ"; value : 0}

        PathLine {x : width * 0.5; y : height * 0.5}
        PathAttribute {name : "delZ"; value : 0.5}

        PathLine {x : leftToRight ? width : 0; y : height}
        PathAttribute {name : "delScale"; value : 1}
        PathAttribute {name : "delZ"; value : 1}
    }
}
