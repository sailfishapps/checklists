import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "controls"

ApplicationWindow
{
    property string warnColor : "red" //Theme.highlightColor
    allowedOrientations : "Portrait" | "Landscape"
    id: appWin
    onApplicationActiveChanged :
    {
     myqquickview.fullRestart();
    }
    //onStateChanged: { console.log("onStateChanged")}
    //onActiveFocusChanged: console.log("onActiveFocusChanged")
    initialPage: MFiledialog {}// {}//MFiledialog {} //SecondPage {}
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    function myQmlFunction(msg)
      {
//      console.log("Got message:", msg)
      myQmlSignal(0, 5555);
      return "some return value"
      }

    signal myQmlListBoxSignal(int listNr, string name, int total, bool checked, int currentIndex)
    signal mButtonSignal(int buttonNr)

    function loadTextEdit(text)
        {
        pageStack.replaceAbove(pageStack.previousPage(), Qt.resolvedUrl("controls/MTextEdit.qml"))
        pageStack.currentPage.setText(text)
        return true;
        }

    function errorDialog(errtext)
        {
        var errorDialog = pageStack.push("./controls/MMessageDialog.qml", {text : errtext}, PageStackAction.Immediate)

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
        return 0;
        }


    function showCheckLists()
     {
     pageStack.push(Qt.resolvedUrl("pages/ClDialog.qml"))
     return true
     }


    function setAtBegin(listNr)
    {if (listNr === 1)
        {return (pageStack.currentPage.listWidgetlistWidget.listBox.setAtBegin())}
     else
        {return (pageStack.currentPage.listWidgetCheck.listBox.setAtBegin())}
     }

    function setInMid(listNr, nr)
     {
     if (listNr === 0)
      {
      return (pageStack.currentPage.fileDialog.listbox.setInMid(nr))
      }
     else if (listNr === 1)
      {
      return (pageStack.currentPage.listWidget.listBox.setInMid(nr))
      }
     else
      {return (pageStack.currentPage.listWidgetCheck.listBox.setInMid(nr))}
     }

    function ready(msg)
     {
     pageStack.pop(initialPage, PageStackAction.Immediate)
     var dialog = pageStack.push("./controls/MMessageDialog.qml", {text : msg}, PageStackAction.Immediate)
     initialPage.ready = true
     }




}


