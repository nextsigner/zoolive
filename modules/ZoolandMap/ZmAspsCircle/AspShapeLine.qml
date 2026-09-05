import QtQuick 2.12
import QtQuick.Shapes 1.12

Rectangle{
    id: r
    width: parent.width
    height: parent.width
    color: 'transparent'
    radius: width*0.5

    property bool isBack: false
    property int n: 0
    property alias sx: sp.startX
    property alias sy: sp.startY
    property alias px: p.x
    property alias py: p.y
    property color c: 'red'
    Timer{
        running:  false//!r.isBack?(aspsCircle.currentAspSelected===r.n):(aspsCircleBack.currentAspSelected===r.n)
        //running:  aspsCircle.currentAspSelected===r.n
        repeat: true
        interval: 400
        onRunningChanged: {
            shapeBg.opacity=0.0
            r.z=0
            if(!r.isExt){
                zm.aspShowSelectedInt=false
            }else{
                zm.aspShowSelectedExt=false
            }
        }
        onTriggered: {
            if(shapeBg.opacity===1.0){
                shapeBg.opacity=0.0
                r.z=0
                if(!r.isExt){
                    zm.aspShowSelectedInt=false
                }else{
                    zm.aspShowSelectedExt=false
                }
                //zm.anv.n=''
            }else{
                shapeBg.opacity=1.0
                if(!r.isExt){
                    zm.aspShowSelectedInt=true
                }else{
                    zm.aspShowSelectedExt=true
                }
                r.z=r.parent.children.length+1
                //zm.anv.n=zm.objZoolAspectsView.uAspShowed
                //zm.anv.z=zm.anv.z+1000
            }
        }
    }

    Shape {
        id: shapeBg
        opacity: 0.0
        //anchors.fill: parent
        //width: !zm.ev?parent.width-apps.aspLineWidth:parent.width-apps.aspLineWidth*0.5//*1.8
        width: parent.width-apps.aspLineWidth
        height: width
        anchors.centerIn: parent
        containsMode: Shape.FillContains
        ShapePath {
            id: spBg
            strokeColor: apps.fontColor
            strokeWidth: apps.aspLineWidth*2
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            property int joinStyleIndex: 2
            property variant styles: [
                ShapePath.BevelJoin,
                ShapePath.MiterJoin,
                ShapePath.RoundJoin
            ]
            joinStyle: styles[joinStyleIndex]
            startX: r.sx
            startY: r.sy
            PathLine {id: pBg; x: p.x; y: py}
        }
    }
    Shape {
        id: shape
        width: parent.width-apps.aspLineWidth//*1.8
        height: width
        anchors.centerIn: parent
        containsMode: Shape.FillContains
        ShapePath {
            id: sp
            strokeColor: r.c
            strokeWidth: apps.aspLineWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle:  r.isBack?ShapePath.DashLine:ShapePath.SolidLine
            property int joinStyleIndex: 2
            property variant styles: [
                ShapePath.BevelJoin,
                ShapePath.MiterJoin,
                ShapePath.RoundJoin
            ]
            joinStyle: styles[joinStyleIndex]
            //startX: 0
            //startY: 0
            PathLine {id: p}
        }
    }


}
