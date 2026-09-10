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
        Row{
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            //Abrir
            ZmButton{
                text: '\uf016'
                width: app.fs*2
                isCuad: true
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    r.visible=false

                }
                Text{
                    text: 'A'
                    font.pixelSize: parent.width*0.5
                    color: apps.backgroundColor
                    anchors.centerIn: parent
                }
            }
            //Cargar Tránsitos en INT
            ZmButton{
                text: '\uf0e7'
                width: app.fs*2
                fs: app.fs*1.5
                anchors.verticalCenter: parent.verticalCenter
                //visible: app.uFilePathLoaded==='' || app.uFilePathLoaded.indexOf('Ahora ')===0
                onClicked: {
                    r.visible=false
                    cbArchivos.currentIndex=0
                    xSelectRs.visible=false
                    let s=''
                    let d=new Date(Date.now())
                    let va=d.getFullYear()
                    let vm=d.getMonth()+1
                    let vd=d.getDate()
                    let vh=d.getHours()
                    let vmin=d.getMinutes()
                    let jf=getSweJson('trans', va, vm, vd, vh, vmin, apps.userGmt, 0.0, 0.0, 0, 'T')
                    app.currentJson=jf
                    app.modo='trans'
                    app.uFilePathLoaded='Ahora '+vd+'/'+vm+'/'+va+' '+vh+':'+vmin
                    s +=app.uFilePathLoaded+'\nTránsitos planetarios global/mundial.\n\n'
                    s += getList(jf)
                    txt.text = s
                    zmt.onlySetDate=true
                    zmt.targetDate=d
                    zmt.isExt=false
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
                    r.visible=false
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
                    r.visible=false
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
            id: rowBtns
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
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
            //Cargar Tránsitos de ahora EXT
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
                    let jf=getSweJson('trans_ext', va, vm, vd, vh, vmin, apps.userGmt, 0.0, 0.0, 0, 'T')
                    app.currentJsonExt=jf
                    app.modo='trans_ext'
                    zoolMap.zm.objBodiesCircleExt.load(jf)
                    zmt.onlySetDate=true
                    zmt.targetDate=d
                    zmt.isExt=true
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
                    console.log('RS app.uFilePathLoaded: '+app.uFilePathLoaded)
                    let fd = u.getFile(app.currentFilesFolder+'/'+app.uFilePathLoaded)
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
                    let fullFilePath=app.currentFilesFolder+'/'+rutaCompleta
                    //console.log('fullFilePath: '+fullFilePath)
                    let fd=u.getFile(fullFilePath)
                    //console.log('fd: '+fd)
                    let p=JSON.parse(fd).params
                    app.modo=p.t
                    loadZmFromParams(p)
                    app.uFilePathLoaded=rutaCompleta
                    app.isSaved=true
                    printData(app.currentJson)
                    tools.visible=false
                }
            }                        }
        Row{
            id: xSelectRs
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            Text{
                id: tit2
                text: 'Año de\nRev. Solar:'
                color: 'white'
                anchors.verticalCenter: parent.verticalCenter
            }
            ZmComboBox {
                id: cbAniosRS
                width: xApp.width// - tit1.contentWidth - app.fs*2
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
                    tools.visible=false
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
    }
}
