import QtQuick 2.0
import ZoolandMap.ZmHousesCircle.ZmHouseArc 1.0
Rectangle{
    id: r
    width: parent.width
    height: width
    color: 'transparent'
    border.width: 0//10
    border.color: 'blue'
    radius: width*0.5
    anchors.centerIn: parent
    property bool isExt: false

    Item{
        id: xHouses
        anchors.fill: parent
        Repeater{
            model: 12
            ZmHouseArc{
                width: r.width
                height: width
                rotation: (360-(30*index))//+180
                ih: index
                isExt: r.isExt
                anchors.centerIn: parent
            }
        }
    }
    function load(j){
        for(var i=0;i<12;i++){
            //xHouses.children[i].rotation=360-(360-j.ph['h1'].gdec)-j.pc['c'+i].gdec
            if(!r.isExt){
                xHouses.children[i].rotation=0-360-(j.ph['h'+parseInt(i + 1)].gdec)+j.ph['h1'].gdec
            }else{
                xHouses.children[i].rotation=0-360-(j.ph['h'+parseInt(i + 1)].gdec)+zoolMap.zm.objSignsCircle.rotation
                //xHouses.children[i].rotation=0-360-(j.ph['h'+parseInt(i + 1)].gdec)+j.ph['h1'].gdec+zoolMap.zm.objSignsCircle.rotation//app.currentJson.ph['h1'].gdec
            }

        }
    }
}
