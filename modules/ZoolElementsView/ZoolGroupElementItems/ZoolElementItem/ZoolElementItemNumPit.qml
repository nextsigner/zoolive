import QtQuick 2.0
import ZoolText 1.4

Rectangle{
    id: r
    width: r.fs*6
    height: r.fs*1.5
    border.width: 1
    border.color: apps.backgroundColor
    color: apps.fontColor
    radius: r.fs*0.25
    property int fs: app.fs*6
    property bool isExt: false

    property int nd: 0
    property string ns: '0'
    property int ag: -1
    property string arbolGen: '?'

    onWidthChanged: {
        zt1.font.pixelSize = r.width*0.15
        zt2.font.pixelSize = r.width*0.15
        zt3.font.pixelSize = r.width*0.15
    }
    MouseArea{
        enabled: !r.locked
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons;
        onClicked: {
            if (mouse.button === Qt.RightButton && (mouse.modifiers & Qt.ControlModifier)) {
                zoolElementsView.settings.zoom+=0.1
            }else if(mouse.button === Qt.LeftButton  && (mouse.modifiers & Qt.ControlModifier)){
                zoolElementsView.settings.zoom-=0.1
            }else{
                log.lv('Elemento no sabe que hacer: ???')
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            //zm.previewEnabled=true
            //sendDataToModuleNumPit(true)
            //sendDataToModuleNumPit(false)
            let p=zfdm.getJsonAbsParams(r.isExt)
            zsm.showPanel('ZoolNumPit')
            let panel=zsm.getPanel('ZoolNumPit')
            let date= new Date(p.a, p.m-1, p.d, p.h, p.min)
            panel.setCurrentDate(date)
        }
    }
    Row{
        anchors.centerIn: parent
        spacing: r.fs*0.5
        Text{id: zt1; text: '<b>'+r.nd+'</b>'; color: apps.backgroundColor; font.pixelSize: r.fs}
        Text{id: zt2; text: '<b>'+r.ns+'</b>'; color: apps.backgroundColor; font.pixelSize: r.fs}
        Text{id: zt3; text: '<b>'+r.arbolGen+'</b>'; color: apps.backgroundColor; font.pixelSize: r.fs}
    }
    function updateNumPit(){
        let d = !r.isExt?app.j.getNums(zm.currentFecha):app.j.getNums(zm.currentFechaBack)
        if(d[0]===-1 && d[1]===-1 && d[2]===-1)return
        r.nd=d[0]
        r.ns=d[1]
        if(parseInt(d[2])>=0 && parseInt(d[2])<=3){
            r.ag=parseInt(d[2])
            r.arbolGen=app.arbolGenealogico[parseInt(d[2])][0]
        }
        //log.lv('ZoolElementItemNumPit::update()...')
    }
    function sendDataToModuleNumPit(fromMouseClick){
        //log.lv('ZoolElementItemNumPit::sendDataToModuleNumPit(fromMouseClick: '+fromMouseClick+')...')
        if(zm.previewEnabled)return
        //log.lv('zm.previewEnabled: '+zm.previewEnabled)
        let sp=!r.isExt?zm.fileData:zm.fileDataBack
        let p=JSON.parse(sp)
        let cd=new Date(p.params.a, p.params.m-1, p.params.d)

        //zsm.getPanel('ZoolNumPit').currentDate=!r.isExt?zm.currentDate:zm.currentDateBack
        zsm.getPanel('ZoolNumPit').currentDate=cd
        if(r.isExt){
            //log.lv('zsm.getPanel(\'ZoolNumPit\').currentDate: '+zsm.getPanel('ZoolNumPit').currentDate)
        }
        //zsm.getPanel('ZoolNumPit').setCurrentDate(!r.isExt?zm.currentDate:zm.currentDateBack)
        if(!zsm.getPanel('ZoolNumPit').visible)return
        zsm.getPanel('ZoolNumPit').setCurrentDate(cd)
        zsm.getPanel('ZoolNumPit').setCurrentNombre(!r.isExt?zm.currentNom:zm.currentNomBack)
        zsm.getPanel('ZoolNumPit').currentAG=app.arbolGenealogico[r.ag]
        zsm.getPanel('ZoolNumPit').updateGenero()
        zsm.getPanel('ZoolNumPit').currentCargaAG=zsm.getPanel('ZoolNumPit').aCargasAG[r.ag]
        zsm.getPanel('ZoolNumPit').isExt=r.isExt
        if((app.t!=='dirprim'&&app.t!=='progsec'&&app.t!=='trans') || fromMouseClick){
            let ci=zsm.getPanelIndex('ZoolNumPit')
            zsm.currentIndex=ci
        }
    }
}
