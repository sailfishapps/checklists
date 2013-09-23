import QtQuick 2.0
import Sailfish.Silica 1.0


Rectangle
{
property alias listBox : listBox
property alias model : listBox.model
property alias listNr : listBox.listViewNr
property alias delegate : listBox.delegate
property string orange : "#FFBF22"
property string yellow : "#FFFF00"

border.width : 2
border.color : Theme.secondaryHighlightColor//"green"//"#FFFF00"
color : Theme.secondaryHighlightColor
radius : 4

 ListView
     {
     highlightFollowsCurrentItem : true
     id: listBox
     property int current : 0
     function setAtBegin()
     {
      positionViewAtIndex(0, ListView.Beginning)
      return true
     }

     function setInMid(nr)
     {
      positionViewAtIndex (nr , ListView.Center)
      current = nr
      return true
     }

     property int listViewNr : 0
     anchors.margins : 4
     anchors.top : parent.top//oKbutton.bottom
     anchors.left : parent.left
     anchors.right : parent.right
     anchors.bottom : parent.bottom
     focus: true
     clip: true
     }
}
