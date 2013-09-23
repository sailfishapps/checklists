import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog
  {
  property string inputValue
  property alias text : label.text
  property alias defaultText : textField.placeholderText
  Text
   {
   wrapMode : Text.Wrap
   id : label
   anchors.left : parent.left
   anchors.right : parent.right
   y : 80
   color : Theme.highlightColor  //"#FFFFFF"
   text : "error"
   }

  TextField
     {
     id: textField
     anchors.top : label.bottom
     width: 480
     color : Theme.highlightColor  //"#FFFFFF"
     placeholderColor : Theme.secondaryHighlightColor
     validator: RegExpValidator { regExp: /.{0,20}/ }
     }
  onAccepted : inputValue = textField.text
  }
