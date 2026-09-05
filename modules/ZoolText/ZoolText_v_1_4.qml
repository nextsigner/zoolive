import QtQuick 2.12 // Actualizado a versiones más recientes si usas Qt 5.15+
import QtQuick.Controls 2.12

Item {
    id: r

    // 1. Definimos dimensiones claras
    // Usamos implicitWidth/Height para que el componente sepa su tamaño natural
    implicitWidth: xText.width
    implicitHeight: xText.height

    // Propiedades
    property string text: '???'
    property int fs: typeof app !== 'undefined' ? app.fs : 16
    property color c: typeof apps !== 'undefined' ? apps.fontColor : "black"

    // Background y Estilo
    property color bgc: 'transparent'
    property real bgo: 1.0
    property int padding: 0
    property int bw: 0
    property color bc: c
    property real br: 0.0

    // Aliases
    property alias t: txt
    property alias font: txt.font
    property alias wrapMode: txt.wrapMode
    property alias tf: txt.textFormat
    property alias horizontalAlignment: txt.horizontalAlignment
    property alias verticalAlignment: txt.verticalAlignment

    // Solución al Binding Loop:
    // Si queremos que el ancho sea automático, el texto no debería tener un ancho fijo basado en el padre
    // a menos que definamos un ancho máximo.
    property int w: txt.implicitWidth + (padding * 2) + (bw * 2)

    Rectangle {
        id: xText
        width: r.w
        height: txt.implicitHeight + (r.padding * 2) + (r.bw * 2)
        color: r.bgc
        border.width: r.bw
        border.color: r.bc
        radius: r.br
        opacity: r.bgo
        anchors.centerIn: parent
    }

    Text {
        id: txt
        text: r.text
        font.pixelSize: r.fs
        color: r.c
        // Si quieres WordWrap, necesitas definir un ancho máximo afuera,
        // de lo contrario usa Text.NoWrap para que crezca horizontalmente.
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
    }
}
