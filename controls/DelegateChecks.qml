//model.modelData.checked is the c++ data checked is the local QML value: need to be synced
//model.modelData.checkItem is the c++ data checkItem is the local QML value: need to be synced

import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
id : delegateBoxChecks
property bool checked : false
property string orange : "#FFBF22"
property string yellow : "#FFFF00"
radius : 6
border.width : 1
border.color : Theme.highlightColor

width : listWidgetCheck.width - 10//listWidget.width
height : childrenRect.height
antialiasing : true

Image
 {
 id : img
 visible : model.modelData.checked ? true : false
 anchors.left : parent.left
 source: "check.png"
 }

Component.onCompleted: {
gradient = Qt.binding(function()
{
    if (model.modelData.checked) return green
    else return red
});
}
Gradient
    { // This sets a vertical gradient fill
    id : green
    GradientStop { position: 0.0; color: "#00FF00" }
    GradientStop { position: 1.0; color: "#008800" }
    }
Gradient
    { // This sets a vertical gradient fill
    id : red
    GradientStop { position: 0.0; color: "#FF0000" }
    GradientStop { position: 1.0; color: "#B50000" }
    }
       MouseArea
       {
       anchors.fill: parent
       onClicked:
           {
           if (model.modelData.checked)
            {
            checked = false
            }
           else
            {
            checked = true
            }

           appWin.myQmlListBoxSignal(delegateBoxChecks.ListView.view.listViewNr, model.modelData.checkItem, delegateBoxChecks.ListView.view.count, checked, index)//sync with c++
           }
       }
 Text
    {
        wrapMode : Text.Wrap

        anchors.left : img.right
        anchors.right : parent.right
        lineHeightMode :Text.ProportionalHeight
        lineHeight : 1.2
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeMedium
        font.bold : true
        color : "#000000"
        text: model.modelData.checkItem
    }

}
