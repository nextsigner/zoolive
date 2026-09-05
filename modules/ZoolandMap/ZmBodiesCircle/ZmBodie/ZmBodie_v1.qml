import QtQuick 2.0
//import QtQuick.Effects
import QtGraphicalEffects 1.0


Rectangle{
    id: r
    width: !isExt?parent.width-(zoolMap.bodieSize*pos):parent.width+(zoolMap.bodieSize*2*pos)+zoolMap.bodieSize*3
    height: 1//parent.width-(zoolMap.bodieSize*pos)
    color: 'transparent'
    anchors.centerIn: parent
    property bool isExt: false
    property int numBodie: -1
    property int is: -1
    property int ih: -1
    property int pos: 0
    property bool isRetro: false
    property color currentColor: apps.fontColor
    onWidthChanged: {
        if(pos<0)return
        //tSetAspsWidth.restart()
    }
    //onRotationChanged: setStatus(false)
    //Behavior on width{NumberAnimation{duration: 0}}
    Timer{
        id: tSetAspsWidth
        running: !r.isExt?(r.numBodie===zoolMap.zm.currentBodieForAspsWidth && (zoolMap.aspCircleWidth!==r.width-(zoolMap.bodieSize*2))): false
        repeat: false
        interval: 200
        onTriggered: {
            zoolMap.aspCircleWidth=r.width-(zoolMap.bodieSize*4)
            zoolMap.zm.tsaw.restart()
        }

    }
    SequentialAnimation on currentColor {
        id: seq1
        running: !r.isExt?(zoolMap.currentIndexBodie===r.numBodie):(zoolMap.currentIndexBodieExt===r.numBodie)
        loops: Animation.Infinite
        onRunningChanged: {
            if(!running)r.currentColor=zoolMap.bodieColor
        }
        ColorAnimation {
            from: "yellow"
            to: "red"
            duration: 250
        }
        ColorAnimation {
            from: "red"
            to: "yellow"
            duration: 250
        }
        ScriptAction{
            script: setStatus(false)
        }
    }

    Rectangle{
        width: parent.width*0.5
        height: 1
        color: r.currentColor//multiEffect1.colorization
        anchors.verticalCenter: parent.verticalCenter
        visible: r.isExt
        anchors.left: parent.left
        anchors.leftMargin: xBodie.width
    }
    Rectangle{
        id: xBodie
        width: zoolMap.bodieSize
        height: width
        radius: width*0.5
        color: 'transparent'
        border.width: 0
        border.color: 'white'
        rotation: 360-r.rotation
        anchors.verticalCenter: parent.verticalCenter
        opacity: zoolMap.zoomingOrPaning?0.75:1.0
        Behavior on opacity{NumberAnimation{duration:250}}
        MouseArea{
            enabled: !zoolMap.zoomingOrPaning
            anchors.fill: parent
            onClicked: {
                setStatus(true)
                return
                if(!r.isExt && zoolMap.currentIndexBodie===r.numBodie){
                    zoolMap.currentIndexBodie=-1
                    zoolMap.currentIndexSign=-1
                    zoolMap.currentIndexHouse=-1
                    return
                }
                if(r.isExt && zoolMap.currentIndexBodieExt===r.numBodie){
                    zoolMap.currentIndexBodieExt=-1
                    zoolMap.currentIndexSignExt=-1
                    zoolMap.currentIndexHouseExt=-1
                    return
                }
                let j
                if(!r.isExt){
                    j=app.currentJson
                }else{
                    j=app.currentJsonExt
                }
                let gms=app.getDDToDMS(j.pc['c'+r.numBodie].gdec)
                let is=app.getIndexSign(j.pc['c'+r.numBodie].gdec)
                r.is=is
                let ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(j.ph))
                if(!r.isExt){
                    ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(j.ph))
                }else{
                    ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(app.currentJson.ph))
                }
                r.ih=ih
                let rsgdeg=0
                if(!r.isExt){
                    zoolMap.currentIndexBodie=r.numBodie
                    zoolMap.currentIndexSign=r.is
                    zoolMap.currentIndexHouse=r.ih
                    rsgdeg=parseInt(gms.deg-(30*(r.is)))
                    zoolMap.currentStrDdMmSs='°'+rsgdeg+' \''+gms.min+' \'\''+parseInt(gms.sec)
                }else{
                    zoolMap.currentIndexBodieExt=r.numBodie
                    zoolMap.currentIndexSignExt=r.is
                    zoolMap.currentIndexHouseExt=r.ih
                    rsgdeg=parseInt(gms.deg-(30*(r.is)))
                    zoolMap.currentStrDdMmSsExt='°'+rsgdeg+' \''+gms.min+' \'\''+parseInt(gms.sec)
                }
            }
        }
        Image{
            id: img
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            //source: Qt.platform.os==='android'?'assets:/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg':'file:///home/ns/nsp/timelineview/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg'
            source: 'file:///home/ns/nsp/timelineview/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg'

            //sourceSize: Qt.size(width, height)

            // En MultiEffect, la imagen fuente DEBE ser invisible
            visible: false
        }
        Image{
            id: imgGlobo
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: Qt.platform.os==='android'?'assets:/imgs/imgs_v2/globos/'+r.numBodie+'.png':'file:///home/ns/nsp/zoolandv2/android/assets/imgs/imgs_v2/globos/'+r.numBodie+'.png'

            //sourceSize: Qt.size(width, height)

            // En MultiEffect, la imagen fuente DEBE ser invisible
            visible: !zoolMap.showGlifo
            Rectangle{
                width: parent.width+app.fs*0.1
                height: width
                color: 'transparent'
                border.width: app.fs*0.2
                border.color: r.currentColor
                radius: width*0.5
                z:parent.z-1
                anchors.centerIn: parent

            }
        }
        ColorOverlay {
            id: multiEffectBorde
            anchors.fill: img
            source: img
            visible: !seq1.running && zoolMap.showGlifo

            color: "red"

        }
        ColorOverlay {
            id: multiEffect1
            anchors.fill: img
            source: img

            color: r.currentColor//zoolMap.bodieColor

            visible: zoolMap.showGlifo
        }

        Rectangle{
            width: parent.width*0.5
            height: width
            radius: width*0.5
            color: 'transparent'//apps.backgroundColor
            border.width: 0
            border.color: apps.fontColor
            anchors.centerIn: parent
            visible: r.isRetro
            Text{
                text:'<b>R</b>'
                color: r.currentColor//apps.fontColor
                font.pixelSize: parent.width*0.8
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: r.numBodie!==0?xBodie.width*0.5:xBodie.width*0.65
            }
        }
    }
    Rectangle{
        id: ejeBodie
        width: parent.width*0.5
        height: 20//1
        color: r.numBodie===zoolMap.zm.currentBodieForAspsWidth?'red':'transparent'
        //anchors
        //anchors.verticalCenter: parent.verticalCenter
        //anchors.right: parent.horizontalCenter
        visible: false
        Rectangle{
            width: zoolMap.bodieSize
            height: width
            radius: width*0.5
            color: 'transparent'
            border.width: 0
            border.color: 'red'
            anchors.verticalCenter: parent.verticalCenter
            rotation: 360-r.rotation//+zoolMap.signCircleRot
            //rotation: 360-r.rotation-zoolMap.signCircleRot
            Text{
                text: 'i:'+zoolMap.zm.currentBodieForAspsWidth
                font.pixelSize: 20
                color: 'green'
                anchors.centerIn: parent
            }
        }
    }
    function setStatus(fromClick, update){
        if(fromClick){
            if(!r.isExt && zoolMap.currentIndexBodie===r.numBodie){
                zoolMap.currentIndexBodie=-1
                zoolMap.currentIndexSign=-1
                zoolMap.currentIndexHouse=-1
                r.z=zoolMap.zm.objBodiesCircle.getMaxZBodie()+50
                return
            }
            if(r.isExt && zoolMap.currentIndexBodieExt===r.numBodie){
                zoolMap.currentIndexBodieExt=-1
                zoolMap.currentIndexSignExt=-1
                zoolMap.currentIndexHouseExt=-1
                r.z=zoolMap.zm.objBodiesCircleExt.getMaxZBodie()+50
                return
            }
        }
        let j
        if(!r.isExt){
            if(!app.currentJson)return
            j=app.currentJson
            r.z=zoolMap.zm.objBodiesCircle.getMaxZBodie()+50
        }else{
            if(!app.currentJsonExt)return
            j=app.currentJsonExt
            r.z=zoolMap.zm.objBodiesCircleExt.getMaxZBodie()+50
        }
        let gms=app.getDDToDMS(j.pc['c'+r.numBodie].gdec)
        let is=app.getIndexSign(j.pc['c'+r.numBodie].gdec)
        r.is=is
        let ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(j.ph))
        if(!r.isExt){
            ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(j.ph))
        }else{
            ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(app.currentJson.ph))
        }
        r.ih=ih
        let rsgdeg=0
        //if(fromClick){
        if(!r.isExt){
            zoolMap.currentIndexBodie=r.numBodie
            zoolMap.currentIndexSign=r.is
            zoolMap.currentIndexHouse=r.ih
            rsgdeg=parseInt(gms.deg-(30*(r.is)))
            zoolMap.currentStrDdMmSs='°'+rsgdeg+' \''+gms.min+'\'\''+parseInt(gms.sec)
        }else{
            zoolMap.currentIndexBodieExt=r.numBodie
            zoolMap.currentIndexSignExt=r.is
            zoolMap.currentIndexHouseExt=r.ih
            rsgdeg=parseInt(gms.deg-(30*(r.is)))
            zoolMap.currentStrDdMmSsExt='°'+rsgdeg+' \''+gms.min+'\'\''+parseInt(gms.sec)
        }
        //}
    }
}
