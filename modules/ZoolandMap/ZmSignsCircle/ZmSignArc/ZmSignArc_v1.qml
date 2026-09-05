import QtQuick 2.0
import QtQuick.Shapes 1.12

Rectangle {
    id: r
    width: 600
    height: 600
    color: 'transparent'
    property int wbrz: wrz*0.15
    property color c: aSignsColors[is]
    property int wrz: 0
    property int is: 0
    property var aSignsColors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    rotation: 0-(30*is+15+90)
    Shape {
        id: arco
        anchors.centerIn: parent

        // El tamaño del Shape debe contener el radio + la mitad del grosor del borde
        width: parent.width
        height: parent.height

        ShapePath {
            strokeColor: r.c
            strokeWidth: r.wrz              // Tu borde de 20px
            fillColor: "transparent"
            //capStyle: ShapePath.RoundCap // Bordes redondeados para estética
            capStyle: ShapePath.FlatCap

            // El Path inicia en el borde del círculo
            // Calculamos el punto de inicio para un arco de 30 grados
            // Si queremos que esté centrado arriba:
            startX: r.width*0.5 + r.width*0.5 * Math.sin(-15 * Math.PI / 180)
            startY: r.width*0.5 - r.width*0.5 * Math.cos(-15 * Math.PI / 180)

            PathArc {
                x: r.width*0.5 + r.width*0.5 * Math.sin(15 * Math.PI / 180)
                y: r.width*0.5 - r.width*0.5 * Math.cos(15 * Math.PI / 180)
                radiusX: r.width*0.5
                radiusY: r.width*0.5
                useLargeArc: false // Solo son 30 grados, así que es el arco corto
            }
        }
    }
    Rectangle{
        width: 1
        height: r.width+r.wrz
        color: 'transparent'
        anchors.centerIn: parent
        //rotation: 15
        z: arco.z+1
        Rectangle{
            width: r.wrz
            height: width
            color: 'transparent'
            radius: width*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            z: parent.z+1
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(zoolMap.currentIndexSign!==r.is){
                        zoolMap.currentIndexSign=r.is
                    }else{
                        zoolMap.currentIndexSign=-1
                    }
                }
            }
            Image{
                width: parent.width*0.75
                height: width
                source: Qt.platform.os==='android'?'assets:/imgs/signos/'+r.is+'.svg':'file:///home/ns/nsp/zoolandv2/android/assets/imgs/signos/'+r.is+'.svg'
                rotation: 360-r.rotation-zoolMap.signCircleRot
                anchors.centerIn: parent
            }
        }
    }
}
