import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml.StateMachine 1.12 as DSM // declarative state machine
import QtWebSockets 1.0


Window {
    id: client1
    visible: true
    width: 640
    height: 480
    title: qsTr("Client1")

    function appendMessage(message) {
        messageBox.text += "\n" + message
    }





    /////////test state machine://///////

// idée: changer d'état pour passer du lobby à la grille: echec

    Button {

           id: button
           y: parent.height - height
           Text {

               text: qsTr("Change state")
           }
           // change the button label to the active state id
           //Text: s1.active ? "s1" : s2.active ? "s2" : "s3"
           // ça vient de l'exemple mais ça ne marche pas....
       }

       DSM.StateMachine {
           id: stateMachine
           // set the initial state
           initialState: s1

           // start the state machine
           running: true

           DSM.State {
               id: s1
               // create a transition from s1 to s2 when the button is clicked
               DSM.SignalTransition {
                   targetState: s2
                   signal: button.clicked
               }
               // do something when the state enters/exits
               onEntered:{
                   component_lobby.createObject(client1)
                   console.log("s1 entered")
               }
               onExited: console.log("s1 exited")
               // QUESTION: how to delete object ?
           }

           DSM.State {
               id: s2
               // create a transition from s2 to s3 when the button is clicked
               DSM.SignalTransition {
                   targetState: s3
                   signal: button.clicked
               }
               // do something when the state enters/exits
               onEntered: console.log("s2 entered")
               onExited: console.log("s2 exited")
           }
           DSM.State {
               id: s3
               // create a transition from s3 to s1 when the button is clicked
               DSM.SignalTransition {
                   targetState: s1
                   signal: button.clicked

               }

               // do something when the state enters/exits
               onEntered:{
                   component_grid.createObject(client1)
                   console.log("s3 entered")
               }


               onExited:{
//                   component_grid.destroy()
                   console.log("s3 exited")
               // QUESTION: How to destroy object?
               }
           }
       }


////////////////////////LOBBY/////////////////

Component{
    id: component_lobby
       Rectangle{
           id: lobby
           height: parent.height*0.5
           width: parent.width*0.5
           color: "grey"
           anchors.verticalCenter: parent.verticalCenter
           anchors.horizontalCenter: parent.horizontalCenter

           Text {
               id: textlobby
               text: qsTr("Lobby \n Cliquez ici pour vous connecter")
           }

           Button{
               text: qsTr("Connexion")
               anchors.verticalCenter: parent.verticalCenter
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked: indicator_busy.visible = true
           }

           BusyIndicator{
                id: indicator_busy
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height -100
                visible: false
           }
       }
}



    /////////////////////////////////


    /// Test de l'instanciation de composant//
    Button {
        id: addgrid
        text: "Add grid"
        onClicked: {
            component_grid.createObject(parent)
//            console.log("added:", bar.itemAt(bar.count - 1))
        }
    }

Component{
    id: component_grid
    Rectangle{
        id: rectangle_grid
        height: parent.height*0.5
        width: parent.width*0.5
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

    Window{
        visible: true
        width: 640
        height: 480
        title: qsTr("Client2")

        WebSocket {
            id: socket
            url: "ws://127.0.0.1:35479"
            active: true
            onTextMessageReceived: appendMessage(qsTr("Client received message: %1").arg(message))
            onStatusChanged: {
                if (socket.status == WebSocket.Error) {
                    appendMessage(qsTr("Client error: %1").arg(socket.errorString));
                } else if (socket.status == WebSocket.Closed) {
                    appendMessage(qsTr("Client socket closed."));
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {

                socket.sendTextMessage(qsTr("Hello Server!"));
                appendMessage( qsTr("Websocket adress: %1").arg(socket.url))
            }
            Text {

                text: qsTr("Clique ici pour envoyer un message au serveur")
            }
        }

        Text {
            id: messageBox
            text: qsTr("message box here")
        }
    }






}







