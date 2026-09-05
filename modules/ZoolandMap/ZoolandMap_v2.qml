import QtQuick
import QtQuick.Controls
import ZoolandMap.Zm 1.0 // Mantengo tu import
import ZmButton 1.0
Rectangle {
    id: r
    width: parent ? parent.width : 400
    height: width
    color: apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    clip: true
    anchors.horizontalCenter: parent.horizontalCenter

    property alias zm: zm
    property int fs: 50
    property int wrz: r.fs

    //Bodies
    property int bodieSize: r.fs
    property color bodieColor: 'white'
    property int aspCircleWidth: -1
    property int posMaxInt: 0
    property int posMaxExt: 0

    //Houses
    property int wl: app.fs*0.1
    property color cl: 'white'

    //Status
    property real signCircleRot: 0.0

    property int currentIndexBodie: -1
    property int currentIndexSign: -1
    property int currentIndexHouse: -1
    property string currentStrDdMmSs: '°0 \'0 \'\'0'
    property string currentStrDdMmSsExt: '°0 \'0 \'\'0'


    property int currentIndexBodieExt: -1
    property int currentIndexSignExt: -1
    property int currentIndexHouseExt: -1

    //Astrología
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Sur', 'N.Norte', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']
    property var bodiesRes: ['sun', 'moon', 'mercury', 'venus', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto', 's', 'n', 'hiron', 'selena', 'lilith', 'pholus', 'ceres', 'pallas', 'juno', 'vesta']



    onCurrentIndexBodieExtChanged: {
        let t=txt.text
        //txt.text='CurrentIndexBodieExt:'+currentIndexBodieExt+'\n'+t
    }

    Flickable {
        id: flick
        anchors.fill: parent

        // Forzamos un área de contenido real
        contentWidth: Math.ceil(container.width * container.scale)
        contentHeight: Math.ceil(container.height * container.scale)

        // --- CONFIGURACIÓN PARA EVITAR PARPADEO ---
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        pixelAligned: false // IMPORTANTE: false para que el movimiento sea fluido (sub-pixel)
        pressDelay: 0

        // Esto mapea automáticamente los eventos de mouse a gestos de flick
        // Evita conflictos entre el motor de render y los Handlers
        property bool zooming: pinchHandler.active || wheelHandler.active

        // Contenedor visual
        Rectangle {
            id: container
            width: r.width
            height: r.height
            color: "transparent"
            transformOrigin: Item.Center

            // Optimizamos el renderizado durante el movimiento
            layer.enabled: flick.moving || flick.zooming
            layer.smooth: true

            Zm{
                id: zm
                width: parent.width*0.8
                height: parent.height*0.8
                x: parent.width*0.1
                y: parent.height*0.1
                wrz: r.wrz
            }
        }

        // --- EL TRUCO PARA EL MOUSE SIN CÓDIGO ---
        // En lugar de calcular deltas, usamos un MouseArea transparente
        // que "engaña" al Flickable para que use su lógica nativa de arrastre.
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton

            // Esto permite que el evento pase al Flickable como si fuera un Touch
            onPressed: (mouse) => mouse.accepted = false
            onWheel: (wheel) => wheel.accepted = false
        }

        PinchHandler {
            id: pinchHandler
            target: container
            minimumScale: 0.5
            maximumScale: 8.0
        }

        WheelHandler {
            id: wheelHandler
            target: container
            onWheel: (event) => {
                let delta = event.angleDelta.y > 0 ? 1.1 : 0.9
                let nextScale = container.scale * delta
                if (nextScale >= 0.5 && nextScale <= 8.0) {
                    container.scale = nextScale
                }
            }
        }
    }

    Rectangle{
        id: xTxtBodieSelected
        width: txtBodieSelected.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        visible: r.currentIndexBodie>-1 && r.currentIndexSign>-1 && r.currentIndexHouse>-1
        Rectangle{
            anchors.fill: parent
            color: apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text{
            id: txtBodieSelected
            text: '<b>'+r.aBodies[r.currentIndexBodie]+' '+app.aSigns[r.currentIndexSign]+' Casa '+parseInt(r.currentIndexHouse+1)+'</b><br>'+r.currentStrDdMmSs
            font.pixelSize: app.fs*0.5
            color: apps.fontColor
            anchors.centerIn: parent
        }
    }
    Rectangle{
        id: xTxtBodieSelectedExt
        width: txtBodieSelectedExt.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.right: parent.right
        visible: r.currentIndexBodieExt>-1 && r.currentIndexSignExt>-1 && r.currentIndexHouseExt>-1
        Rectangle{
            anchors.fill: parent
            color: 'red'//apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text{
            id: txtBodieSelectedExt
            text: '<b>'+r.aBodies[r.currentIndexBodieExt]+' '+app.aSigns[r.currentIndexSignExt]+' Casa '+parseInt(r.currentIndexHouseExt+1)+'</b><br>'+r.currentStrDdMmSsExt
            font.pixelSize: app.fs*0.5
            color: 'white'//apps.fontColor
            anchors.centerIn: parent
        }
    }
    ZmButton{
        text: 'V'
        onClicked:{
            if(zoolMap.parent===xApp){
                zoolMap.parent=xZoolandMap
            }else{
                zoolMap.parent=xApp
            }
        }
    }
}