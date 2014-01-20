import QtQuick 2.1

PathView
{
    anchors.fill: parent
    cacheItemCount : 20
    pathItemCount: mainScreen.portrait ? 3 : 5
    snapMode : PathView.SnapToItem
    preferredHighlightBegin : 0.5
    preferredHighlightEnd : 0.5
    highlightRangeMode : PathView.StrictlyEnforceRange

    path : Path  {
        // LEFT
        startX : parent.x
        startY: (parent.height * 0.5)
        PathAttribute {name : "delScale"; value : 0.5}
        PathAttribute {name : "delAngle"; value : 60}
        PathAttribute {name : "delZ"; value :0}

        // CENTER
        PathCurve {x : parent.width / 2; y : parent.height * 0.5}
        PathAttribute {name : "delScale"; value : 1}
        PathAttribute {name : "delAngle"; value : 0}
        PathAttribute {name : "delZ"; value : 100}

        //RIGHT
        PathCurve {x : parent.width; y : parent.height * 0.5}
        PathAttribute {name : "delScale"; value : 0.5}
        PathAttribute {name : "delAngle"; value : -60}
        PathAttribute {name : "delZ"; value : 0}
    }
}
