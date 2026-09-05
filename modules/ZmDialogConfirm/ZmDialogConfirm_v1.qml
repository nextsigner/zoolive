import QtQuick 2.0
import ZmButton 1.0

Rectangle{
    id: r
    color: 'transparent'//apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    property string tit: 'Título'
    property string cons: 'Sin consulta!'
    property var obj
    property string txtBotYes: 'Sí'
    property string txtBotNot: 'No'
    anchors.fill: parent
    Rectangle{
        anchors.fill: parent
        color: apps.backgroundColor
        opacity: 0.75
    }
    Rectangle{
        id: xDialog
        width: r.width-app.fs
        height: col.height//+app.fs
        color: apps.backgroundColor
        border.width: 1
        border.color: apps.fontColor
        anchors.centerIn: parent
        Column{
            id: col
            spacing: app.fs*0.5
            anchors.centerIn: parent
            Rectangle{
                width: xDialog.width
                height: app.fs*1.5
                color: apps.backgroundColor
                border.width: 2
                border.color: apps.fontColor
                Text{
                    text: r.tit
                    font.pixelSize: app.fs//*0.5
                    color: apps.fontColor
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: xDialog.width-app.fs*2
                height: txtCons.contentHeight+app.fs
                color: apps.backgroundColor
                border.width: 0
                border.color: apps.fontColor
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    id: txtCons
                    text: r.cons
                    font.pixelSize: app.fs*0.75
                    width: parent.width-app.fs*0.5
                    wrapMode: Text.WordWrap
                    color: apps.fontColor
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: xDialog.width-app.fs
                height: app.fs*1.2
                color: 'transparent'
                Row{
                    spacing: app.fs
                    anchors.centerIn: parent
                    ZmButton{
                        text: r.txtBotNot
                        onClicked:{
                            r.destroy()
                        }
                    }
                    ZmButton{
                        text: r.txtBotYes
                        onClicked:{
                            r.obj.run(obj.args)
                            r.destroy()
                        }
                    }
                }
            }
            Item{width: 1; height: parent.spacing}
        }
    }
}