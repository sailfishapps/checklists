import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
id : delegateBoxLists
property bool checked : false
radius : 8
border.width : 1
gradient : red
//gradient = yellow


Image
 {
 id : img
 visible : model.modelData.checked ? true : false
 anchors.left : parent.left
 source: "check.png"
 }

Component.onCompleted:
{ //fired when listItem data changes from within C++
    if (model.modelData.checked)
     {gradient = green}
    else
     {
     if(delegateBoxLists.ListView.view.current === index)
      {gradient = yellow}
     }
}

border.color : Theme.highlightColor//yellow
width : listWidget.width-10
height : childrenRect.height
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
Gradient
    { // This sets a vertical gradient fill
    id : yellow
    GradientStop { position: 0.0; color: "#FFFF00" }
    GradientStop { position: 1.0; color: "#FFFF00" }
    }

MouseArea
    {
    anchors.fill: parent
    onClicked:
     {
     delegateBoxLists.ListView.view.current = index
     appWin.myQmlListBoxSignal(delegateBoxLists.ListView.view.listViewNr, model.modelData.checkItem, delegateBoxLists.ListView.view.count, checked, index)
     }
    }

 Text
    {
    id : delListText
    wrapMode : Text.Wrap
    anchors.left : img.right
    anchors.right : parent.right
    lineHeightMode :Text.ProportionalHeight
    lineHeight : 1.2
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeMedium
    font.bold : true
    color : "#000000" //"black"
    text: model.modelData.checkItem
    }
}
