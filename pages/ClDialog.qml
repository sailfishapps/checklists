import QtQuick 2.0
import "../controls"
import Sailfish.Silica 1.0

Page//Rectangle
{
property alias listWidget: listWidget
property alias listWidgetCheck: listWidgetCheck

onStatusChanged :
 {
 if (status === PageStatus.Deactivating)
   {
    myqquickview.restart()
   }
 }

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
 text : "CHECKLIST:"
 }


 Listbox //main list
 {
  id : listWidget
  anchors.top : label.bottom
  delegate : DelegateList{}
  listNr : 1
  model: myCheckListHeadings
  anchors.left : parent.left
  width: parent.width;
  height : 250
  focus: true
  clip: true
 }

 Text
  {
  color : Theme.highlightColor  //"#FFFFFF"
  font.family: Theme.fontFamily
  font.pixelSize: Theme.fontSizeMedium
  font.bold : false
  anchors.top : listWidget.bottom
  wrapMode : Text.Wrap
  id : checksLabel
  anchors.left : parent.left
  anchors.right : parent.right
  y : 80
  text : "CHECKS:"
  }


 Listbox //item list
 {
  id : listWidgetCheck
  delegate : DelegateChecks{}
  listNr : 2
  visible : true
  model : myCheckListItems//ContactModel {}
  anchors.left : parent.left
  anchors.top : checksLabel.bottom
  anchors.bottom : parent.bottom
  width: parent.width;
  focus: true
  clip: true
 }

 SilicaListView
   {
   anchors.left : parent.left
   anchors.right : parent.right
   anchors.top : parent.top
   anchors.bottom : listWidget.top

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
          text: "SHUT DOWN"
          onClicked:
          {
          myqquickview.shutDown()
          }
       }
      MMenuItem
       {
       property int buttonNr : 1
       text: "EDIT"
       onClicked: appWin.mButtonSignal(buttonNr)
       }
    }
 }
}
