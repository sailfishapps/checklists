import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
    id : textEditPage
    property string errorMsg : ""
    property bool saveFailed : false
    function setText(textIn) {edit.text = textIn}
    property bool rejectName : false
    property string rejectedFileName : ""

    onStatusChanged :
    {
    if (status === PageStatus.Active)//after (re)entering this page
     {
     if (rejectName)
      {
      var acceptDialog = pageStack.push("MMessageDialog.qml", {text : "DO YOU WANT TO OVERWRITE:\n" + rejectedFileName}, PageStackAction.Immediate)
      acceptDialog.accepted.connect(
      function()
         {
          if (myqquickview.save(rejectedFileName, edit.text) !== 0)
          {
          saveFailed = true;
          }
         saveMenu.enableMenu(true)
         newMenu.enableMenu(true)
         rejectName = false
         rejectedFileName = ""
         })
      acceptDialog.rejected.connect(
      function()
         {
          rejectName = false
          rejectedFileName = ""
         })
      }
     if (saveFailed)
      {
      var errorDialog = pageStack.push("MMessageDialog.qml", {text : "FATAL ERROR: CANNOT SAVE.\nSHUTTING DOWN\n"}, PageStackAction.Immediate)
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
    if (status === PageStatus.Deactivating)//leaving this page
     {
     rejectedFileName = ""
     rejectName = false
     saveMenu.enableMenu(true)
     newMenu.enableMenu(true)
     }
    }


 Flickable {
     id: flick
     y : 80
     width : 450
     height : 370

     contentWidth: edit.paintedWidth
     contentHeight: edit.paintedHeight
     clip: true
     function ensureVisible(r)
     {
         if (contentX >= r.x)
             contentX = r.x;
         else if (contentX+width <= r.x+r.width)
             contentX = r.x+r.width-width;
         if (contentY >= r.y)
             contentY = r.y;
         else if (contentY+height <= r.y+r.height)
             contentY = r.y+r.height-height;
     }

     TextEdit {
         id: edit
         width: flick.width
         height: flick.height
         focus: true
         wrapMode: TextEdit.Wrap
         onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
         font.family: Theme.fontFamily
         font.pixelSize: Theme.fontSizeTiny
         font.bold : true
         color : Theme.highlightColor  //"#FFFFFF"
         opacity : 1.0
         text : "ERROR"
     }
  }

 SilicaListView
   {
   anchors.fill: parent
   contentHeight: childrenRect.height
   opacity : 1.0
   PullDownMenu
      {
       id : pullDownMenu
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
        id : newMenu
        text: "NEW"
        onClicked:
         {
         textEditPage.setText("*header1*\ncheck1\check2")
         saveMenu.enableMenu(false)
         enableMenu(false)
         }
        }
   MMenuItem
        {
        id : saveMenu
        text: "SAVE"
        onClicked:
          {
          if (myqquickview.save("", edit.text) !== 0)
            {PageStackAction.Immediate
            }

          }
        }
   MMenuItem
        {
        text: "SAVE AS"
        onClicked:
         {
         runSaveAsDialog("ENTER AIRCRAFT NAME FOR CURRENT CHECKLISTS")
         }
        }
   }
}

function runSaveAsDialog(text)
 {
 var file = ""
 var saveDialog = pageStack.push("MyInputDialog.qml", {text: text, defaultText: "AIRCRAFT"}, PageStackAction.Immediate)
   saveDialog.accepted.connect(
      function()
       {
       if (myqquickview.fileExists(saveDialog.inputValue))
        {
        textEditPage.rejectName = true
        textEditPage.rejectedFileName = saveDialog.inputValue
        }
       else
        {
        if (myqquickview.save(saveDialog.inputValue, edit.text) !== 0)
           {
           //appWin.errorDialog("Fatal error. Failed to save.\nShutting down")
           }
        saveMenu.enableMenu(true)
        newMenu.enableMenu(true)
        }
       })
 }

}
