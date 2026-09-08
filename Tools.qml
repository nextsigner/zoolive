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
    Flow{
        anchors.centerIn: parent
        Row{
            spacing: app.fs*0.5
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
}
