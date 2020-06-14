import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12



//import related modules
//https://doc.qt.io/qt-5/qmlfirststeps.html
//window containing the application
ApplicationWindow {

    //title of the application
    visible: true // by default not visible ....
    title: qsTr("Hello World")
    width: 640
    height: 480

    //menu containing two menu items
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    //Content Area

    //a button in the middle of the content area
    Button {
        text: qsTr("Hello World")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
                  implicitWidth: 100
                  implicitHeight: 40
                  opacity: enabled ? 1 : 0.3
                  border.color: parent.down ? "#17a81a" : "#21be2b"
                  border.width: 1
                  radius: 20
              }
    }


    Button {
        text: qsTr("Bouton normal")
        anchors.horizontalCenter:  parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalDown
        // there must be an equivalent but I didn't find it
    }


    // Rectangles and signals
    Rectangle{
        Text{
            text: qsTr("Click to change color")
            anchors.centerIn: parent
        }

        width: 200
        height: 100
        color: "red"
        TapHandler {
               onTapped: parent.color = "blue"
           }
    }

    Rectangle {
        width: 200
        height: 100
        color: "Yellow"
//        anchors.horizontalCenter:  parent.horizontalCenter
        //property Binding
        x: parent.width - width


        Text {
            anchors.centerIn: parent
            text: "push enter to change color"
        }

        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Return) {
                color = "blue";
                event.accepted = true;
            }
        }
    }

    //////////Animation/////////

    Rectangle {
        color: "lightgray"

        width: 200
        height: 100
        y: parent.height - height

        property int animatedValue: 0
        SequentialAnimation on animatedValue {
            loops: Animation.Infinite
            PropertyAnimation { to: 150; duration: 1000 }
            PropertyAnimation { to: 0; duration: 1000 }
        }

        property int animatedxpos: 0
        SequentialAnimation on animatedxpos{
            loops: Animation.Infinite
            PropertyAnimation {to:  width - 200 ; duration: 2000}
//            PropertyAnimation {to:  width - parent.width ; duration: 2000}
            // je ne comprends pas : je ne peux pas accéder à parent ici
            PropertyAnimation {to: 0; duration: 1000}
        }

        x: animatedxpos
        Text {
            anchors.centerIn: parent
            text: parent.animatedValue
        }
    }

    //////////////REUSE of code ///////////

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
