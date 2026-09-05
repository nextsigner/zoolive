import QtQuick 2.0
import QtQuick.Shapes 1.2

Rectangle {
    id: r
    width: 600
    height: 600
    color: 'transparent'
    property int wbrz: wrz*0.15
    property color c: 'red'
    property int wrz: 0
    property int is: -1
    rotation: 0-(30*is+15+90)
    Shape {
        id: arco
        anchors.centerIn: parent

        // El tamaño del Shape debe contener el radio + la mitad del grosor del borde
        width: parent.width
        height: parent.height
        visible: zoolMap.currentIndexSign===r.is || zoolMap.currentIndexSignExt===r.is

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
            SequentialAnimation on strokeColor{
                running: arco.visible
                loops: Animation.Infinite

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
            PathArc {
                x: r.width*0.5 + r.width*0.5 * Math.sin(15 * Math.PI / 180)
                y: r.width*0.5 - r.width*0.5 * Math.cos(15 * Math.PI / 180)
                radiusX: r.width*0.5
                radiusY: r.width*0.5
                useLargeArc: false // Solo son 30 grados, así que es el arco corto
            }
        }
    }
}
