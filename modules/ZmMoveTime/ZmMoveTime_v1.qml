import QtQuick 2.0

Rectangle {
    id: r
    width: !zoolMap.colTools.visible?parent.width:parent.width-app.fs*2
    height: app.fs*2//txtLabel.contentHeight*2//+10
    color: "transparent"
    anchors.right: parent.right

    property real zoom: 1.0


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
    onGmtChanged: {
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
        Row{
            id: rowDatos
            Repeater{
                model: 6
                Rectangle{
                    width: !app.appRotated?(txtDato.text==='<b>0-1</b>'?app.fs*0.25:txtDato.contentWidth+app.fs*0.5):(txtDato.text==='-1'?app.fs*0.125:txtDato.contentWidth+app.fs*0.25)
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
            width: app.fs*2//!app.appRotated?(txtDatoGmt.text==='0-1'?app.fs*0.25:txtDatoGmt.contentWidth+app.fs*0.5):(txtDatoGmt.text==='-1'?app.fs*0.125:txtDatoGmt.contentWidth+app.fs*0.25)
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
                font.pixelSize: '<b>'+!app.appRotated?app.fs*0.8:app.fs*0.4+'</b>'
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

        /*TapHandler {
            onTapped: {
                r.mode = (r.mode + 1) % 5
            }
        }*/

        Behavior on x {
            //enabled: !dragHandler.active
            NumberAnimation { duration: 250; easing.type: Easing.OutBack }
        }

        /*DragHandler {
            id: dragHandler
            target: handle
            xAxis.minimum: handle.centerX - r.limit
            xAxis.maximum: handle.centerX + r.limit
            yAxis.enabled: false

            onActiveChanged: {
                if (!active) {
                    r.lastStep = 0
                    handle.x = handle.centerX
                }
            }

            onTranslationChanged: {
                if (active) {
                    let relativeX = handle.x - handle.centerX

                    // Calculamos el step basado en la sensibilidad dinámica
                    // Pixeles por paso = limit * sensibilidad (ej: 100px * 0.05 = cada 5px cambia 1 año)
                    let pixelsPerStep = r.limit * r.sensitivity
                    let currentStep = Math.trunc(relativeX / pixelsPerStep)

                    if (currentStep !== r.lastStep) {
                        let diff = currentStep - r.lastStep
                        updateDate(diff)
                        r.lastStep = currentStep
                    }
                }
            }
        }*/
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
