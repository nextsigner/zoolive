import QtQuick 2.0

Rectangle {
    id: r
    width: !zoolMap.colTools.visible?parent.width:parent.width-app.fs*2
    height: app.fs*2//txtLabel.contentHeight*2//+10
    color: "transparent"
    anchors.right: parent.right

    property real zoom: 1.0
    property bool isExt: false


    // --- Propiedades de Control de Fecha ---
    property date targetDate: new Date()
    property int mode: 0 // 0:Año, 1:Mes, 2:Día, 3:Hora, 4:Min
    property int gmt: 0
    readonly property var modeLabels: ["AÑO", "MES", "DÍA", "HORA", "MIN"]

    // Sensibilidad: define cuánto desplazamiento se necesita para cambiar 1 unidad.
    // Modo 0 (Año): 5% del límite. Resto (1,2,3,4): 1% del límite.
    readonly property real sensitivity: mode === 0 ? 0.05 : 0.01

    readonly property int limit: width * 0.4
    property int lastStep: 0 // Para trackear el cambio relativo

    property bool modoSlider: false
    property bool onlySetDate: false
    property int cA: 0
    property int cM: 0
    property int cD: 0
    property int cH: 0
    property int cMin: 0

    onVisibleChanged: {
        if(visible)r.modoSlider=!r.modoSlider
    }
    onIsExtChanged: {
        let p
        let d
        if(!isExt){
            p=app.currentJson.params
        }else{
            p=app.currentJsonExt.params
        }
        d=new Date(p.a, p.m-1, p.d, p.h, p.min)
        r.onlySetDate=true
        r.targetDate=d
        r.onlySetDate=true
        r.gmt=p.gmt
    }
    onGmtChanged: {
        if(r.onlySetDate)return
        let num=-1
        r.mode=num
        updateDate(1)
    }
    onTargetDateChanged: {
        cA=targetDate.getFullYear()
        cM=targetDate.getMonth()+1
        cD=targetDate.getDate()
        cH=targetDate.getHours()
        cMin=targetDate.getMinutes()
        for(var i=0;i<6;i++){
            let num=i
            if(i===4||i===5)num=i+1
            let d=-1
            if(i===0)d=cA
            if(i===1)d=cM
            if(i===2)d=cD
            if(i===3)d=-1
            if(i===4)d=cH
            if(i===5)d=cMin
            let s=''
            if(i>0){
                if(d<10){
                    s='0'+d
                }else{
                    s=''+d
                }
            }else{
                s=''+cA
            }
            s='<b>'+s+'</b>'
            if(rowDatos.children[i]&&rowDatos.children[i].children[1])rowDatos.children[i].children[1].text=s
        }
    }

    Row{
        id: row
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: app.fs*0.1
        visible: !r.modoSlider
        Rectangle{
            width: !app.appRotated?app.fs:app.fs*0.5
            height: !app.appRotated?app.fs+app.fs*0.2:app.fs*0.5+app.fs*0.1
            color: apps.fontColor
            visible: zoolMap.zm.ev
            MouseArea{
                anchors.fill: parent
                onClicked: r.isExt=!r.isExt
            }
            Text{
                text: !r.isExt?'<b>I</b>':'<b>E</b>'
                font.pixelSize: parent.width*0.8
                color: apps.backgroundColor
                anchors.centerIn: parent
            }
        }
        Row{
            id: rowDatos
            Repeater{
                model: 6
                Rectangle{
                    width: !app.appRotated?(txtDato.text==='<b>0-1</b>'?app.fs*0.25:txtDato.contentWidth+app.fs*0.5):(txtDato.text==='-1'?app.fs*0.075:txtDato.contentWidth+app.fs*0.25)
                    height: !app.appRotated?app.fs+app.fs*0.2:app.fs*0.5+app.fs*0.1
                    color: index===3?'transparent':apps.backgroundColor
                    border.width: 1
                    border.color: apps.fontColor
                    opacity: txtDato.text==='<b>0-1</b>'?0.0:1.0
                    MouseArea{
                        anchors.fill: parent
                        onWheel: (wheel) => {
                                     let num=index
                                     if(index===4||index===5)num--
                                     r.mode=num
                                     updateDate(wheel.angleDelta.y>0?1:-1)
                                 }
                    }
                    Text{
                        id: txtDato
                        text: '?'
                        //font.pixelSize: '<b>'+!app.appRotated?app.fs*0.8:app.fs*0.4+'</b>'
                        font.pixelSize: !app.appRotated?app.fs*0.8:app.fs*0.4
                        color: apps.fontColor
                        anchors.centerIn: parent
                    }
                }
            }
        }
        Item{
            width: !app.appRotated?app.fs*0.25:app.fs*0.125
            height: 1//!app.appRotated?app.fs+app.fs*0.2:app.fs*0.5+app.fs*0.1
        }
        Rectangle{
            width: !app.appRotated?app.fs*1.75:app.fs
            height: !app.appRotated?app.fs+app.fs*0.2:app.fs*0.5+app.fs*0.1
            color: apps.backgroundColor
            border.width: 1
            border.color: apps.fontColor
            MouseArea{
                anchors.fill: parent
                onWheel: (wheel) => {
                             if(wheel.angleDelta.y>0){
                                 if(r.gmt<12){
                                     r.gmt++
                                  }
                             }else{
                                 if(r.gmt>-12){
                                     r.gmt--
                                  }
                             }
                             //let d= new Date(r.targetDate.getTime())
                             //d.setMilliseconds(d.getMilliseconds()+1)
                             //r.targetDate=d
                             let num=-1
                             r.mode=num
                             updateDate(1)
                         }
            }
            Text{
                id: txtDatoGmt
                text: '<b>'+r.gmt+'</b>'
                font.pixelSize: !app.appRotated?app.fs*0.8:app.fs*0.4
                color: apps.fontColor
                anchors.centerIn: parent
            }
        }
    }
    // Riel de guía
    Rectangle {
        width: parent.width * 0.9
        height: 2
        color: apps.fontColor
        opacity: 0.3
        anchors.centerIn: parent
        visible: r.modoSlider
        MouseArea{
            width: parent.width
            height: r.height
            anchors.centerIn: parent
            onWheel: {
                updateDate(wheel.angleDelta.y>0?1:-1)
            }
        }
    }

    Rectangle {
        id: handle
        width: parent.height * 0.7
        height: width
        //color: dragHandler.active ? "red" : "white"
        radius: app.fs*0.5//width * 0.1
        anchors.verticalCenter: parent.verticalCenter
        visible: r.modoSlider
        property real centerX: (r.width / 2) - (width / 2)
        x: centerX

        Text {
            id: txtLabel
            text: r.modeLabels[r.mode] + ": " + r.formatDisplay()
            color: apps.fontColor
            font.pixelSize: 12
            anchors.centerIn: parent
            //z: 2
            Rectangle{
                width: parent.contentWidth + 10 // app.fs*0.1
                height: parent.contentHeight + 5
                color: apps.backgroundColor
                radius: 3
                border.width: 1
                border.color: apps.fontColor
                anchors.centerIn: parent
                z: parent.z-1
            }
        }






    }

    function updateDate(delta) {
        let d = new Date(r.targetDate)

        if (r.mode === 0) d.setFullYear(d.getFullYear() + delta)
        else if (r.mode === 1) d.setMonth(d.getMonth() + delta)
        else if (r.mode === 2) d.setDate(d.getDate() + delta)
        else if (r.mode === 3) d.setHours(d.getHours() + delta)
        else if (r.mode === 4) d.setMinutes(d.getMinutes() + delta)
        else if (r.mode === -1) d.setMilliseconds(d.getMilliseconds() + delta)

        r.targetDate = d
        zoolMap.colTools.visible=false
    }

    function formatDisplay() {
        let d = r.targetDate
        if (r.mode === 0) return d.getFullYear()
        if (r.mode === 1) return (d.getMonth() + 1)
        if (r.mode === 2) return d.getDate()
        if (r.mode === 3) return d.getHours().toString().padStart(2, '0') + "hs"
        if (r.mode === 4) return d.getMinutes().toString().padStart(2, '0') + "m"
        return ""
    }
}
