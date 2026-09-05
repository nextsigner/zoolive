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
    property int wl: !app.appRotated?app.fs*0.1:2//app.fs*0.02
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
        onDoubleClicked: r.resetView()
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
        contentWidth: container.width * container.scale
        contentHeight: container.height * container.scale
        boundsBehavior: Flickable.StopAtBounds

        // En Qt 5 lo hacemos interactivo para permitir arrastrar (Pan) con el mouse de la PC
        interactive: true

        ScrollBar.vertical: ScrollBar { active: true }
        ScrollBar.horizontal: ScrollBar { active: true }

        // Detectar doble click para resetear la vista desde el fondo del Flickable
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onDoubleClicked: r.resetView()
            onPressed: mouse.accepted = false
        }

        // Control de Zoom mediante la rueda del mouse (Reemplazo de WheelHandler en Qt 5)
        MouseArea {
            anchors.fill: parent
            z: -1 // Se mantiene detrás para no interferir con clicks en elementos del mapa

            onWheel: {
                r.zoomingOrPaning = true

                let scaleStep = 0.1
                let delta = wheel.angleDelta.y > 0 ? (1 + scaleStep) : (1 - scaleStep);
                let newScale = container.scale * delta;

                if (newScale >= 0.5 && newScale <= 12.0) {
                    // Guardamos la posición actual del puntero respecto al Flickable
                    let mouseXInContainer = wheel.x + flick.contentX;
                    let mouseYInContainer = wheel.y + flick.contentY;

                    container.scale = newScale;

                    // Ajusta el scroll dinámicamente para que el zoom haga foco donde está el puntero del mouse
                    flick.contentX = mouseXInContainer * delta - wheel.x;
                    flick.contentY = mouseYInContainer * delta - wheel.y;
                }
            }
        }

        Rectangle {
            id: container
            width: r.width
            height: r.height
            color: "transparent"
            x: (parent.width-width)*0.5
            y: (parent.height-height)*0.5
            transformOrigin: Item.Center

            Zm {
                id: zm
                width: parent.width * 0.6
                height: parent.height * 0.6
                x: parent.width * 0.2
                y: parent.height * 0.2
                wrz: r.wrz
            }
        }
    }

    Rectangle {
        id: xTxtBodieSelected
        width: txtBodieSelected.contentWidth+app.fs*0.25
        height: txtBodieSelected.contentHeight+app.fs*0.25
        color: 'transparent'
        anchors.left: parent.left
        anchors.leftMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        anchors.top: parent.top
        anchors.topMargin: 0+(timeline.y*0.5)
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
        anchors.topMargin: 0+(timeline.y*0.5)
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
        anchors.bottomMargin: app.fs*0.5
        anchors.left: parent.left
        anchors.leftMargin: !app.appRotated?0:0-((xApp.width-r.width)*0.5)
        visible: false
        Timer {
            running: parent.visible
            interval: 5000
            onTriggered: parent.visible=false
        }
        ZmButton {
            text: '\uf07d'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            onClicked: {
                if(zoolMap.parent===xApp){
                    zoolMap.parent=xZoolandMap
                }else{
                    zoolMap.parent=xApp
                }
            }
        }
        ZmButton {
            text: 'G'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: zoolMap.showGlifo?0.5:1.0
            onClicked: {
                zoolMap.showGlifo=!zoolMap.showGlifo
            }
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
            text: '\uf03a'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            visible: app.uFilePathLoaded!==''
            onClicked: {
                xZEV.visible=!xZEV.visible
            }
        }
        ZmButton {
            text: '\uf017'
            fs: !app.appRotated?app.fs*0.75:app.fs*0.35
            width:!app.appRotated?app.fs*1.5:app.fs*0.75
            isCuad: true
            opacity: zmt.visible?1.0:0.5
            onClicked: {
                zmt.visible=!zmt.visible
            }
        }
    }

    function resetView() {
        container.scale = !app.appRotated?0.75:0.5
        container.x = 0-(container.parent.width-container.width)*0.5
        container.y = 0-(container.parent.height-container.height)*0.5
        flick.contentX = 0
        flick.contentY = 0
    }
}
