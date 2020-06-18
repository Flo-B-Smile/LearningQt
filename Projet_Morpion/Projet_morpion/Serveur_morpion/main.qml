import QtQuick 2.12
import QtQuick.Window 2.12
import QtWebSockets 1.0
import QtQuick.Controls 2.12

Window{
    visible: true
    width: 640
    height: 480
    title: qsTr("Serveur")


    function appendMessage(message) {
        messageBox.text += "\n" + message
    }

    WebSocketServer {
        id: server
        listen: true
        port: 35479
        onClientConnected: {
            webSocket.onTextMessageReceived.connect(function(message) {
                appendMessage(qsTr("Server received message: %1").arg(message));
                webSocket.sendTextMessage(qsTr("Hello Client!"));
            });
        }
        onErrorStringChanged: {
            appendMessage(qsTr("Server error: %1").arg(errorString));
        }
    }

    TabBar {
          id: bar
          width: parent.width
          TabButton {
              text: qsTr("Log")
              Text {
                  id: messageBox
                  text: qsTr("Click to send a message!")

                  anchors.fill: parent


              }
          }
          TabButton {
              text: qsTr("Discover")
          }
          TabButton {
              text: qsTr("Activity")
          }
      }

    Button {
        id: addButton2
        text: "+"
        flat: true
        onClicked: {
            bar.addItem(barButton.createObject(bar))
            console.log("added:", bar.itemAt(bar.count - 1))
        }
    }

    Component {
        id: barButton
        TabButton { text: "TabButton" }
    }

}
