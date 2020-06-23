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

    WebSocketServer {  id: server
        property var object_tab_player : [] // contains all connected players
        property var someObject: Rectangle { width: 100; height: 100; color: "red" }
        listen: true
        port: 35479
        onClientConnected: {
            appendMessage(qsTr("New client ! : websocket: %1").arg(webSocket))
            webSocket.onTextMessageReceived.connect(function(message) {
                var message_json = JSON.parse(message);
                if (message_json.command === "register")
                {
                    // register new player
                    message_json.websocket = webSocket
                    object_tab_player.push(message_json)
                    webSocket.sendTextMessage(qsTr("Hello Client!\n Your name is %1").arg(object_tab_player[object_tab_player.length-1].name));

                    // if second player registered :
                    if (object_tab_player.length >= 2)
                    {
                        // send: "opponent found" to players
                        // second player:
                        var previous_player = object_tab_player[object_tab_player.length-2].name
                        var myObj = {command: "Duel", opponent_name: previous_player};
                        var myJSON = JSON.stringify(myObj);
                        webSocket.sendTextMessage(myJSON)

                        // first player:
                        myObj.opponent_name = message_json.name
                        myJson = JSON.stringify(myObj)
                        object_tab_player[object_tab_player.length -1].websocket.sendTextMessage(myJson)
                    }
                }



            });
        }
        onErrorStringChanged: {
            appendMessage(qsTr("Server error: %1").arg(errorString));
        }
    }

    Text {
        id: messageBox
        text: qsTr("this is the message box server")
    }

//    TabBar {
//          id: bar
//          width: parent.width
//          TabButton {
//              text: qsTr("Log")
//              Text {
//                  id: messageBox
//                  text: qsTr("Click to send a message!")

//                  anchors.fill: parent


//              }
//          }
//          TabButton {
//              text: qsTr("Discover")
//          }
//          TabButton {
//              text: qsTr("Activity")
//          }
//      }

//    Button {
//        id: addButton2
//        text: "+"
//        flat: true
//        onClicked: {
//            bar.addItem(barButton.createObject(bar))
//            console.log("added:", bar.itemAt(bar.count - 1))
//        }
//    }

//    Component {
//        id: barButton
//        TabButton { text: "TabButton" }
//    }

}
