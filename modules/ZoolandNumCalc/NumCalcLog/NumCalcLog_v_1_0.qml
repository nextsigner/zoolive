import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle{
    id: r
    width: parent.width
    height: parent.height
    color: apps.backgroundColor
    visible: false
    border.width: 2
    border.color: apps.fontColor
    clip: true
    property alias flk: flLog
    property alias text: taLog.text
    property bool ww: true
    property int numPanelLogFs: app.fs
    Flickable{
        id: flLog
        width: parent.width-app.fs*2
        height: parent.height
        contentWidth: parent.width
        contentHeight: taLog.contentHeight
        anchors.top: parent.top
        anchors.topMargin: app.fs
        TextEdit{
            id: taLog
            width: parent.width-app.fs*3//*0.5
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: r.numPanelLogFs
            color: apps.fontColor
        }
    }
    Column{
        spacing: app.fs*0.25
        anchors.right: parent.right
        anchors.rightMargin: spacing
        anchors.top: parent.top
        anchors.topMargin: spacing
        Repeater{
            //model: ['X', 'A+', 'A-', 'C']
            model: ['A+', 'A-', 'C']
            Rectangle{
                width: app.fs*1.5
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                color: apps.fontColor
                Text{
                    text: '<b>'+modelData+'</b>'
                    color: apps.backgroundColor
                    font.pixelSize: parent.width*0.5
                    anchors.centerIn: parent
                }
                MouseArea{anchors.fill: parent; onClicked: run(index)}
            }
        }
    }
    Component{
        id: compMsg
        Rectangle{
            id: xMsg
            width: txtMsg.contentWidth+app.fs*0.5
            height: txtMsg.contentHeight+app.fs*0.5
            color: apps.fontColor
            radius: app.fs*0.25
            anchors.centerIn: parent
            property string msg: '????'
            Behavior on opacity{NumberAnimation{duration: 2500}}
            Timer{
                id: tHideMsg
                running: true
                repeat: false
                interval: 5000
                onTriggered: xMsg.opacity=0.0
            }
            Text{
                id: txtMsg
                text: msg
                font.pixelSize: app.fs
                color: apps.backgroundColor
                anchors.centerIn: parent
            }
        }
    }
    Item{
        id: xMsgs
        width: r.width
        height: app.fs
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*2
    }
    function setText(d){
        taLog.text=''
        taLog.text+=d+'\n'
        flLog.contentY=0//taLog.contentHeight-r.height
    }
    function l(d){
        taLog.text+=d+'\n'
        flLog.contentY=taLog.contentHeight-r.height
    }
    function clear(){
        taLog.text=''
        //taLog.clear()
    }
    function cp(){
        taLog.selectAll()
        taLog.copy()
    }
    function scrollToTop(){
        flLog.contentY=0
    }
    function run(index){
        if(index===0){
            toRight()
            return
        }
        if(index===1){
            toLeft()
            return
        }
        if(index===2){
            //Código para copiar
            clipboard.setText(taLog.text)
            showMsg('Se ha copiado el texto en el portapapeles.')
            return
        }
    }
    function showMsg(text){
        for(var i=0;i<xMsgs.children.length;i++){
            xMsgs.children[i].destroy(0)
        }
        let comp=compMsg.createObject(xMsgs, {msg: text})
    }



    //-->Teclado
    function toEnter(ctrl){}
    function toTab(ctrl){}
    function toUp(ctrl){
        let y=0
        if(!ctrl){
            y=flk.contentY-app.fs
            if(y>0){
                flk.contentY=y
            }else{
                flk.contentY=0
            }
        }else{
            y=flk.contentY-app.fs*0.25
            if(y>0){
                flk.contentY=y
            }else{
                flk.contentY=0
            }
        }
    }
    function toDown(ctrl){
        let y=taLog.contentHeight+app.fs*3
        if(!ctrl){
            y=flk.contentY+app.fs
            if(y<flk.contentHeight-flk.height*0.5){
                flk.contentY=y
            }else{
                flk.contentY=flk.contentHeight-flk.height*0.5
            }
        }else{
            y=flk.contentY+app.fs*0.25
            if(y<flk.contentHeight-flk.height*0.5){
                flk.contentY=y
            }else{
                flk.contentY=flk.contentHeight-flk.height*0.5
            }
        }
    }
    function toLeft(ctrl){
        if(r.numPanelLogFs>app.fs*0.5){
            r.numPanelLogFs-=1
        }else{
            r.numPanelLogFs=app.fs*0.5
        }
    }
    function toRight(ctrl){
        if(r.numPanelLogFs<app.fs*2){
            r.numPanelLogFs+=1
        }else{
            r.numPanelLogFs=app.fs*2
        }
    }
    function toEscape(ctrl){
        r.visible=false
    }
    function isFocus(){return false}
    //<--Teclado
}
