import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Grid {
    id: gridLayout
    rows: 3
    columns: 3
//    flow: GridLayout.TopToBottom
//    anchors.fill: parent
    rowSpacing: 2
    columnSpacing: 2

//    property real ratio: width / 320 < height / 440 ? width / 320 : height / 440
    property int size: 100

   Rectangle{
       height: size
       width: size
       border.width: 1
//       HoverHandler{
////            onHoveredChanged: parent.color = "blue"
////            onHovered: parent.color = "blue"
////            if (hovered) parent.color = "blue"
//            hovered ? parent.color = "blue" : parent.color = "white"

//       }
       // Je n'ai pas réussi le hover de cette manière

       MouseArea{
           // y a t il un moyen d'affecter ça pour tous les rectangles ?
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }

   }

   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }

   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }



   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }
   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }
   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }


   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }
   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }
   Rectangle{
       height: size
       width: size
       border.width : 1

       MouseArea{
           onEntered: {
                parent.color = "blue"
           }

           onExited :{

               parent.color =  "white"

           }
           anchors.fill: parent
           onClicked: console.log("Clicked")
           hoverEnabled: true
       }
   }


}
