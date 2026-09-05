import QtQuick
import QtQuick.Controls
import ZoolandMap.Zm 1.0
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
        contentWidth: container.width * container.scale
        contentHeight: container.height * container.scale
        boundsBehavior: Flickable.StopAtBounds

        // Si el error persiste, podemos comentar estas dos líneas
        // para probar si el resto del zoom funciona.
        ScrollBar.vertical: ScrollBar { active: true }
        ScrollBar.horizontal: ScrollBar { active: true }

        Rectangle {
            id: container
            width: r.width
            height: r.height
            color: "transparent"
            transformOrigin: Item.Center

            // --- TU CONTENIDO ---
            /*Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.7
                height: width
                color: "black"
                border.width: 1
                border.color: 'red'
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: "Zooland Map\nQt 6.11.0"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }*/
            Zm{
                id: zm
                width: parent.width*0.8
                height: parent.height*0.8
                x: parent.width*0.1
                y: parent.height*0.1
                wrz: r.wrz
            }
        }

        PinchHandler {
            id: pinchHandler
            target: container
            minimumScale: 0.5
            maximumScale: 8.0
            minimumRotation: 0
            maximumRotation: 0
        }

        WheelHandler {
            id: wheelHandler
            target: container
            acceptedModifiers: Qt.ControlModifier
            onWheel: (event)=> {
                         let scaleStep = 0.1
                         let delta = event.angleDelta.y > 0 ? (1 + scaleStep) : (1 - scaleStep);
                         let newScale = container.scale * delta;
                         if (newScale >= 0.5 && newScale <= 8.0) {
                             container.scale = newScale;
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

}