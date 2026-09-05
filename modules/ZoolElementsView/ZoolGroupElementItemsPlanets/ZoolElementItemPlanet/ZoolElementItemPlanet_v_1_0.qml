import QtQuick 2.0
import QtQuick.Effects

Rectangle{
    id: r
    width: r.fs*6
    height: r.fs*1.5
    border.width: 1
    border.color: apps.backgroundColor
    color: 'transparent'//app.signColors[numElement]
    radius: r.fs*0.25
    property int fs: app.fs*6
    property int numElement: 0
    property var aElements: ["Fuego", "Tierra", "Aire", "Agua"]
    property string element: aElements[numElement]
    property string arrayPlanets: ''
    onArrayPlanetsChanged: {
        rep.model=arrayPlanets.split('|')
    }
    Row{
        id: row
        spacing: app.fs*0.5//r.sizeValue*0.01
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Repeater{
            id: rep
            //model: arrayPlanets.split('|')
            Item{
                width: r.fs
                height: width
                anchors.verticalCenter: parent.verticalCenter
                //visible: modelData
                Image{
                    id: img
                    //source: modelData?'../../resources/imgs/planetas/'+app.planetasRes[modelData]+'.svg':''
                    source: modelData?'../../../../imgs/planetas/'+app.planetasRes[modelData]+'.svg':''
                    //source: '../../../../resources/imgs/planetas/jupiter.svg'
                    anchors.fill: parent
                }
                MultiEffect {
                    id: co
                    anchors.fill: img
                    source: img

                    // 1. Convertimos el negro en algo "teñible" subiendo el brillo
                    // Un brillo de 1.0 convierte el negro en blanco (valor 1.0)
                    brightness: 1.0

                    // 2. Aplicamos la colorización al 100%
                    colorization: 1.0
                    colorizationColor: app.signColors[numElement]

                    autoPaddingEnabled: true
                }
                /*ColorOverlay {
                    id: co
                    anchors.fill: img
                    source: img
                    color: app.signColors[numElement]
                    antialiasing: true
                }*/
            }
        }
    }
}


