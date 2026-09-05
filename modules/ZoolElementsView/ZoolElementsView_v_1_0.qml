import QtQuick 2.0
import ZoolElementsView.ZoolGroupElementItems 1.0

Rectangle{
    id: r
    width: parent.width//colZoolGroupElementItems.width+colZoolGroupElementItemsPlanets.width//+app.fs
    height: parent.height   //colZoolGroupElementItems.height+app.fs
    anchors.right: parent.right
    anchors.rightMargin: 0-width*0.75
    border.width: 0
    border.color:'yellow'
    color: 'transparent'
    anchors.centerIn: parent
    ZoolGroupElementItems{id: groupFront;}
    function load(json){
            groupFront.load(json)
    }
}
