import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: r
    width: txt.contentWidth+app.fs*0.5
    height: !isCuad?r.fs+app.fs*0.5:width
    color: apps.fontColor
    radius: height*0.25
    property alias text: txt.text
    property alias fs: txt.font.pixelSize
    property bool isCuad: false
    signal clicked()
    MouseArea{
        anchors.fill: parent
        onClicked: r.clicked()
    }
    Text{
        id: txt
        text: '?'
        color: apps.backgroundColor
        font.family: fontAwosome.name
        anchors.centerIn: parent
    }
}