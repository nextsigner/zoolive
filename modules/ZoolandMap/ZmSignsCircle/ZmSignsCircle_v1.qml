import QtQuick 2.0
import ZoolandMap.ZmSignsCircle.ZmSignArc 1.0
import ZoolandMap.ZmSignsCircle.ZmSignArcSen 1.0

Rectangle{
    id: r
    width: 500
    height: 500
    color: 'transparent'
    property int wrz: 0
    property int wbrz: 0
    Repeater{
        model: 12
        ZmSignArc{
            wrz: r.wrz
            is: index
            width: r.width
            height: width
            anchors.centerIn: parent
        }
    }
    Repeater{
        model: 12
        ZmSignArcSen{
            wrz: r.wbrz
            is: index
            width: r.width+r.wrz
            height: width
            anchors.centerIn: parent
        }
    }
}
