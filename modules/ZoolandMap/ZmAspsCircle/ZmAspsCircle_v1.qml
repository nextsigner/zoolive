import QtQuick 2.0

Rectangle{
    id: r
    width: zoolMap.fs*8
    height: width
    radius: width*0.5
    border.width: 1
    border.color: 'white'
    color: 'black'
    anchors.centerIn: parent
    antialiasing: true
    property bool isExt: false
    property int currentAspSelected: -1
    property int widthNodosAspSelected: 8
    property var aAspStr1: []
    property var aAspStr2: []
    property var aAspsColors: ['red','#ff8833',  'green', '#124cb1', '#90EE90', '#FFC0CB', '#EE82EE']
    onWidthChanged: {
        //r.visible=false
        if(xAsps.children.length>0)clearSL(xAsps)
        //xAsps.visible=false
        tLoadJson.restart()
        //tHideTapa.restart()
        currentAspSelected=-1
        //tLoadJson.restart()
        //log.lv('xAsps.json: '+JSON.stringify(xAsps.json))
    }
    /*Timer{
        id: tHideTapa
        repeat: false
        interval: 100
        onTriggered: {
            tLoadJson.restart()
            //xAsps.visible=true
            //zm.hideTapa()
        }
    }*/
    property bool show: true
    Rectangle{
        id: bg
        width: r.width
        height: width
        color: apps.backgroundColor
        border.width: 1
        border.color: 'yellow'

        radius: width*0.5
        anchors.centerIn: r
        visible: false
        //visible:r.show// !app.ev?apps.showAspCircle:(apps.showAspCircle && apps.showAspCircleBack)
        //        visible: !r.isExt?
        //                     (apps.showAspCircle)
        //                   :
        //                     (apps.showAspCircleBack)
    }
    Rectangle{
        id: xAsps
        width: r.width
        height: width
        color: 'transparent'//apps.backgroundColor//'black'
        radius: width*0.5
        anchors.centerIn: r
        property var json
        onJsonChanged: tLoadJson.restart()
        //clip: true
        //visible: apps.showAspCircle && r.show
    }
    Timer{
        id: tLoadJson
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            updateAllAsps()
            /*return
            if(!xAsps.json)return
            let panel=zsm.getPanel('ZoolConfig')
            let section=panel.getSection('ConfigAsps')
            //clearSL(xAsps)
            var x = xAsps.width*0.5;
            var y = xAsps.height*0.5;
            var radius=xAsps.width*0.5
            var cx=xAsps.width*0.5
            var cy=xAsps.height*0.5
            //log.lv('xAsps.json: '+JSON.stringify(xAsps.json, null, 2))
            if(xAsps.json&&xAsps.json.asps){
                let asp=xAsps.json.asps
                for(var i=0;i<Object.keys(asp).length;i++){
                    if(asp['asp'+parseInt(i +1)]){
                        if((asp['asp'+parseInt(i +1)].ic1===10 && asp['asp'+parseInt(i +1)].ic2===11)||(asp['asp'+parseInt(i +1)].ic1===11 && asp['asp'+parseInt(i +1)].ic2===10)){
                            continue
                        }else{
                            let a=asp['asp'+parseInt(i +1)]

                            let colorAsp='black'
                            //# -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono

                            if(!section.getCheckedAsps(a.ia)){
                                continue
                            }

                            if(a.ia===-1){
                                colorAsp='gray'
                            }
                            if(a.ia===0){
                                colorAsp='red'
                            }
                            if(a.ia===1){
                                colorAsp='#ff8833'
                            }
                            if(a.ia===2){
                                colorAsp='green'
                            }
                            if(a.ia===3){
                                colorAsp='blue'
                            }
                            if(a.ia===4){
                                colorAsp='#90EE90'
                            }
                            if(a.ia===5){
                                colorAsp='#FFC0CB'
                            }
                            if(a.ia===6){
                                colorAsp='#EE82EE'
                            }
                            drawAsp(cx, cy, a.gdeg1, a.gdeg2, colorAsp, i, xAsps, r.isExt)
                            //drawAsp(cx, cy, a.gdeg1, a.gdeg2, colorAsp, i, xAsps, r.isExt)
                        }
                    }
                }
            }
            zm.hideTapa()*/
        }
    }

    Rectangle{
        id: xAxis
        width: r.width
        height: width
        color: 'transparent'//apps.backgroundColor//'black'
        border.width: 0
        border.color: 'blue'
        radius: width*0.5
        anchors.centerIn: r
    }
    Component{
        id: compLineSen
        Rectangle{
            width: 1
            height: 1
            Rectangle{
                width: 500
                height: 3
                color: parent.color
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
            }
        }
    }
    function drawAsp(cx, cy, gdeg1, gdeg2, c, i, item, isBack){
        var angulo= gdeg1
        var coords=gCoords(radius, angulo)
        var px1 = coords[0]
        var py1 = coords[1]
        angulo= gdeg2
        coords=gCoords(radius, angulo)
        var px2 = coords[0]
        var py2 = coords[1]
        drawAspRect(px1+cx, py1+cy, px2+cx, py2+cy, c, i, item, isBack, 360-angulo)
    }
    function drawAspRect(sx, sy, px, py, c, i, item, isBack, angulo){
        let s='s'+sx+'-'+sy+'-'+px+'-'+py
        //let comp=Qt.createComponent("../../comps/AspShapeLine.qml")
        //let comp=Qt.createComponent("../../../modules/ZoolMap/ZmAspsCircle/AspShapeLine.qml")
        let comp=Qt.createComponent(Qt.platform.os==='android'?"assets:/modules/ZoolandMap/ZmAspsCircle/AspShapeLine.qml":"/home/ns/nsp/zoolandv2/android/assets/modules/ZoolandMap/ZmAspsCircle/AspShapeLine.qml")
        let obj=comp.createObject(item,{sx: sx, sy: sy, px: px, py: py, c: c, n:i, isBack: isBack})
        //        if(i<3){
        //            let objLineSen=compLineSen.createObject(item,{x: sx, y: sy, color: c, rotation: angulo})
        //        }
        r.aAspStr1.push(s)
    }
    function drawAspAxisRect(numAstro, indexAsp, angulo, isExt){
        let comp=Qt.createComponent("../../../modules/ZoolMap/ZoolMapAspsCircle/AspAxisLine.qml")
        let as=zoolMap.zm.objBodiesCircle.getAs(numAstro)
        let l1=zoolMap.zm.objBodiesCircle.width
        let l2=r.width//-((app.fs*as.pos))
        let l3=(l1-(l1-l2))*0.5
        let l=l3-zoolMap.bodieSize-(zoolMap.bodieSize*as.pos)
        //log.lv('as.pos:'+as.pos)
        //log.lv('l1:'+l1)
        //log.lv('l2:'+l2)
        //log.lv('l:'+l)
        //let obj=comp.createObject(xAxis,{numAstro:numAstro, indexAsp: indexAsp, l:l, rot: angulo, isExt: isExt})
        //r.aAspStr1.push(s)
    }
    function clearAxis(){
        for(var i=0;i<xAxis.children.length;i++){
            xAxis.children[i].destroy(0)
        }
    }
    function gCoords(radius, angle) {
        var d = Math.PI/180 //to convert deg to rads
        var deg
        var x
        var y
        deg = (360 - angle - 90) * d
        x = radius * Math.cos(deg)
        y = radius * Math.sin(deg)
        return [ x, y ];
    }
    function load(json){
        clearSL(xAsps)
        r.aAspStr1=[]
        xAsps.json=getAsps(json)

        //drawAspAxisRect(0, 0, 0, false)

        //console.log('jsonAsps:'+JSON.stringify(json, null, 2))
    }
    function loadFromJsonAsps(json){
        clearSL(xAsps)
        r.aAspStr1=[]
        xAsps.json=json

        //console.log('jsonAsps:'+JSON.stringify(json, null, 2))
    }
    function updateAllAsps(){
        if(!xAsps.json)return
        //let panel=zsm.getPanel('ZoolConfig')
        //let section=panel.getSection('ConfigAsps')
        clearSL(xAsps)
        var x = xAsps.width*0.5;
        var y = xAsps.height*0.5;
        var radius=xAsps.width*0.5
        var cx=xAsps.width*0.5
        var cy=xAsps.height*0.5
        //log.lv('xAsps.json: '+JSON.stringify(xAsps.json, null, 2))
        if(xAsps.json&&xAsps.json.asps){
            let asp=xAsps.json.asps
            for(var i=0;i<Object.keys(asp).length;i++){
                if(asp['asp'+parseInt(i +1)]){
                    if((asp['asp'+parseInt(i +1)].ic1===10 && asp['asp'+parseInt(i +1)].ic2===11)||(asp['asp'+parseInt(i +1)].ic1===11 && asp['asp'+parseInt(i +1)].ic2===10)){
                        continue
                    }else{
                        let a=asp['asp'+parseInt(i +1)]

                        let colorAsp='black'
                        //# -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono

                        /*if(!section.getCheckedAsps(a.ia)){
                            continue
                        }*/

                        if(a.ia===-1){
                            colorAsp='gray'
                        }
                        if(a.ia===0){
                            colorAsp='red'
                        }
                        if(a.ia===1){
                            colorAsp='#ff8833'
                        }
                        if(a.ia===2){
                            colorAsp='green'
                        }
                        if(a.ia===3){
                            colorAsp='blue'
                        }
                        if(a.ia===4){
                            colorAsp='#90EE90'
                        }
                        if(a.ia===5){
                            colorAsp='#FFC0CB'
                        }
                        if(a.ia===6){
                            colorAsp='#EE82EE'
                        }
                        drawAsp(cx, cy, a.gdeg1, a.gdeg2, colorAsp, i, xAsps, r.isExt)
                        //drawAsp(cx, cy, a.gdeg1, a.gdeg2, colorAsp, i, xAsps, r.isExt)
                    }
                }
            }
        }
        ///zoolMap.hideTapa()
    }
    function clear(){
        clearSL(xAsps)
    }
    function clearSL(item){
        for(var i=0;i<item.children.length;i++){
            item.children[i].destroy(1)
        }
    }
    function rotate_point(pointX, pointY, originX, originY, angle) {
        angle = angle * Math.PI / 180.0;
        return {
            x: Math.cos(angle) * (pointX-originX) - Math.sin(angle) * (pointY-originY) + originX,
            y: Math.sin(angle) * (pointX-originX) + Math.cos(angle) * (pointY-originY) + originY
        };
    }
    function angle(cx, cy, ex, ey) {
        var dy = ey - cy;
        var dx = ex - cx;
        var theta = Math.atan2(dy, dx); // range (-PI, PI]
        theta *= 180 / Math.PI; // rads to degs, range (-180, 180]
        //if (theta < 0) theta = 360 + theta; // range [0, 360)
        return theta;
    }
    function getAsps(json){
        let j={}
        if(!json)return j
        j.asps={}
        let indexAsp=1
        let aAspsReg=[]
        for(var i=0;i<zoolMap.aBodies.length;i++){
            //log.lv('aBodies['+i+']: '+aBodies[i])
            let g1=json.pc['c'+i].gdec
            //log.lv('g1 de '+aBodies[i]+': '+g1)
            for(var i2=0;i2<zoolMap.aBodies.length;i2++){
                //log.lv('g2 de '+aBodies[i2]+': '+g2+'\n\n')
                let g2=json.pc['c'+i2].gdec
                let aspType=getAsp(g1, g2)
                if(aspType!==-1){
                    //log.lv('aspType: '+aspType+' entre '+aBodies[i]+' y '+aBodies[i2]+'\n\n')
                    let search=''+i2+':'+i
                    if(aAspsReg.indexOf(search)<0&&i!==i2){
                        j.asps['asp'+indexAsp]={}
                        j.asps['asp'+indexAsp].ic1=i
                        j.asps['asp'+indexAsp].ic2=i2
                        j.asps['asp'+indexAsp].c1=zoolMap.aBodies[i]
                        j.asps['asp'+indexAsp].c2=zoolMap.aBodies[i2]
                        j.asps['asp'+indexAsp].ia=aspType
                        j.asps['asp'+indexAsp].gdeg1=g1
                        j.asps['asp'+indexAsp].gdeg2=g2
                        j.asps['asp'+indexAsp].dga=diffDegn(g1, g2)
                        aAspsReg.push(''+i+':'+i2)
                        indexAsp++
                    }
                }
            }
        }
        //log.lv('Nuevo Json Asps: '+JSON.stringify(j, null, 2))
        //log.lv('Total asps: '+indexAsp)
        //json.asps=j
        return j
    }
    function getAsp(g1, g2) {
        let asp = -1; // -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono. 3 = conjunción. 4 = sextil. 5 = semicuadratura. 6 = quincuncio
        let orbeConjunccion = 8;
        let orbeOposicion = 8;
        let orbeTrigono = 8;
        let orbeCuadratura = 7;
        let orbeSextil = 6;
        let orbeSemicuadratura = 2;
        let orbeQuincuncio = 2;


        let difDeg;

        // Calculo conjunción.
        difDeg = diffDegn(g1, g2);
        if (difDeg < orbeConjunccion && difDeg > -orbeConjunccion) {
            asp = 3; // Conjunción
            return asp;
        }

        // Calculo oposición.
        difDeg = diffDegn(g1, g2);
        if (difDeg < 180.00 + orbeOposicion && difDeg > 180.00 - orbeOposicion) {
            asp = 0; // Oposición
            return asp;
        }

        // Calculo cuadratura.
        difDeg = diffDegn(g1, g2);
        if (difDeg < 90.00 + orbeCuadratura && difDeg > 90.00 - orbeCuadratura) {
            asp = 1; // Cuadratura
            return asp;
        }

        // Calculo trígono.
        difDeg = diffDegn(g1, g2);
        if (difDeg < 120.00 + orbeTrigono && difDeg > 120.00 - orbeTrigono) {
            asp = 2; // Trígono
            return asp;
        }

        // Calculo sextil.
        difDeg = diffDegn(g1, g2);
        if (difDeg < 60.00 + orbeSextil && difDeg > 60.00 - orbeSextil) {
            asp = 4; // Sextil
            return asp;
        }

        // Calculo semicuadratura (45 grados).
        difDeg = diffDegn(g1, g2);
        if (difDeg < 45.00 + orbeSemicuadratura && difDeg > 45.00 - orbeSemicuadratura) {
            asp = 5; // Semicuadratura
            return asp;
        }

        difDeg = diffDegn(g1, g2);
        if (difDeg < 135.00 + orbeSemicuadratura && difDeg > 135.00 - orbeSemicuadratura) {
            asp = 5; // Semicuadratura
            return asp;
        }

        // Calculo quincuncio (150 grados).
        difDeg = diffDegn(g1, g2);
        if (difDeg < 150.00 + orbeQuincuncio && difDeg > 150.00 - orbeQuincuncio) {
            asp = 6; // Quincuncio
            return asp;
        }

        difDeg = diffDegn(g1, g2);
        if (difDeg < 210.00 + orbeQuincuncio && difDeg > 210.00 - orbeQuincuncio) {
            asp = 6; // Quincuncio
            return asp;
        }

        return asp; // -1 = no hay aspectos dentro de los orbes definidos
    }
    function diffDegn(deg1, deg2) {
        let diff = Math.abs(deg1 - deg2) % 360;
        return Math.min(diff, 360 - diff);
    }
    function getAspName(indexAsp){
        // -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono. 3 = conjunción. 4 = sextil. 5 = semicuadratura. 6 = quincuncio
        let aspName=''
        if(indexAsp<0){
            aspName='Indefinido'
        }else if(indexAsp===0){
            aspName='Oposición'
        }else if(indexAsp===1){
            aspName='Cuadratura'
        }else if(indexAsp===2){
            aspName='Trígono'
        }else if(indexAsp===3){
            aspName='Conjunción'
        }else if(indexAsp===4){
            aspName='Sextil'
        }else if(indexAsp===5){
            aspName='Semicuadratura'
        }else if(indexAsp===6){
            aspName='Quincuncio'
        }else{
            aspName='?'
        }
        return aspName
    }
    function getAspDeg(asp) {
        switch (asp.toLowerCase()) {
        case "oposición":
            return 180;
        case "cuadratura":
            return 90;
        case "trígono":
            return 120;
        case "conjunción":
            return 0;
        case "sextil":
            return 60;
        case "semicuadratura":
            return 45;
        case "quincuncio":
            return 150;
        default:
            return null; // Retorna null si el aspecto no es reconocido
        }
    }
    function showOneBodieAsp(numAstro, isExt){
        let panel=zsm.getPanel('ZoolConfig')
        let section=panel.getSection('ConfigAsps')

        if(!isExt){
            clearAxis()
        }else{
            clearAxis()
        }
        let j1
        let j2
        if(!zoolMap.zm.ev){
            j1=!r.isExt?zoolMap.currentJson:zoolMap.currentJsonBack
            j2=!r.isExt?zoolMap.currentJson:zoolMap.currentJsonBack
        }else{
            j1=!r.isExt?zoolMap.currentJson:zoolMap.currentJsonBack
            j2=r.isExt?zoolMap.currentJson:zoolMap.currentJsonBack
        }
        if(numAstro<0){
            if(!r.isExt){
                load(zoolMap.currentJson)
            }else{
                load(zoolMap.currentJsonBack)
            }
            return
        }

        let indexAsp=0
        let j={}
        j.asps={}
        let aAspsReg=[]

        let g1=j1.pc['c'+numAstro].gdec
        for(var i=0;i<zoolMap.aBodies.length;i++){
            let g2=j2.pc['c'+i].gdec
            let aspType=getAsp(g1, g2)
            if(!section.getCheckedAsps(aspType)){
                continue
            }
            if(aspType>=0){
                let indexAspName=getAspName(indexAsp)
                let search=''+numAstro+':'+i
                if(aAspsReg.indexOf(search)<0&&numAstro!==i){
                    j.asps['asp'+indexAsp]={}
                    j.asps['asp'+indexAsp].ic1=numAstro
                    j.asps['asp'+indexAsp].ic2=i
                    j.asps['asp'+indexAsp].c1=zoolMap.aBodies[numAstro]
                    j.asps['asp'+indexAsp].c2=zoolMap.aBodies[i]
                    j.asps['asp'+indexAsp].ia=aspType
                    j.asps['asp'+indexAsp].gdeg1=g1
                    j.asps['asp'+indexAsp].gdeg2=g2
                    j.asps['asp'+indexAsp].dga=diffDegn(g1, g2)
                    aAspsReg.push(''+numAstro+':'+i)
                    indexAsp++
                    drawAspAxisRect(numAstro, aspType, g1, r.isExt)
                    drawAspAxisRect(numAstro, aspType, g2, r.isExt)
                }
                //log.lv('indexAspName: '+indexAspName)
            }
        }
        //log.lv('j: '+JSON.stringify(j, null, 2))
        loadFromJsonAsps(j)
    }

}
