import QtQuick 2.0

Rectangle{
    id: r
    color: 'transparent'
    anchors.centerIn: parent
    property int ih: 0
    property color cl: zoolMap.cl
    property bool isExt: false
    SequentialAnimation on cl{
        running: !r.isExt?zoolMap.currentIndexHouse===r.ih:zoolMap.currentIndexHouseExt===r.ih
        loops: Animation.Infinite
        onRunningChanged: {
            if(!running)r.cl=zoolMap.cl
        }

        ColorAnimation {
            from: "red"
            to: "yellow"
            duration: 200
        }
        ColorAnimation {
            from: "yellow"
            to: "red"
            duration: 200
        }
    }
    Rectangle{
        width: parent.width+zoolMap.bodieSize*2
        height: zoolMap.wl
        color: 'transparent'
        anchors.centerIn: parent
        Rectangle{
            width: (parent.width*0.5)-zoolMap.bodieSize*0.5
            height: parent.height
            color: r.cl
            anchors.right: parent.horizontalCenter
            Rectangle{
                width: zoolMap.bodieSize*1.2
                height: width
                radius: width*0.5
                color: 'transparent'
                border.width: zoolMap.wl
                border.color: r.cl
                rotation: 360-r.rotation
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 0-parent.height*0.5
                anchors.right: parent.left
                Rectangle{
                    color: apps.backgroundColor
                    radius: width*0.5
                    opacity: 0.75
                    anchors.fill: parent
                    z: parent.z-1
                }
                MouseArea{
                    enabled: !zoolMap.zoomingOrPaning
                    anchors.fill: parent
                    onClicked: {
                        if(!r.isExt){
                            if(zoolMap.currentIndexHouse===r.ih){
                                zoolMap.currentIndexHouse=-1
                            }else{
                                zoolMap.currentIndexHouse=r.ih
                            }
                        }else{
                            if(zoolMap.currentIndexHouseExt===r.ih){
                                zoolMap.currentIndexHouseExt=-1
                            }else{
                                zoolMap.currentIndexHouseExt=r.ih
                            }

                        }

                    }
                }
                Text{
                    text: '<b>'+parseInt(r.ih+1)+'</b>'
                    font.pixelSize: parent.width*0.5//zoolMap.bodieSize*0.4
                    color: r.cl
                    //rotation: 360-r.rotation
                    horizontalAlignment: Text.AlignHCenter
                    opacity: zoolMap.zoomingOrPaning?0.75:1.0
                    Behavior on opacity{NumberAnimation{duration:250}}
                    anchors.centerIn: parent
                }
            }
        }
    }
}
