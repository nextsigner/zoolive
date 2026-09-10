import QtQuick 2.0
import ZmButton 1.0
import ZmComboBox 1.0

Rectangle{
    id: r
    width: parent.width-app.fs
    height: width
    color: apps.backgroundColor
    border.width: 2
    border.color: apps.fontColor
    y: app.fs*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    property alias cbArchivos: cbArchivos
    ZmButton{
        text:'\uf00d'
        fs: app.fs*0.5
        isCuad: true
        onClicked: parent.visible=false
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.1
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.1
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent

        Text{
            text: 'Configurar'
            color: 'white'
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
