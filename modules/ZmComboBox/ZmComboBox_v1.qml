import QtQuick 2.0
import QtQuick.Controls 2.0

ComboBox {
    id: r
    height: app.fs * 2
    currentIndex: 0
    background: Rectangle {
        color: "transparent"
        border.width: 0
    }

    // 1. Texto del campo principal (Cerrado)
    contentItem: Rectangle {
        color: apps.backgroundColor
        border.width: 1
        border.color: apps.fontColor
        clip: true

        Text {
            anchors.centerIn: parent
            // Optimizamos el formateo de texto directamente en la propiedad
            text: {
                let partes = r.displayText.split('/')
                let nombre = partes[partes.length - 1]
                return nombre.replace(/_/g, ' ').replace('.json', '')
            }
            font.pixelSize: app.fs
            color: apps.fontColor
            verticalAlignment: Text.AlignVCenter
        }
    }

    // 2. Elementos de la lista desplegable
    delegate: ItemDelegate {
        id: del
        width: r.width
        height: r.height

        contentItem: Text {
            // Formateo directo para evitar el uso de Component.onCompleted (más eficiente)
            text: {
                let m0 = modelData.split('/')
                return m0[m0.length - 1].replace(/_/g, ' ').replace('.json', '')
            }
            color: apps.fontColor
            font.pixelSize: app.fs
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            // Usamos 'del.highlighted' para referirnos al estado del delegate actual
            color: del.highlighted ? "#333333" : apps.backgroundColor
        }

        highlighted: r.highlightedIndex === index
    }

}
