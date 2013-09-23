import QtQuick 2.0
import "../controls"
import Sailfish.Silica 1.0

Page
{
id : fileDialog
property alias listbox : fileListWidget
property bool ready : false

Text
 {
 color : Theme.highlightColor  //"#FFFFFF"
 font.family: Theme.fontFamily
 font.pixelSize: Theme.fontSizeMedium
 font.bold : false
 wrapMode : Text.Wrap
 id : label
 anchors.left : parent.left
 anchors.right : parent.right
 y : 80
 text : "SELECT AN AIRCRAFT"
 }


Listbox //main list
{
 id : fileListWidget
 delegate : delegateComponent
 listNr : 1
 model: fileNames
 y : 80
 anchors.top : label.bottom
 anchors.bottom : parent.bottom
 width: parent.width;
 focus: true
 clip: true
}

Component
{
id : delegateComponent
Rectangle
{
id : delegateFiles
property string yellow : "#FFFF00"
property bool checked : false
radius : 8
border.width : 1
border.color : Theme.highlightColor
width : fileListWidget.width-10
height : childrenRect.height
gradient: model.modelData.checked ? green : orange


Gradient
    { // This sets a vertical gradient fill
    id : green
    GradientStop { position: 0.0; color: "#00FF00" }
    GradientStop { position: 1.0; color: "#008800" }
    }
Gradient
    { // This sets a vertical gradient fill
    id : orange
    GradientStop { position: 0.0; color: "#FFBF22" }
    GradientStop { position: 1.0; color: "#E19800" }
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
           delegateFiles.gradient = red
           if (! myqquickview.handlemyQmlFileSelected(model.modelData.checkItem))
            {
            var errorDialog = pageStack.push("MMessageDialog.qml", {text : "FATAL ERROR:\nCANNOT LOAD CHECKLISTS\nOR CHECKLISTS ARE EMPTY.\nSHUTTING DOWN\n"}, PageStackAction.Immediate)

            errorDialog.accepted.connect(
             function()
              {
               myqquickview.shutDown()
              })
            errorDialog.rejected.connect(
             function()
              {
               myqquickview.shutDown()
              })
            }
           }
       }
 Image
     {
     id : img
     //index
     visible : model.modelData.checked ? true : false
     anchors.left : parent.left
     source: "check.png"
     }

 Text
  {
        wrapMode : Text.Wrap
        //width : 280
        anchors.left : img.right
        anchors.right : parent.right
        lineHeightMode :Text.ProportionalHeight
        lineHeight : 1.2
        //color : delegateBox.ListView.isCurrentItem ? "black" : "white"
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeMedium
        font.bold : true
        color : "#000000" //"black"
        text : model.modelData.checkItem
    }
 }
}


SilicaListView
  {
  anchors.left : parent.left
  anchors.right : parent.right
  anchors.top : parent.top
  anchors.bottom : fileListWidget.top

  contentHeight: childrenRect.height
  opacity : 1.0
  PullDownMenu
     {
         highlightColor : "#00FF00"
         background: Rectangle
          {
          color : "#000000"
          anchors {
                  fill: parent
                  bottomMargin: parent.spacing
                  }
          opacity: 1.0
          }
          MMenuItem
          {
          text : "SHUT DOWN"
          onClicked:
          {
          myqquickview.shutDown()
          }
          }
  }
}


}
