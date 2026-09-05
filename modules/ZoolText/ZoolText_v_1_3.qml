import QtQuick 2.0
import QtQuick.Controls 2.0

Item{
    id: r
    width: xText.width
    height: txt.contentHeight+r.padding
    property int w : txt.contentWidth//100//r.parent.width
    property string text: '???'
    property alias t: txt
    property alias rx: xText
    property alias font: txt.font
    property color c: apps.fontColor
    property alias contentWidth: txt.contentWidth
    property alias contentHeight: txt.contentHeight
    property alias wrapMode: txt.wrapMode
    property int fs: app.fs
    property color bgc: 'transparent'
    property real bgo: 1.0
    property int padding:  0
    property int bw: 0
    property color bc: apps.fontColor
    property real br: 0.0
    property alias tf: txt.textFormat
    property alias horizontalAlignment: txt.horizontalAlignment
    property alias verticalAlignment: txt.verticalAlignment
    Rectangle{
        id: xText
        width: r.w
        height: txt.contentHeight+r.padding*2+r.bw*2
        color: r.bgc
        border.width: r.bw
        border.color: r.bc
        radius: r.br
        opacity: r.bgo
        anchors.centerIn: r
    }
    Text{
        id: txt
        text: r.text
        width: xText.width-r.padding*2
        font.pixelSize: r.fs
        color: r.c
        wrapMode: Text.WordWrap
        anchors.centerIn: parent
    }

}
