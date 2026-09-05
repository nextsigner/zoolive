import QtQuick 2.0
import ZoolandMap.ZmBodiesCircle.ZmBodie 1.0

Item{
    id: r
    height: width
    anchors.centerIn: parent
    property var aGdecs: []

    Item{
        id: xBodies
        //anchors.fill: parent
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        Repeater{
            model: zoolMap.aBodies
            ZmBodie{
                numBodie: index
                rotation: 10*index
                isExt: true
            }
        }
    }
    /*Timer{
        running: true
        repeat: true
        interval: 3000
        onTriggered: setAspsCircleWidth()
    }*/
    function load(j){
        r.aGdecs=[]
        let jInt=app.currentJson
        for(var i=0;i<zoolMap.aBodies.length;i++){
            xBodies.children[i].rotation=360-(360-jInt.ph['h1'].gdec)-j.pc['c'+i].gdec
            r.aGdecs.push(j.pc['c'+i].gdec)
            xBodies.children[i].pos=0
        }
        ordenarPosiciones()
    }



    function ordenarPosiciones() {
        let aGdecs = r.aGdecs
        let maxPos = 0;

        // 1. Limpiamos posiciones previas
        for(var i = 0; i < aGdecs.length; i++){
            xBodies.children[i].pos = 0;
        }

        // 2. Recorremos cada cuerpo para encontrarle su nivel 'pos' ideal
        for(var i = 0; i < aGdecs.length; i++){
            let objActual = xBodies.children[i];
            let nivelEncontrado = false;
            let nivelDePrueba = 0;

            while(!nivelEncontrado){
                let hayColisionEnEsteNivel = false;

                // Comparamos el cuerpo 'i' contra todos los ANTERIORES que ya ubicamos
                for(var j = 0; j < i; j++){
                    let objComparar = xBodies.children[j];

                    // Si están en el mismo nivel, verificamos si chocan por grados
                    if(objComparar.pos === nivelDePrueba){
                        if(hayAlgoAhi(aGdecs[i], aGdecs[j])){
                            hayColisionEnEsteNivel = true;
                            break; // Salimos del bucle 'j', ya sabemos que este nivel no sirve
                        }
                    }
                }

                if(!hayColisionEnEsteNivel){
                    objActual.pos = nivelDePrueba;
                    nivelEncontrado = true;
                } else {
                    nivelDePrueba++; // Probamos un nivel más hacia el centro
                }
            }

            if(nivelDePrueba > maxPos) maxPos = nivelDePrueba;
        }

        //setAspsCircleWidth()
        // 3. Informamos el máximo nivel alcanzado para ajustar el mapa
        /*if(!r.isBack){
            zoolMap.posMaxInt = maxPos;
        } else {
            zoolMap.posMaxExt = maxPos;
        }*/
        zoolMap.posMaxExt = maxPos;
        zoolMap.zm.ev=true
    }
    function hayAlgoAhi(startDegree, secondStartDegree){
        const margen=15.00
        // Normalize degrees to be within the 0-360 range
        const normalize = (deg) => ((deg % 360) + 360) % 360;

        const normalizedStart = normalize(startDegree);
        const normalizedSecondStart = normalize(secondStartDegree);

        // Define the arcs
        const endDegree = normalize(normalizedStart + margen);
        const secondEndDegree = normalize(normalizedSecondStart + margen);

        // Check for overlap, handling the wrap-around case (end < start)
        const isOverlapping = (start1, end1, start2, end2) => {
            // Standard overlap check
            if (end1 >= start1 && end2 >= start2) {
                return (
                    (start1 >= start2 && start1 <= end2) ||
                    (end1 >= start2 && end1 <= end2) ||
                    (start2 >= start1 && start2 <= end1) ||
                    (end2 >= start1 && end2 <= end1)
                    );
            }

            // Overlap where the first arc wraps around (end1 < start1)
            if (end1 < start1) {
                return (
                    (start2 >= start1 || end2 <= end1) || // Second arc spans the wrap-around
                    (start2 >= start1 && start2 <= 360) || // Second arc starts in the first part
                    (end2 >= 0 && end2 <= end1) // Second arc ends in the second part
                    );
            }

            // Overlap where the second arc wraps around (end2 < start2)
            if (end2 < start2) {
                return (
                    (start1 >= start2 || end1 <= end2) || // First arc spans the wrap-around
                    (start1 >= start2 && start1 <= 360) || // First arc starts in the first part
                    (end1 >= 0 && end1 <= end2) // First arc ends in the second part
                    );
            }
        };

        return isOverlapping(normalizedStart, endDegree, normalizedSecondStart, secondEndDegree);
    }
    /*function setAspsCircleWidth(){
        let w=zoolMap.width
        for(var i=0;i<zoolMap.aBodies.length;i++){
            let as=xBodies.children[i]
            if(as.width<w){
                w=as.width
            }
        }
        zoolMap.aspCircleWidth=w
    }
    function setMaxPos(){
        let maxPos=1
        for(var i=0;i<zoolMap.aBodies.length;i++){
            let as=xBodies.children[i]
            if(as.pos>maxPos){
                maxPos=as.pos
            }
        }
        if(!r.isBack){
            zoolMap.posMaxInt=maxPos
        }else{
            zoolMap.posMaxExt=maxPos
        }
    }*/
    function getMaxZBodie(){
        let maxZ=1
        for(var i=0;i<zoolMap.aBodies.length;i++){
            let as=xBodies.children[i]
            if(as.z>maxZ){
                maxZ=as.z
            }
        }
        return maxZ
    }
    function setAspsCircleWidth(){
        let w=zoolMap.zm.width//aspCircleWidth
        let bw
        for(var i=0;i<zoolMap.aBodies.length;i++){
            bw=xBodies.children[i].width//zm.objBodiesCircle.getBodieWidth(i)
            if(bw<w){
                w=bw
                zoolMap.aspCircleWidth=bw
            }
            if(zoolMap.aspCircleWidth>bw){
                zoolMap.aspCircleWidth=bw
            }
        }
        let maxPos=0
        let num=0
        for(var i=0;i<zoolMap.aBodies.length;i++){
            let mp=xBodies.children[i].pos//zm.objBodiesCircle.getBodieWidth(i)
            if(mp>maxPos){
                maxPos=mp
                num=i
            }
        }
        bw=xBodies.children[num].width//zm.objBodiesCircle.getBodieWidth(i)
        if(bw<w){
            w=bw
        }
        zoolMap.aspCircleWidth-=((zoolMap.bodieSize*0.5)*maxPos*2)//+zoolMap.bodieSize
        for(i=0;i<zoolMap.aBodies.length;i++){
            bw=xBodies.children[i].width//zm.objBodiesCircle.getBodieWidth(i)
            if(zoolMap.aspCircleWidth-zoolMap.bodieSize<bw){
                zoolMap.aspCircleWidth=bw-zoolMap.bodieSize-1
            }
        }
    }
    function getBodie(index){
        return xBodies.children[index]
    }
    function getBodieWidth(index){
        return xBodies.children[index].width
    }
}
