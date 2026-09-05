import QtQuick 2.7
import ZoolandMap.ZmSignsCircle 1.0
import ZoolandMap.ZmHousesCircle 1.0
import ZoolandMap.ZmBodiesCircle 1.0
import ZoolandMap.ZmBodiesCircleExt 1.0
import ZoolandMap.ZmAspsCircle 1.0

Rectangle{
    id: r
    width: parent.width
    height: parent.height
    color: 'transparent'
    border.width: 1
    border.color: 'blue'
    property bool ev: false
    property real signRot: 0
    property int wrz: 0
    property alias objSignsCircle: signCircle
    property alias objBodiesCircle: zmBodiesCircle
    property alias objBodiesCircleExt: zmBodiesCircleExt
    property alias objHousesCircleExt: zmHousesCircleExt
    property alias tsaw: tsaw



    ZmSignsCircle{
        id: signCircle
        wrz: r.wrz
        wbrz: r.wrz*0.2
        width: parent.width-r.wrz
        height: parent.height
        anchors.centerIn: parent

    }
    ZmHousesCircle{
        id: zmHousesCircleExt
        width: parent.width+(zoolMap.bodieSize*zoolMap.posMaxExt)+(zoolMap.bodieSize*4)
        height: parent.height
        anchors.centerIn: parent
        isExt: true
        visible: app.modo==='rs'
    }
    ZmBodiesCircleExt{
        id: zmBodiesCircleExt
        width: parent.width+(r.wrz*2)
        //rotation: zmAspsCircle.rotation//zmBodiesCircle.rotation//signCircle.rotation
        visible: r.ev
    }
    ZmHousesCircle{
        id: zmHousesCircle
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
    }

    ZmAspsCircle{
        id: zmAspsCircle
        width: zoolMap.aspCircleWidth
        rotation: 0+90+zoolMap.signCircleRot+180
        visible: apps.showAsps
    }
    ZmBodiesCircle{
        id: zmBodiesCircle
        width: parent.width-(r.wrz*2)        
    }

    Rectangle{
        id: centro
        width: app.fs*0.5
        height: width
        color: 'yellow'
        radius: width*0.5
        anchors.centerIn: parent
        visible: false
    }
    Image{
        id: mundo
        width: app.fs
        height: width
        source: Qt.platform.os==='android'?'assets:/imgs/imgs_v2/earth.png':'file:///home/ns/nsp/zoolandv2/android/assets/imgs/imgs_v2/earth.png'
        rotation: 0
        anchors.centerIn: parent
        Behavior on rotation{NumberAnimation{duration:500; easing.type: Easing.InOutElastic}}
        Timer{
            running: app.uFilePathLoaded !=='' && app.currentJson && app.currentJson.pc && parent.rotation!==360-90-45-zoolMap.signCircleRot-app.currentJson.pc.c0.gdec
            repeat: true
            interval: 500
            onTriggered: {
                parent.rotation=360-90-45-zoolMap.signCircleRot-app.currentJson.pc.c0.gdec
            }
        }
    }
    Image{
        id: imgMundoGlobo
        anchors.fill: mundo
        anchors.centerIn: mundo
        source: Qt.platform.os==='android'?'assets:/imgs/imgs_v2/globos/gea.png':'file:///home/ns/nsp/zoolandv2/android/assets/imgs/imgs_v2/globos/gea.png'

        //sourceSize: Qt.size(width, height)

        // En MultiEffect, la imagen fuente DEBE ser invisible
        visible: !zoolMap.showGlifo
    }

    Text{
        id: txtCentral
        //text: 'MW:'+zoolMap.aspCircleWidth
        text:  'AR: '+app.appRotated
        font.pixelSize: zoolMap.fs*2
        color: 'red'
        anchors.centerIn: parent
        visible: false
    }
    property int currentBodieForAspsWidth: 0
    Timer{
        id: tsaw
        running: true
        repeat: false//true
        interval: 250
        onTriggered: {
            let nCurrentBodieForAspsWidth=-1
            let widthMenor=r.width
            for(var i=0;i<zoolMap.aBodies.length;i++){
                let bw=parseInt(zmBodiesCircle.getBodieWidth(i))
                if(bw<=widthMenor){
                    widthMenor=bw
                    //txtCentral.text=zoolMap.aBodies[i]+':|'+zoolMap.posMaxInt+'\n'+bw
                    //currentBodieForAspsWidth=i
                    nCurrentBodieForAspsWidth=i
                }
                zoolMap.zm.currentBodieForAspsWidth=nCurrentBodieForAspsWidth
            }
        }
    }
    Timer{
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            //zoolMap.aspCircleWidth=parseInt(zmBodiesCircle.getBodieWidth(zoolMap.zm.currentBodieForAspsWidth))-parseInt(zoolMap.bodieSize*0.5*(zoolMap.posMaxInt-1))-zoolMap.bodieSize*2
            //signCircle.
        }
    }
    function load(j){
        let signCircleRot=j.ph.h1.gdec
        signCircle.rotation=signCircleRot
        zoolMap.signCircleRot=signCircleRot
        zmBodiesCircle.load(j)
        zmHousesCircle.load(j)
        let jsonAsps=zmAspsCircle.getAsps(j)
        j.asps=jsonAsps
        zmAspsCircle.load(j)
        //console.log(JSON.stringify(jsonAsps, null, 2))
        //txt.text=JSON.stringify(jsonAsps, null, 2)
    }
    function loadHousesExt(j){
        zmHousesCircleExt.load(j)

        zmHousesCircleExt.width=zmHousesCircleExt.parent.width+((zoolMap.bodieSize*zoolMap.posMaxExt)*0.5)
        //zoolMap.posMaxExt
        //zmHousesCircleExt.rotation=90
    }
}
