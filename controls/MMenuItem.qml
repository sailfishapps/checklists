import QtQuick 2.0
import "../controls"
import Sailfish.Silica 1.0

MenuItem
 {
 font.family: Theme.fontFamily
 font.pixelSize: Theme.fontSizeMedium
 onHighlightedChanged:
      {
      if (highlighted)
       {
       color = "#FF0000"
       font.bold = true
       }
      else
       {
       font.bold = false
       if (enabled)
         {
         color = "#FFFFFF"
         }
       else
         {
         color = "#888888"
         }
       }
      }
 color : enabled ? "#FFFFFF" : "#888888"
 font.bold : highlighted ? true : false

 function enableMenu(bool)
  {
    if (bool)
     {
     color = "#FFFFFF"
     enabled = true
     }
    else
     {
     color = "#888888"
     enabled = false
     }
  }
}
