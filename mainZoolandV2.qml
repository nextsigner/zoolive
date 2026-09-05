import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import swe 1.0
import unik.Unik 1.0
//import Qt.labs.settings
import QtCore

import ZoolandMap 3.0
import ZmMoveTime 1.0
import ZoolElementsView 1.0
import ZoolandNumCalc 1.0
import ZmButton 1.0
import ZmComboBox 1.0

ApplicationWindow {
    id: app
    width: Qt.platform.os==='android'?Screen.width:350
    height: Qt.platform.os==='android'?Screen.height:700
    x: 0
    visible: true
    visibility: Qt.platform.os==='android'?'FullScreen':'Windowed'
    title: 'ZoolAnd'
    color: 'black'
    //property alias app: r
    property bool appRotated: Qt.platform.os==='android'?Screen.width>Screen.height:false
    //property var zoolMap
    property bool dev: false
    property int fs: Qt.platform.os==='android'?Screen.width*0.05:app.width*0.05

    property string modo: 'inicio'
    property bool isSaved: false
    property string currentFilesFolder: ''
    property string uFilePathLoaded: ''
    property var currentJson
    property var currentJsonExt

    property var signColors: ['red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6','red', '#FBE103', '#09F4E2', '#0D9FD6']
    property var aSigns: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property var aSignsEnergy: ['Ariana', 'Taurina', 'Geminiana', 'Canceriana', 'Leonina', 'Virginiana', 'Libriana', 'Escorpiana', 'Sagitariana', 'Capricorniana', 'Acuariana', 'Pisciana']
    property var aSignsLowerStyle: ['aries', 'tauro', 'geminis', 'cancer', 'leo', 'virgo', 'libra', 'escorpio', 'sagitario', 'capricornio', 'acuario', 'piscis']
    property var aBodies: ['Sol', 'Luna', 'Mercurio', 'Venus', 'Marte', 'Júpiter', 'Saturno', 'Urano', 'Neptuno', 'Plutón', 'N.Sur', 'N.Norte', 'Quirón', 'Selena', 'Lilith', 'Pholus', 'Ceres', 'Pallas', 'Juno', 'Vesta']
    property var aBodiesFiles: ['sol', 'luna', 'mercurio', 'venus', 'marte', 'jupiter', 'saturno', 'urano', 'neptuno', 'pluton', 'nodo_sur', 'nodo_norte', 'quiron', 'selena', 'lilith', 'pholus', 'ceres', 'pallas', 'juno', 'vesta']
    property var objSignsNames: ['ari', 'tau', 'gem', 'cnc', 'leo', 'vir', 'lib', 'sco', 'sgr', 'cap', 'aqr', 'psc']
    property var  aIndexSweBodies: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 11, 15, 57, 12, 16, 17, 18, 19, 20]


    FontLoader {id: fontAwosome;source: Qt.platform.os==='android'?"assets:/fonts/fontawesome-webfont.ttf":"file:///home/ns/nsp/zoolandv2/android/assets/fonts/fontawesome-webfont.ttf";}
    Unik{id: u}
    Swe{id: swe}
    Settings{
        id: apps
        //fileName: './'+app.title+'.cfg'
        property color fontColor: 'white'
        property color backgroundColor: 'black'
        property bool showZoolandMap: false
        property bool showAllDegreeData: false

        property int aspLineWidth: 2

        //Aspectos
        property bool showAsps: true
    }
    onAppRotatedChanged: zoolMap.resetView()
    onModoChanged: {
        if(modo==='rs'){

        }
    }
    onCurrentJsonChanged: {
        if(zoolMap)zoolMap.zm.load(currentJson)
    }
    Timer{
        id: tCheck
        running: false
        repeat: true
        interval: 3000
        property int v: 0
        onTriggered: {
            if(app.uFilePathLoaded==='')return
            if(!u.fileExist(app.uFilePathLoaded)){
                isSaved=false
                return
            }
            let j=JSON.parse(u.getFile(app.uFilePathLoaded))

            let s=''
            if(JSON.stringify(j, null, 2)!==JSON.stringify(app.currentJson, null, 2)){
                s+='NO Modificado\n\n'
                app.isSaved=true
            }else{
                s+='Modificado\n\n'
                app.isSaved=false
            }
            s+=JSON.stringify(j, null, 2)
            //console.log("v:"+v+"\nJSON "+s)
            //txt.text=s
            v++
        }
    }
    Rectangle{
        id: xApp
        width: Qt.platform.os==='android'?Screen.width*0.9:app.width
        height: Qt.platform.os==='android'?parent.height:700
        color: 'transparent'
        border.width: 0
        border.color: 'blue'
        clip: true
        anchors.centerIn: parent
        Flickable{
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: col.height+app.fs*10//txt.contentHeight+app.fs*3
            Column{
                id: col
                spacing: app.fs*2
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !app.appRotated
                Rectangle{
                    id: xTop
                    width: xApp.width
                    height: col0.height+app.fs*0.5
                    color: 'transparent'
                    border.width: 0
                    border.color: 'white'
                    Column{
                        id: col0
                        spacing: app.fs//*0.25
                        anchors.centerIn: parent
                        Row{
                            spacing: app.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            //Inicio
                            ZmButton{
                                text: '\uf015'
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    app.modo='inicio'
                                    let s='Inicio!'
                                    txt.text=s
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                            ZmButton{
                                text: '\uf059'
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    let s=getAyuda()
                                    txt.text=s
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                            Text {
                                text: 'Modo: '+app.modo
                                font.pixelSize: app.fs*0.5
                                color: apps.fontColor
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                        Row{
                            spacing: app.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            //Cargar Tránsitos en INT
                            ZmButton{
                                text: '\uf0e7'
                                width: app.fs*2
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                //visible: app.uFilePathLoaded==='' || app.uFilePathLoaded.indexOf('Ahora ')===0
                                onClicked: {
                                    cbArchivos.currentIndex=0
                                    xSelectRs.visible=false
                                    let s=''
                                    let d=new Date(Date.now())
                                    let va=d.getFullYear()
                                    let vm=d.getMonth()+1
                                    let vd=d.getDate()
                                    let vh=d.getHours()
                                    let vmin=d.getMinutes()
                                    let jf=getSweJson('trans', va, vm, vd, vh, vmin, 0, 0.0, 0.0, 0, 'T')
                                    app.currentJson=jf
                                    app.modo='trans'
                                    app.uFilePathLoaded='Ahora '+vd+'/'+vm+'/'+va+' '+vh+':'+vmin
                                    s +=app.uFilePathLoaded+'\nTránsitos planetarios global/mundial.\n\n'
                                    s += getList(jf)
                                    txt.text = s
                                    zmt.onlySetDate=true
                                    zmt.targetDate=d
                                    //getList(j)

                                }
                            }
                            //Guardar
                            ZmButton{
                                text: '\uf0c7'
                                width: app.fs*2
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                opacity: app.isSaved?0.25:1.0
                                visible: app.uFilePathLoaded!==''
                                onClicked: {
                                    //txt.text='app.isSaved: '+app.isSaved+'\n'
                                    if(app.isSaved)return
                                    /*let fd=JSON.stringify(app.currentJson.params, null, 2)
                                    //txt.text='fd: '+fd+'\n'
                                    let s=''
                                    s+='Guardando:\n'
                                    s+=''+app.uFilePathLoaded+'\n'
                                    s+=fd
                                    txt.text=s*/
                                    //if(app.currentJson.params.t==='vn'){
                                    if(app.modo==='vn'){
                                        let j={}
                                        j.params=app.currentJson.params
                                        u.setFile(app.uFilePathLoaded, JSON.stringify(j, null, 2))
                                        app.isSaved=true
                                        return
                                    }
                                    form.loadForEditFromParams(app.currentJson.params)
                                    xSelectRs.visible=false
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                            //Crear nuevo
                            ZmButton{
                                text: '\uf016'
                                width: app.fs*2
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    xSelectRs.visible=false
                                    form.visible=true
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                            //Editar
                            ZmButton{
                                text: '\uf044'
                                width: app.fs*2
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                visible: app.uFilePathLoaded!==''
                                onClicked: {
                                    form.loadForEdit(app.uFilePathLoaded)
                                    xSelectRs.visible=false
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                            //Eliminar
                            ZmButton{
                                text: '\uf1f8'
                                width: app.fs*2
                                fs: app.fs*1.5
                                anchors.verticalCenter: parent.verticalCenter
                                visible: app.uFilePathLoaded!==''
                                onClicked: {
                                    let c='import ZmDialogConfirm 1.0\n'
                                    c+='ZmDialogConfirm{}\n'
                                    let obj=Qt.createQmlObject(c, xApp, 'zmDialogConfirm-code')
                                    obj.obj=objDeleteFile
                                    obj.tit='Confirmar Eliminación'
                                    obj.cons='Desea eliminar el archivo\n['+app.uFilePathLoaded+']?'
                                    obj.obj.args.push(app.uFilePathLoaded)
                                    xSelectRs.visible=false
                                    zoolMap.xToolsTop.parent.visible=false
                                }
                            }
                        }
                        Row{
                            spacing: app.fs*0.5
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text{
                                id: tit1
                                text: 'Archivo:'
                                color: 'white'
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            ZmComboBox {
                                id: cbArchivos
                                width: xApp.width - tit1.contentWidth - app.fs * 2
                                height: app.fs * 2
                                currentIndex: 0
                                onCurrentIndexChanged: {
                                    if (currentIndex < 0 || !model) return;

                                    let rutaCompleta = model[currentIndex]
                                    let nombreLimpio = rutaCompleta.split('/').pop().replace(/_/g, ' ').replace('.json', '')

                                    let fd=u.getFile(rutaCompleta)
                                    let p=JSON.parse(fd).params
                                    app.modo=p.t
                                    loadZmFromParams(p)
                                    app.uFilePathLoaded=rutaCompleta
                                    app.isSaved=true
                                    printData(app.currentJson)

                                }
                            }                        }
                    }
                }
                Row{
                    id: rowBtns
                    spacing: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    parent: zoolMap.parent===xZoolandMap?col:zoolMap.xToolsTop
                    //Calcular Numerología
                    ZmButton{
                        text: '\uf1ec'
                        width: app.fs*2
                        fs: app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            let fecha=''
                            if(app.uFilePathLoaded===''){
                                let d=new Date(Date.now())
                                fecha=''+d.getDate()+'.'+parseInt(d.getMonth()+1)+'.'+d.getFullYear()
                            }else{
                                let p=app.currentJson.params
                                fecha=p.d+'.'+p.m+'.'+p.a
                            }
                            znc.load(fecha)
                        }
                    }
                    //Ver Elementos
                    ZmButton{
                        text: '\uf03a'
                        width: app.fs*2
                        fs: app.fs*1.5
                        visible: app.uFilePathLoaded!==''
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            //zoolElementsView.visible=!zoolElementsView.visible
                            xZEV.visible=!xZEV.visible
                        }
                    }
                    //Cargar Tránsitos de ahora
                    ZmButton{
                        text: '\uf0e7'
                        width: app.fs*2
                        fs: app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                        visible: app.uFilePathLoaded!==''
                        onClicked: {
                            txtMoveTime.text=''
                            xSelectRs.visible=false
                            let s=''
                            let d=new Date(Date.now())
                            let va=d.getFullYear()
                            let vm=d.getMonth()+1
                            let vd=d.getDate()
                            let vh=d.getHours()
                            let vmin=d.getMinutes()
                            let jf=getSweJson('trans_ext', va, vm, vd, vh, vmin, 0, 0.0, 0.0, 0, 'T')
                            app.currentJsonExt=jf
                            app.modo='trans_ext'
                            zoolMap.zm.objBodiesCircleExt.load(jf)
                            zmt.onlySetDate=true
                            zmt.targetDate=d
                            //zoolElementsView.load(jf)
                            //app.uFilePathLoaded='Ahora '+vd+'/'+vm+'/'+va+' '+vh+':'+vmin
                            //s +=app.uFilePathLoaded+'\nTránsitos planetarios global/mundial.\n\n'
                            //s += getList(jf)
                            //txt.text = s
                        }
                    }
                    //Cargar Rev. Solar
                    ZmButton{
                        text: '\uf185'
                        width: app.fs*2
                        fs: app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                        visible: app.uFilePathLoaded!==''
                        onClicked: {
                            txtMoveTime.text=''
                            let fd = u.getFile(app.uFilePathLoaded)
                            try {
                                let j = JSON.parse(fd).params
                                let a=['Seleccionar']
                                for(var i=0;i<120;i++){
                                    a.push('Año: '+parseInt(j.a+i+1)+' Edad: '+parseInt(i+1)+' años')
                                }
                                cbAniosRS.model=a
                                xSelectRs.visible=true
                            } catch(e) {
                                console.log("Error parseando JSON: ", e)
                            }
                        }
                    }
                    //Descartar Exterior
                    ZmButton{
                        text: 'X'
                        width: app.fs*2
                        fs: app.fs*1.5
                        anchors.verticalCenter: parent.verticalCenter
                        visible: app.uFilePathLoaded!==''
                        onClicked: {
                            zoolMap.zm.ev=false
                        }
                    }
                }
                Row{
                    id: xSelectRs
                    spacing: app.fs*0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    parent: zoolMap.parent===xZoolandMap?col:zoolMap.xToolsTop
                    visible: false
                    z: rowBtns.z-1
                    Text{
                        id: tit2
                        text: 'Año de\nRev. Solar:'
                        color: 'white'
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ZmComboBox {
                        id: cbAniosRS
                        width: xApp.width - tit1.contentWidth - app.fs*2
                        height: app.fs * 2
                        currentIndex: 0
                        onCurrentIndexChanged: {
                            if (currentIndex <= 0 || !model) return;
                            xSelectRs.visible=false
                            zoolMap.xToolsTop.parent.visible=false
                            let j=app.currentJson
                            let a=j.params.a+currentIndex
                            let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, a, j.params.m, j.params.d, j.params.gmt);

                            let jsRS=getSweJson('rs', arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lat, j.params.lon, j.params.alt, j.params.hsys)
                            app.currentJsonExt=jsRS
                            zoolMap.zm.objBodiesCircleExt.load(jsRS)
                            zoolMap.zm.objHousesCircleExt.load(jsRS)
                            app.modo='rs'
                            let s=''
                            s+='Revolución Solar del año '+a+'\n\n'
                            s+='Fecha de Nacimiento:\n'
                            s+=getMom(app.currentJson)
                            s+='Fecha de Retorno Solar:\n'
                            s+=getMom(jsRS)
                            //s+='\n\nAtención! Si ahora presionas el botón "Enviar a IA", la consulta se hará sobre la Revolución Solar, no sobre la lectura de la Carta Natal.\n\n'
                            s+=getList(jsRS)
                            s+='\nCarta Natal\n'
                            s+=getList(app.currentJson)
                            txt.text=s
                            botEnviarIA.anioRs=a
                        }
                    }

                }
                Rectangle{
                    id: xZoolandMap
                    width: xApp.width
                    height: width
                    color: 'transparent'
                    border.width: 0
                    border.color: 'green'
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: app.uFilePathLoaded!==''
                    ZoolandMap{
                        id: zoolMap
                        width: !app.appRotated?parent.width:parent.width//app.height
                        height: !app.appRotated?parent.height:width//-app.fs
                        fs:Qt.platform.os==='android'?(!app.appRotated?app.fs:app.fs*0.5):app.fs
                        border.width: 0
                        border.color: 'blue'
                        parent: app.appRotated?xApp:xZoolandMap
                        anchors.centerIn: parent
                        //anchors.horizontalCenter: parent.horizontalCenter
                        //z: parent.z-1
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            color: apps.fontColor
                            opacity: 0.25
                            radius: width*0.2
                            //anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: !zoolMap.xToolsTop.parent.visible
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: zoolMap.xToolsTop.parent.visible=true
                            }
                        }
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            color: apps.fontColor
                            opacity: 0.25
                            radius: width*0.2
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: app.fs
                            visible: !zoolMap.colTools.visible
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: zoolMap.colTools.visible=true
                            }
                        }
                        ZmMoveTime{
                            id: zmt
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: app.fs*0.5
                            /*onGmtChanged:{
                                if(!app.currentJson)return
                                if(onlySetDate){
                                    onlySetDate=false
                                    return
                                }
                            }*/
                            onTargetDateChanged: {
                                if(!app.currentJson)return
                                if(onlySetDate){
                                    onlySetDate=false
                                    return
                                }
                                let p=app.currentJson.params
                                let vd=p.d
                                let vm=p.m
                                let va=p.a
                                let vh=p.h
                                let vmin=p.min
                                let vlat=p.lat
                                let vlon=p.lon
                                let valt=p.alt
                                let vgmt=p.gmt
                                /*let d = new Date(va, vm-1, vd, vh, vmin)
                                d.setDate(d.getDate()+currentValue)
                                let nvd=d.getDate()
                                let nvm=d.getMonth()+1
                                let nva=d.getFullYear()
                                let nvh=d.getHours()
                                let nvmin=d.getMinutes()*/
                                let nvd=targetDate.getDate()
                                let nvm=targetDate.getMonth()+1
                                let nva=targetDate.getFullYear()
                                let nvh=targetDate.getHours()
                                let nvmin=targetDate.getMinutes()
                                txtMoveTime.text=''+nvd+'/'+nvm+'/'+nva+' '+nvh+':'+nvmin+'hs'+' '+app.modo
                                tLoadMoveTime.setNewDate(targetDate)
                                tLoadMoveTime.d=targetDate
                                tLoadMoveTime.restart()
                            }
                            Timer{
                                id: tLoadMoveTime
                                running: false
                                repeat: false
                                interval: 1000
                                property var d
                                onTriggered:setNewDate(d)
                                function setNewDate(d){
                                    if(d===zmt.targetDate)return
                                    let s=''
                                    let p
                                    if(app.modo==='trans'){
                                        if(zoolMap.zm.ev){
                                            p=app.currentJsonExt.params
                                        }else{
                                            p=app.currentJson.params
                                        }
                                    }else{
                                        //s='App Modo: '+app.modo
                                        p=app.currentJson.params
                                        //s+=JSON.stringify(p, null, 2)
                                        //txt.text=s
                                        //return
                                    }
                                    let nvd=d.getDate()
                                    let nvm=d.getMonth()+1
                                    let nva=d.getFullYear()
                                    let nvh=d.getHours()
                                    let nvmin=d.getMinutes()
                                    txtMoveTime.text=''+nvd+'/'+nvm+'/'+nva+' '+nvh+':'+nvmin+'hs'+' '+app.modo

                                    p.gmt=zmt.gmt
                                    if((!p.t || p.t==='vn') && !zoolMap.zm.ev){
                                        p.a=nva
                                        p.m=nvm
                                        p.d=nvd
                                        p.h=nvh
                                        p.min=nvmin
                                        loadZmFromParams(p)
                                        app.isSaved=false
                                        printData(app.currentJson)
                                        return
                                    }
                                    if(app.modo==='trans_ext'){
                                        let jf=getSweJson('trans_ext', nva, nvm, nvd, nvh, nvmin, p.gmt, p.lat, p.lon, p.alt, p.hsys)
                                        app.currentJsonExt=jf
                                        app.modo='trans_ext'
                                        zoolMap.zm.objBodiesCircleExt.load(jf)
                                        zmt.onlySetDate=true
                                        zmt.targetDate=d
                                        return
                                    }
                                    //s='Cargando...'+app.modo+'\n'
                                    //s+=txtMoveTime.text+'\n'
                                    //s+=' '+nva+' '+nvm+' '+nvd+' '+nvh+' '+nvmin+' '+vgmt+' '+vlat+' '+vlon+' '+valt+' '+'T'+'\n'
                                    //txt.text=p.t
                                    //return

                                    let jf=getSweJson(p.t, p.a, p.m, p.d, p.h, p.min, p.gmt, p.lat, p.lon, p.alt, p.hsys)
                                    //txt.text=jf
                                    //return
                                    //s+=JSON.stringify(jf, null, 2)
                                    //txt.text=s
                                    //return

                                    if(app.modo==='trans' && zoolMap.zm.ev){
                                        app.currentJsonExt=jf
                                        zoolMap.zm.objBodiesCircleExt.load(jf)
                                        zoolMap.zm.objHousesCircleExt.load(jf)
                                        s+='Tránsitos:\n\n'
                                        s+='Fecha de Nacimiento:\n'
                                        s+=getMom(app.currentJson)
                                        s+='Tránsito:\n'
                                        s+=getMom(jf)
                                        s+=getList(jf)
                                        s+='\nCarta Natal\n'
                                        s+=getList(app.currentJson)
                                    }else{
                                        //s='Cargando...'+app.modo
                                        //txt.text=s
                                        //return
                                        app.currentJson=jf
                                        app.uFilePathLoaded='Tránsito '+vd+'/'+vm+'/'+va+' '+vh+':'+vmin
                                        s +=app.uFilePathLoaded+'\nTránsitos planetarios global/mundial.\n\n'
                                        s += getList(jf)
                                    }
                                    txt.text = s

                                }
                            }
                            Text{
                                id: txtMoveTime
                                text:''
                                font.pixelSize: !app.appRotated?app.fs:app.fs*0.5
                                color: apps.fontColor
                                anchors.bottom: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: text!=='' && zmt.modoSlider
                                Rectangle{
                                    width: parent.contentWidth+app.fs*0.4
                                    height: parent.contentHeight+app.fs*0.4
                                    color: apps.backgroundColor
                                    radius: app.fs*0.1
                                    border.width: 1
                                    border.color: apps.fontColor
                                    opacity: 0.75
                                    anchors.centerIn: parent
                                    z: parent.z-1
                                }
                            }
                        }
                        Rectangle{
                            id: xZEV
                            color: apps.backgroundColor
                            anchors.fill: parent
                            visible: false//zoolElementsView.visible
                            onVisibleChanged: {
                                if(visible)zoolElementsView.load(app.currentJson)
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: xZEV.visible=false
                            }
                            //Ocultar xZEV
                            ZmButton{
                                text: '\uf00d'
                                fs: !app.appRotated?app.fs*0.75:app.fs*0.35
                                width:!app.appRotated?app.fs*1.5:app.fs*0.75
                                isCuad: true
                                anchors.right: parent.right
                                onClicked:{
                                    xZEV.visible=false
                                }
                            }
                            ZoolElementsView{
                                id: zoolElementsView
                                //visible: false
                            }
                        }

                    }
                }
                Text{
                    id: txt
                    text: 'Selecciona un archivo'
                    width: parent.width-app.fs
                    font.pixelSize: app.fs
                    color: 'white'
                    wrapMode: Text.WordWrap
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.centerIn: parent
                }
                Row{
                    spacing: app.fs
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: app.uFilePathLoaded!=='' && app.uFilePathLoaded.indexOf('Ahora ')<0
                    ZmButton{
                        id: botEnviarIA
                        text: 'Enviar a IA'
                        fs: app.fs
                        property int anioRs: 0
                        //property var j: ({})
                        onClicked: {
                            //txtNot.text='Texto copiado.'
                            //clipboard.setText(getIACons())
                            let textoAEnviar = ''
                            if(app.modo==='rs'){
                                let j=app.currentJson
                                let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, botEnviarIA.anioRs, j.params.m, j.params.d, j.params.gmt);

                                let jsRS=getSweJson(j.params.t, arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lat, j.params.lon, j.params.alt, j.params.hsys)
                                //txt.text=JSON.stringify(jsRS, null, 2)
                                textoAEnviar = getIAConsRS(botEnviarIA.anioRs, jsRS)
                            }else{
                                textoAEnviar = getIACons()
                            }
                            AndroidShare.shareToGemini(textoAEnviar)
                            txtNot.text='Se envió la consulta hacia la IA'
                        }
                    }
                    ZmButton{
                        id: botCopiarIA
                        text: 'Copiar para IA'
                        fs: app.fs
                        onClicked: {
                            if(app.modo==='rs'){
                                let j=app.currentJson
                                let arrayRetornoSolar=swe.getSolarReturn(j.pc.c0.gdec, botEnviarIA.anioRs, j.params.m, j.params.d, j.params.gmt);

                                let jsRS=getSweJson(j.params.t, arrayRetornoSolar[0], arrayRetornoSolar[1], arrayRetornoSolar[2], arrayRetornoSolar[3], arrayRetornoSolar[4], j.params.gmt, j.params.lat, j.params.lon, j.params.alt, j.params.hsys)
                                //txt.text=JSON.stringify(jsRS, null, 2)
                                let textACopiar = getIAConsRS(botEnviarIA.anioRs, jsRS)
                                clipboard.setText(textACopiar)
                            }else{
                                clipboard.setText(getIACons())
                            }
                            txtNot.text='Texto copiado.'

                        }
                    }
                }
                Rectangle{
                    width: app.width
                    height: colDev.height+app.fs
                    color: 'transparent'
                    Rectangle{
                        id: fondoToque
                        anchors.fill: parent
                        opacity: 0.0
                        Behavior on opacity{NumberAnimation{duration: 150}}
                        onOpacityChanged: {
                            if(opacity===1.0)opacity=0.0
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        property int toques: 0
                        onClicked: {
                            toques++
                            fondoToque.opacity=1.0
                            if(toques>=3){
                                app.dev=true
                                toques=-1
                            }
                            if(toques===0){
                                app.dev=false
                            }
                        }
                    }
                    Column{
                        id: colDev
                        spacing: app.fs
                        anchors.centerIn: parent
                        visible: app.dev
                        Text{
                            text:'<b>Modo Desarrollador</b>'
                            font.pixelSize: app.fs*1.2
                            color: apps.fontColor
                        }
                        Row{
                            ZmButton{
                                text: 'Ver Json'
                                fs: app.fs
                                onClicked: {
                                    let fd=u.getFile(app.uFilePathLoaded)
                                    txt.text=JSON.stringify(JSON.parse(fd), null, 2)
                                }
                            }
                        }
                        ZmButton{
                            text: 'Ver Estados'
                            fs: app.fs
                            onClicked: {
                                let s=''
                                s+='app.uFilePathLoaded: '+app.uFilePathLoaded+'\n'
                                txt.text=s
                            }
                        }
                        ZmButton{
                            text: 'Probar'
                            fs: app.fs
                            onClicked: {
                                /*apps.showZoolandMap=true
                                let c='import QtQuick\n'
                                c+='import ZoolandMap 1.0\n'
                                c+='ZoolandMap{fs:'+app.fs+';}\n'
                                app.zoolMap=Qt.createQmlObject(c, xZoolandMap, 'zoolandmap-code')*/
                                //zoolMap.zm.ev=true
                                //u.checkPermissions()

                                //txt.text=app.currentJsonExt//JSON.stringify(app.currentJsonExt, null, 2)
                                txt.text='zoolMap.posMaxExt: '+zoolMap.posMaxExt
                            }
                        }
                        //Rotar Ventana en Windows
                        ZmButton{
                            text: 'Rotar Ventanta'
                            //width: app.fs*2
                            //fs: !app.appRotated?app.fs*1.5:app.fs*0.75
                            visible: Qt.platform.os==='linux'
                            onClicked:{
                                if(app.width===350){
                                    app.width=700
                                    app.height=350
                                    app.appRotated=true
                                }else{
                                    app.width=350
                                    app.height=700
                                    appRotated=false
                                }
                            }
                        }
                        ZmButton{
                            text: 'Copiar Texto'
                            fs: app.fs
                            onClicked: {
                                clipboard.setText(txt.text)
                                txtNot.text='Se copió el texto.'
                            }
                        }
                        ZmButton{
                            text: 'Salir de Modo Desarrollador'
                            fs: app.fs
                            onClicked: {
                                app.dev=false
                            }
                        }
                    }
                }
            }


        }


        /*Button{
            id: bot1
            text: 'Cargar'
            visible: false
            onClicked: {


                s+='Archivos: '+lista+'\n'
                txt.text=s
                txt.text+=getList()
            }
        }*/
        Form{id: form}
        ZoolandNumCalc{
            id: znc
            height: xApp.height
            parent: zoolMap.parent===xZoolandMap?xApp:zoolMap
        }
        Rectangle{
            id: xNot
            width: app.fs*10
            height: txtNot.contentHeight+app.fs*2
            color: 'black'
            border.width: 1
            border.color: 'white'
            opacity: txtNot.text===''?0.0:1.0
            anchors.centerIn: parent
            Timer{
                running: parent.visible
                repeat: false
                interval: 5000
                onTriggered: parent.visible=false
            }
            MouseArea{
                anchors.fill: parent
                onClicked: txtNot.text=''
            }
            Text{
                id: txtNot
                font.pixelSize: app.fs
                color: 'white'
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
            }
        }
    }
    QtObject{
        id: objDeleteFile
        property var args: []
        function run(args){
            u.deleteFile(app.uFilePathLoaded)
            if(!u.fileExist(args[0])){
                txt.text=''
                txtNot.text='Archivo '+args[0]+' eliminado.'
                app.uFilePathLoaded=''
                updateFileList()
            }else{
                txtNot.text='Error al eliminar el archivo '+args[0]+'.'
            }
            txt.text='Eliminando: '+args[0]+'\n'
        }
    }

    Component.onCompleted: {
        //u.checkPermissions()
        if(u.folderExist('/home/ns'))app.dev=true
        let s=''
        let appDataPath
        if(Qt.platform.os==='android'){
            appDataPath=u.getAndroidPublicDocumentsPath()
        }else{
            appDataPath=u.getPath(3)+'/Zool'
            if(!u.folderExist(appDataPath)){
                u.mkdir(appDataPath)
            }
        }
        app.currentFilesFolder=appDataPath
        let filePath=appDataPath+"/jsons/Ricardo.json"
        if(!u.fileExist(appDataPath+'/Ricardo.json')){
            let fd=u.getFile(filePath)
            u.setFile(appDataPath+'/Ricardo.json', fd)


        }else{
            //s+='Demo existe!\n'
        }
        let listaAppFiles = u.getFileList(appDataPath, ["*.json"])
        //s+='Lista de Archivos en '+appDataPath+': '+listaAppFiles+'\n'
        s+='\nTienes un total de '+listaAppFiles.length+' archivos.\n'

        txt.text=s
        updateFileList()

        //apps.aspLineWidth=2
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(Qt.platform.os!=='android')Qt.quit()
        }
    }
    function updateFileList(){
        //let appDataPath=u.getPath(4)
        let folder=app.currentFilesFolder//u.getPath(3)+'/Zool'
        if(!u.folderExist(folder)){
            u.mkdir(folder)
        }
        //let lista = u.getFileList(appDataPath+"/jsons", ["*.json"])
        let lista = u.getFileList(folder, ["*.json"])
        //txt.text=s
        let a=[]
        a.push('Seleccionar')
        for(var i=0;i<lista.length;i++){
            a.push(lista[i])
        }
        cbArchivos.model=a
    }
    function getSweJson(t, a, m, d, h, min, gmt, lat, lon, alt, hsys){
        if(Qt.platform.os==='linux'){
            swe.setSwePath(app.sweFolder)
        }if(Qt.platform.os==='android'){
            let appDataPath=u.getPath(4)
            swe.setSwePath(appDataPath+"/ephe")
            //swe.setSwePath("assets:/ephe")
        }else{
            swe.setSwePath('/home/ns/nsp/zoolandv2/android/assets/ephe')
        }
        let jNN={}
        let j=JSON.parse(swe.getHousesPos(a, m, d, h, min, gmt, lat, lon, alt, hsys))
        j.pc={}
        let aHousesPos=getJsonPhToArray(j.ph)
        //log.lv('aHousesPos: '+aHousesPos)
        for(var i=0;i<app.aIndexSweBodies.length;i++){
            let jb=JSON.parse(swe.getBodiePosJson(app.aIndexSweBodies[i], a, m, d, h, min, gmt, lon, lat, alt))
            jb['nom']=app.aBodies[i]
            jb.ih=getHouseIndexFromArrayDegs(jb.gdec-j.ph.h1.gdec, aHousesPos)
            //jb['ih']=1
            jb.dh=jb.ih

            if(i===11){
                jNN=jb
            }
            j.pc['c'+i]=jb
        }
        j.pc.c10.gdec=j.pc.c11.gdec+180.00
        if(j.pc.c10.gdec>=360.00){
            j.pc.c10.gdec=j.pc.c10.gdec-360.00
        }
        j.pc.c10.gdeg=j.pc.c10.gdec
        j.pc.c10.ih=j.pc.c11.ih-6
        if(j.pc.c10.ih<=0){
            j.pc.c10.ih=j.pc.c10.ih+12
        }
        j.pc.c10.is=getIndexSign(j.pc.c10.gdec)
        j.params={}
        j.params.sd=''+d+'/'+m+'/'+a+' '+h+':'+min
        j.params.d=d
        j.params.m=m
        j.params.a=a
        j.params.h=h
        j.params.min=min
        j.params.gmt=gmt
        j.params.lat=lat
        j.params.lon=lon
        j.params.alt=alt
        j.params.hsys=hsys
        j.params.t=t
        //log.lv('json: '+JSON.stringify(j, null, 2))
        //console.log('apps.url: '+apps.url)
        return j
    }
    function getJsonPhToArray(jsonPh){
        let a=[]
        for(var i=1;i<13;i++){
            //log.lv('--->:'+JSON.stringify(jsonPh['h'+i], null, 2))
            a.push(jsonPh['h'+i].gdec)
        }
        return a
    }
    function loadZmFromParams(p){
        let d=new Date(p.a, p.m-1, p.d, p.h, p.min)
        let va=d.getFullYear()
        let vm=d.getMonth()+1
        let vd=d.getDate()
        let vh=d.getHours()
        let vmin=d.getMinutes()
        let jf=getSweJson(p.t, va, vm, vd, vh, vmin, p.gmt, p.lat, p.lon, p.alt, 'T')
        zmt.onlySetDate=true
        zmt.gmt=p.gmt
        app.currentJson=jf
        zmt.onlySetDate=true
        zmt.targetDate=d
    }
    function getHouseIndexFromArrayDegs(planetDegree, cusps_degrees) {
        const numCusps = cusps_degrees.length;

        // Aseguramos que el grado esté normalizado en el rango [0, 360)
        let degree = planetDegree % 360;
        if (degree < 0) {
            degree += 360;
        }

        // Iteramos a través de las 12 casas (el índice i representa la Casa i+1)
        for (let i = 0; i < numCusps; i++) {
            // La cúspide de inicio de la casa actual (Casa i+1)
            const startCusp = cusps_degrees[i];

            // La cúspide de fin de la casa actual, que es la cúspide de la siguiente casa (C i+2).
            // Usamos el operador % para envolver de C12 a C1.
            const endCusp = cusps_degrees[(i + 1) % numCusps];

            // La casa actual es el rango [startCusp, endCusp)

            if (startCusp <= endCusp) {
                // Caso 1: Rango normal que no cruza el punto 0/360.
                // Ej: C3 (19.74°) a C4 (52.47°)
                if (degree >= startCusp && degree < endCusp) {
                    return i;
                }
            } else {
                // Caso 2: Rango que cruza el punto 0/360 (envoltura).
                // Ej: C2 (351.03°) a C3 (19.74°).
                // Esto incluye grados mayores que C2 O menores que C3.
                if (degree >= startCusp || degree < endCusp) {
                    return i;
                }
            }
        }

        // En teoría, este código nunca debería ser alcanzado si las cúspides cubren 360 grados.
        // Devolvemos 0 como un valor predeterminado para el índice de la Casa 1.
        return 0;
    }
    function getIndexSign(gdec){
        let index=0
        let g=0.0
        for(var i=0;i<12+5;i++){
            g = g + 30.00
            if (g > parseFloat(gdec)){
                break
            }
            index = index + 1
        }
        return index
    }
    function getDDToDMS(D) {
        return {
            deg: 0 | (D < 0 ? (D = -D) : D),
            min: 0 | (((D += 1e-9) % 1) * 60),
            sec: (0 | (((D * 60) % 1) * 6000)) / 100,
        };
    }
    function getList(j){
        //let j=getSweJson(1975, 6, 20, 23, 4, -3, -69.25, -36.25, 0, 'T')
        let s=''//'Carpeta: '+swe.getSwePath()+'\n'
        //s+='cant pc: '+Object.keys(j.pc).length+'\n'
        //let ascIS=parseInt(j.asc/30)

        let strDegreeData=''
        //Ascendente
        let gms=getDDToDMS(j.ph['h1'].gdec)
        let is=getIndexSign(j.ph['h1'].gdec)
        let rsdeg=gms.deg-(30*is)
        strDegreeData='°'+rsdeg
        if(apps.strDegreeData){
            strDegreeData+=' \''+gms.min+' \'\''+gms.sec
        }
        let p=app.currentJson.params
        let fecha=p.d+'/'+p.m+'/'+p.a
        s+='Sendero de Vida Numerológico: '+znc.getNums(fecha)[0]+'\n\n'
        s+='Ascendente (Casa 1): '+app.aSigns[is]+' '+strDegreeData+'\n'

        //Medio Cielo
        gms=getDDToDMS(j.ph['h10'].gdec)
        is=getIndexSign(j.ph['h10'].gdec)
        rsdeg=gms.deg-(30*is)
        strDegreeData='°'+rsdeg
        if(apps.strDegreeData){
            strDegreeData+=' \''+gms.min+' \'\''+gms.sec
        }
        s+='Medio Cielo (Casa 10): '+app.aSigns[is]+' '+strDegreeData+'\n'

        //Cuerpos
        for(var i=0;i<Object.keys(j.pc).length;i++){
            let ih=getHouseIndexFromArrayDegs(j.pc['c'+i].gdec, getJsonPhToArray(j.ph))+1
            gms=getDDToDMS(j.pc['c'+i].gdec)
            rsdeg=gms.deg-(30*j.pc['c'+i].is)
            strDegreeData='°'+rsdeg
            if(apps.strDegreeData){
                strDegreeData+=' \''+gms.min+' \'\''+gms.sec
            }
            s+=''+app.aBodies[i]+' en '+app.aSigns[j.pc['c'+i].is]+' '+strDegreeData+' en Casa '+ih+'\n'
        }
        s+='\nCuspides de las Casas: \n'
        for(i=0;i<12;i++){
            gms=getDDToDMS(j.ph['h'+parseInt(i+1)].gdec)
            is=getIndexSign(j.ph['h'+parseInt(i+1)].gdec)
            rsdeg=gms.deg-(30*is)
            s+='Casa '+parseInt(i+1)+' en '+app.aSigns[is]+' °'+rsdeg+'\n'
        }
        s+='\n'

        //s+='\n\n'+JSON.stringify(j, null, 2)
        return s
    }
    function printData(j){
        let s=''
        s+=getList(j)
        txt.text=s
    }
    function getDataFromFile(filePath, nom){
        if(nom==='Seleccionar')return
        let s = '\n\nArchivo: ' + nom + '\n\n'
        let fd = u.getFile(filePath)

        try {
            let j = JSON.parse(fd).params
            let jf = getSweJson(j.t, j.a, j.m, j.d, j.h, j.min, j.gmt, j.lat, j.lon, j.alt, 'T')
            app.currentJson=jf

            app.modo=j.t

            let nDate=new Date(j.a, j.m-1, j.d, j.h, j.min)
            zmt.onlySetDate=true
            zmt.targetDate=nDate

            if(app.modo==='cn' || jf.params.t==='vn' || jf.params.t==='cn'){
                s+='Fecha de Nacimiento:\n'
            }else if(app.modo==='rs'){
                s+='Fecha de Retorno Solar:\n'
            }else{
                s+='Fecha :\n'
            }
            s += getMom(jf)+'\n'
            s += getList(jf)
            txt.text = s
            app.uFilePathLoaded=filePath
        } catch(e) {
            txt.text="Ocurrió un error al cargar el archivo de "+nom+"! :("
        }
    }
    function getMom(j){
        let s=''
        s+=j.params.sd+'hs\n'
        s+='Latitud: '+j.params.lat+' Longitud: '+j.params.lon+'\nAltitud: '+j.params.alt+' GMT: '+j.params.gmt+'\n'
        return s
    }
    function getAyuda(){
        let s='Aplicación ZoolAnd para cálculo y creación de mapas y datos astrológicos.'+'\n\n'
        s+='Esta aplicación fué creada por Ricardo Martín Pizarro'+'\n'
        s+='Con el Framework Qt OpenSource 6.11.0'+'\n'
        s+='SwissEph (Tablas astronómicas JPL proveidas por la NASA)'+'\n\n'
        s+='Código Fuente: http://github.com/nextsigner/zooland'+'\n\n'
        s+='Para más información, contactar con el programador por las siguientes vías:'+'\n'
        s+='Whatsapp: +54 9 11 38024370'+'\n'
        s+='E-Mail: qtpizarro@gmail.com'+'\n'
        s+='YouTube: AstrólogoRicardoMartín'+'\n'
        s+='Instagram: RicardoMartínPizarro'+'\n'
        s+='Facebook: Ricardo Martín Pizarro'+'\n\n'
        s+='Buenos Aires Argentina - 2026'+'\n'
        return s
    }
    function getIACons(){
        let s=''
        s+='Consulta Astrológica. Dime cómo se manifiesta las siguientes influencias astrológicas de una persona nacida con la siguiente carta natal. De momento solo dime sobre el sol y al final recuerdame que debo escribir siguiente o s para ir interpretando las manifestaciones de los demás cuerpos astrológicos listados. Sobre cada cuerpo debes decirme 10 manifestaciones positivas y 10 negativas. Enfócate en interpretarlo desde el siguiente punto de vista,  Psicología, Autoconocimiento, útil para el ámbito de ralación de pareja, entorno cercan, familiar, laboral y social. Lista: '
        s+=getList(app.currentJson)+'\n'
        s+='\nTe en cuenta si hay algún cuerpo astrológico cerca o encima de alguna de las cúspides de las casas para interpretarlo correctamente con mayor precisión.\n'
        s+='Responde de forma puramente narrativa y con lenguaje fluido. Estoy trabajando con manos libres y escucharé tu respuesta por el auricular, así que evita por completo las listas, tablas, asteriscos o códigos. Organiza la información en párrafos continuos que sean fáciles de seguir auditivamente mientras realizo otras tareas. Debes estar atento a que yo pueda realizar consultas por medio tambien de audio por el micrófono. No cominences con la lectura hasta que yo no te haga mensión de que ya te estoy escuchando. Para avisarte te diré -te escucho-, -comineza- o algo similaapp.'
        return s
    }
    function getIAConsRS(a, j){
        let s=''
        s+='Consulta Astrológica para una lectura e interpretación de una Revolución Solaapp. Te aportaré los datos listados de los cuerpos de la carta natal y luego los cuerpos del mapa correspondienta al año '+a+'. No interpretes la carta natal, enfócate en interpretar la revolución solar correspondiente con esta carta natal. Dime cómo se manifiesta las siguientes influencias astrológicas de una persona, ya sea en si mismo, en su vida, en su entorno, con la siguente revolucion solaapp. . En este contexto de interpretación de retorno solar, dime principalmente la incidencia o impacto del Ascendente, Sol y Luna, luego, si hay otros cuerpos que estén generando una mayor influencia, con la relevancia que amerita ser mencionada, menciónalo. Sobre cada factor, Ascendente, Sol, Luna y otros debes decirme 10 manifestaciones positivas y 10 negativas. Enfócate en interpretarlo desde el siguiente punto de vista,  Psicología, eventos que o contextos pueden presentarse, útil para el ámbito de ralación de pareja, entorno cercan, familiar, laboral y social.\nLista de cuerpos de la Carta Natal: '
        s+=getList(app.currentJson)+'\n'
        s+='Lista de cuerpos de la Revolución Solar del año '+a+': '
        s+=getList(j)+'\n'
        s+='\nTe en cuenta si hay algún cuerpo astrológico cerca o encima de alguna de las cúspides de las casas para interpretarlo correctamente con mayor precisión.\n'
        s+='Responde de forma puramente narrativa y con lenguaje fluido. Estoy trabajando con manos libres y escucharé tu respuesta por el auricular, así que evita por completo las listas, tablas, asteriscos o códigos. Organiza la información en párrafos continuos que sean fáciles de seguir auditivamente mientras realizo otras tareas. Debes estar atento a que yo pueda realizar consultas por medio tambien de audio por el micrófono. No cominences con la lectura hasta que yo no te haga mensión de que ya te estoy escuchando. Para avisarte te diré -te escucho-, -comineza- o algo similaapp.'
        return s
    }
}
