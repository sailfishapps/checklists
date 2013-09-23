import QtQuick 2.0
import "../controls"
import Sailfish.Silica 1.0

Dialog
  {
  property alias text : label.text
  property string inputValue
  Text
   {
   id : label
   y : 80
   color : Theme.highlightColor  //"#FFFFFF"
   text : ""
   }
  }
