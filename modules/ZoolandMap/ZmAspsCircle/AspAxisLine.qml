import QtQuick 2.12
import QtQuick.Shapes 1.12

Rectangle{
    id: r
    width: parent.width
    height: 5
    color: 'transparent'
    radius: width*0.5
    anchors.centerIn: parent

    property bool isExt: false
    property int numAstro: -1
    property int indexAsp: -1
    property color c: zm.objAspsCircle.aAspsColors[indexAsp]
    property int l: app.fs*8 //largo
    property real rot: 0
    rotation: 90-r.rot
    Timer{
        running:  !r.isExt?(aspsCircle.currentAspSelected===r.numAstro):(aspsCircleBack.currentAspSelected===r.nnmAstro)
        //running:  aspsCircle.currentAspSelected===r.n
        repeat: true
        interval: 400
        onRunningChanged: {
            if(!running){
                rectSel.opacity=0.0
                r.z=0
                if(!r.isExt){
                    zm.aspShowSelectedInt=false
                }else{
                    zm.aspShowSelectedExt=false
                }
            }
        }
        onTriggered: {
            if(rectSel.opacity===1.0){
                rectSel.opacity=0.0
                r.z=0
                if(!r.isExt){
                    zm.aspShowSelectedInt=false
                }else{
                    zm.aspShowSelectedExt=false
                }
                //zm.anv.n=''
            }else{
                rectSel.opacity=1.0
                if(!r.isExt){
                    zm.aspShowSelectedInt=true
                }else{
                    zm.aspShowSelectedExt=true
                }
                r.z=r.parent.children.length+1
            }
        }
    }
    Rectangle{
        id: rectSel
        width: r.l+2
        height: apps.aspLineWidth+2
        color: apps.fontColor
        anchors.centerIn: line
        opacity: 0.0
        //visible: false
    }
    Rectangle{
        id: line
        width: r.l
        height: apps.aspLineWidth
        color: r.c
        anchors.right: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
}
