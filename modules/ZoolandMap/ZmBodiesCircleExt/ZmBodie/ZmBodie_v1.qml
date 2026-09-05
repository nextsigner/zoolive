import QtQuick
import QtQuick.Effects


Rectangle{
    id: r
    width: parent.width-(zoolMap.bodieSize*pos)
    height: 1//parent.width-(zoolMap.bodieSize*pos)
    color: 'transparent'
    anchors.centerIn: parent
    property int numBodie: -1
    property int is: -1
    property int ih: -1
    property int pos: 0
    onWidthChanged: {
        if(pos<0)return
        //tSetAspsWidth.restart()
    }
    //Behavior on width{NumberAnimation{duration: 0}}
    Timer{
        id: tSetAspsWidth
        running: r.numBodie===zoolMap.zm.currentBodieForAspsWidth && (zoolMap.aspCircleWidth!==r.width-(zoolMap.bodieSize*2))
        repeat: false
        interval: 200
        onTriggered: {
            zoolMap.aspCircleWidth=r.width-(zoolMap.bodieSize*2)
            zoolMap.zm.tsaw.restart()
        }

    }

    Rectangle{
        id: xBodie
        width: app.fs
        height: width
        radius: width*0.5
        color: 'transparent'
        border.width: 0
        border.color: 'white'
        rotation: 360-r.rotation
        anchors.verticalCenter: parent.verticalCenter
        MouseArea{
            anchors.fill: parent
            onDoubleClicked: {
                let j=app.currentJson
                let gms=app.getDDToDMS(j.pc['c'+r.numBodie].gdec)
                let is=app.getIndexSign(j.pc['c'+r.numBodie].gdec)
                r.is=is
                let ih=app.getHouseIndexFromArrayDegs(j.pc['c'+r.numBodie].gdec, app.getJsonPhToArray(j.ph))
                r.ih=ih
                zoolMap.currentIndexBodie=r.numBodie
                zoolMap.currentIndexSign=r.is
                zoolMap.currentIndexHouse=r.ih


            }
        }
        Image{
            id: img
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            source: Qt.platform.os==='android'?'assets:/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg':'/home/ns/nsp/zoolandv2/android/assets/imgs/imgs_v2/glifos/'+zoolMap.bodiesRes[r.numBodie]+'.svg'

            sourceSize: Qt.size(width, height)

            // En MultiEffect, la imagen fuente DEBE ser invisible
            visible: false
        }
        MultiEffect {
            id: multiEffect1
            anchors.fill: img
            source: img

            // 1. Convertimos el negro en algo "teñible" subiendo el brillo
            // Un brillo de 1.0 convierte el negro en blanco (valor 1.0)
            brightness: 1.0

            // 2. Aplicamos la colorización al 100%
            colorization: 1.0
            colorizationColor: zoolMap.bodieColor

            autoPaddingEnabled: true
            SequentialAnimation on colorization {
                id: seq1
                running: zoolMap.currentIndexBodie===r.numBodie
                loops: Animation.Infinite
                onRunningChanged: {
                    if(!running)multiEffect1.colorization=zoolMap.bodieColor
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
            }
        }

        MultiEffect {
            id: multiEffect2
            anchors.fill: img
            source: img

            // 1. Convertimos el negro en algo "teñible" subiendo el brillo
            // Un brillo de 1.0 convierte el negro en blanco (valor 1.0)
            brightness: 1.0

            // 2. Aplicamos la colorización al 100%
            colorization: 1.0
            colorizationColor: zoolMap.bodieColor

            autoPaddingEnabled: true
            SequentialAnimation on colorization {
                running: true//zoolMap.currentIndexBodie===r.numBodie
                loops: Animation.Infinite
                onRunningChanged: {
                    if(!running)multiEffect2.colorization='red'//zoolMap.bodieColor
                }
                ColorAnimation {
                    from: "black"
                    to: "green"
                    duration: 250
                }
                ColorAnimation {
                    from: "green"
                    to: "black"
                    duration: 250
                }
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

}