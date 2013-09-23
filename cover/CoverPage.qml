import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {

    anchors.fill: parent
     Image
         {
         source: "dc3checklist.png"
         anchors.fill: parent
         smooth: true
         }
     Text {//Label
        id: label
        anchors.centerIn: parent
        text: "Checklists"
    }
}


