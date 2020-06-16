import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    Rectangle{
        id: rectangle_grid
        height: parent.height/2
        width: parent.width/2
//        color: "yellow"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Text {

//            text: qsTr("parent.width: %1, parent.height: %2",parent.width,parent.height)
        }
        Grid_truc{
            size: rectangle_grid.height/3 // size of a tile
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


    Column {
        width: 180
        height: 180
        padding: 1.5
        topPadding: 10.0
        bottomPadding: 10.0
        spacing: 5

        x : parent.width - width
        anchors.verticalCenter: parent.verticalCenter


        MessageLabel{
            width: parent.width - 2
            msgType: "debug"
        }
        MessageLabel {
            width: parent.width - 2
            message: "This is a warning!"
            msgType: "warning"
        }
        MessageLabel {
            width: parent.width - 2
            message: "A critical warning!"
            msgType: "critical"
        }
    }
}
