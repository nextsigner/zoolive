import QtQuick 2.7
import QtQuick.Controls 2.0
import ZoolandMap.Zm 1.0
import ZmButton 1.0

Rectangle {
    id: r
    //width: parent ? parent.width : 400
    //height: parent===xApp?xApp.height:width
    color: apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    clip: false//!app.appRotated
    anchors.horizontalCenter: parent.horizontalCenter
    property alias zm: zm
    property alias  zoom: container.zoom
    property alias colTools: colTools
    property alias xToolsTop: xToolsTop
    property int fs: 50
    property int wrz: r.fs*0.75
    property bool zoomingOrPaning: false

    //Bodies
    property bool showGlifo: true
    property int bodieSize: r.fs*0.75
    property color bodieColor: 'white'
    property int aspCircleWidth: -1
    property int posMaxInt: 0
    property int posMaxExt: 0

    //Houses
    property int wl: app.fs*0.085*r.zoom//!app.appRotated?app.fs*0.1:2//app.fs*0.02
    property color cl: 'white'

    //Aspectos
    property bool showAsps: apps.showAsps

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

    MouseArea {
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        onDoubleClicked: r.resetView()
        /*Rectangle{
            color: 'red'
            anchors.fill: parent
        }*/
    }

    Timer {
        running: r.zoomingOrPaning
        repeat: false
        interval: 2500
        onTriggered: r.zoomingOrPaning=false
    }

    Flickable {
        id: flick
        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        interactive: true

        // Márgenes para centrar automáticamente cuando el contenido es más pequeño que el viewport
        leftMargin: Math.max(0, (width - contentWidth) / 2)
        topMargin: Math.max(0, (height - contentHeight) / 2)
        rightMargin: leftMargin
        bottomMargin: topMargin

        contentWidth: container.width
        contentHeight: container.height
        //boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar { active: true; policy: ScrollBar.AsNeeded }
        ScrollBar.horizontal: ScrollBar { active: true; policy: ScrollBar.AsNeeded }

        // ===== ZOOM CENTRADO EN EL PUNTERO DEL MOUSE =====
        MouseArea {
            anchors.fill: parent
            z: -1
            acceptedButtons: Qt.LeftButton
            propagateComposedEvents: true

            onWheel: {
                r.zoomingOrPaning = true

                var scaleStep = 0.12          // puedes ajustar la sensibilidad
                var oldZoom = container.zoom
                var factor = wheel.angleDelta.y > 0 ? (1.0 + scaleStep) : (1.0 - scaleStep)
                var newZoom = Math.max(0.4, Math.min(12.0, oldZoom * factor))

                if (Math.abs(newZoom - oldZoom) < 0.001)
                    return

                // Punto del mouse relativo al Flickable (centro del zoom)
                var mousePos = Qt.point(wheel.x, wheel.y)

                // Nuevo tamaño del contenido
                var newW = r.width * newZoom
                var newH = r.height * newZoom

                // ¡Esto es lo que mantiene el punto bajo el mouse fijo!
                flick.resizeContent(newW, newH, mousePos)

                // Actualizamos el factor de zoom
                container.zoom = newZoom

                // Volvemos a los bounds (importante)
                //flick.returnToBounds()
            }
        }

        // Doble clic para resetear
        MouseArea {
            anchors.fill: parent
            z: 0
            acceptedButtons: Qt.LeftButton
            propagateComposedEvents: true
            onDoubleClicked: r.resetView()
            onPressed: mouse.accepted = false
        }

        // Contenedor del mapa (tamaño real = base × zoom)
        Item {
            id: container
            property real zoom: 0.75          // factor de zoom actual

            width: r.width * zoom
            height: r.height * zoom

            // El Zm se escala proporcionalmente al contenedor
            Zm {
                id: zm
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: parent.height * 0.6
                wrz: r.wrz*container.zoom
            }
        }
    }    Rectangle {
        id: xTxtBodieSelected
        width: txtBodieSelected.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.left: parent.left
        anchors.leftMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        anchors.top: parent.top
        //anchors.topMargin: 0+(timeline.y*0.5)
        visible: r.currentIndexBodie>-1 && r.currentIndexSign>-1 && r.currentIndexHouse>-1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                r.currentIndexBodie=-1
                r.currentIndexSign=-1
                r.currentIndexHouse=-1
            }
        }
        Rectangle {
            anchors.fill: parent
            color: apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text {
            id: txtBodieSelected
            text: '<b>'+r.aBodies[r.currentIndexBodie]+' en '+app.aSigns[r.currentIndexSign]+'</b><br><b>'+r.currentStrDdMmSs+' Casa '+parseInt(r.currentIndexHouse+1)+'</b>'
            font.pixelSize: app.fs*0.5//app.appRotated?app.fs*0.5:app.fs
            color: apps.fontColor
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: xTxtBodieSelectedExt
        width: txtBodieSelectedExt.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.right: parent.right
        anchors.rightMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        anchors.top: parent.top
        //anchors.topMargin: 0+(timeline.y*0.5)
        visible: r.currentIndexBodieExt>-1 && r.currentIndexSignExt>-1 && r.currentIndexHouseExt>-1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                r.currentIndexBodieExt=-1
                r.currentIndexSignExt=-1
                r.currentIndexHouseExt=-1
            }
        }
        Rectangle {
            anchors.fill: parent
            color: 'red'
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.25
            opacity: 0.75
        }
        Text {
            id: txtBodieSelectedExt
            text: '<b>'+r.aBodies[r.currentIndexBodieExt]+' en '+app.aSigns[r.currentIndexSignExt]+'</b><br><b>'+r.currentStrDdMmSsExt+' Casa '+parseInt(r.currentIndexHouseExt+1)+'</b>'
            font.pixelSize: app.fs*0.5//app.appRotated?app.fs*0.5:app.fs
            color: 'white'
            anchors.centerIn: parent
        }
    }

    Item {
        id: xColToolsTop
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Column {
            id: xToolsTop
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Column {
        id: colTools
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*0.25
        anchors.left: parent.left
        anchors.leftMargin: app.fs*0.25
        visible: false
        Timer {
            running: parent.visible
            interval: 5000
            onTriggered: parent.visible=false
        }        
        ZmButton {
            text: 'A'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: !apps.showAsps?0.5:1.0
            onClicked: {
                apps.showAsps=!apps.showAsps
            }
        }
        ZmButton {
            text: 'G'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: apps.showGlifos?1.0:0.5
            onClicked: {
                apps.showGlifos=!apps.showGlifos
                //zoolMap.showGlifo=!zoolMap.showGlifo
            }
        }
        ZmButton {
            text: '\uf03a'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            visible: app.uFilePathLoaded!==''
            onClicked: {
                xZEV.visible=!xZEV.visible
            }
        }
        /*ZmButton {
            text: '\uf017'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: zmt.visible?1.0:0.5
            onClicked: {
                zmt.visible=!zmt.visible
            }
        }*/
    }

    function resetView() {
        container.zoom = 0.75
        // resizeContent con el centro de la vista para que quede centrado
        flick.resizeContent(r.width * 0.75, r.height * 0.75,
                            Qt.point(flick.width / 2, flick.height / 2))
        flick.returnToBounds()
    }



}
