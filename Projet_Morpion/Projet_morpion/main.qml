import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml.StateMachine 1.12 as DSM // declarative state machine
import QtWebSockets 1.0
import QtQuick.Layouts 1.12


Window {
    id: client1
    visible: true
    width: 640
    height: 480
    title: qsTr("Client1")

    function appendMessage(message) {
        messageBox.text += "\n" + message
    }

    function change_text()
    {
        textlobby.text = "En attente d'un adversaire.."
    }



    /////////test state machine://///////



    Button {

        id: button
        y: parent.height - height
        Text {

            text: qsTr("Change state")
        }
    }


    ColumnLayout{
        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        TextField{ id: pseudo_field
            text: ""
            placeholderText: "Enter pseudo here"
        }

        Button{ id: enter_button

            Layout.alignment: Qt.AlignCenter

            Text {
                anchors
                {

                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                text: qsTr("OK")
            }
        }
    }



    DSM.StateMachine { id: stateMachine

        // set the initial state
        initialState: s0
        property QtObject composant: null
        // start the state machine
        running: true

        DSM.State { id : s0
            //First state
            DSM.SignalTransition {
                targetState: s1
                signal: enter_button.clicked
            }
        }

        DSM.State { id: s1

            // create a transition from s1 to s2 when the button is clicked
            DSM.SignalTransition {
                targetState: s2
                signal: socket.connexion_open
                //                signal: button.clicked
            }
            // do something when the state enters/exits
            onEntered:{
                composant = component_lobby.createObject(client1)
                console.log("s1 entered")
            }

            onExited:{

                console.log("s1 exited")
            }
        }

        DSM.State { id: s2

            // Attente d'adversaire
            DSM.SignalTransition {
                targetState: s3
                signal: socket.opponent_found
            }
            // do something when the state enters/exits
            onEntered: {

                console.log("s2 entered")
            }
            onExited:{
                composant.destroy()
                console.log("s2 exited")
            }
        }
        DSM.State { id: s3
            property QtObject grid: null
            // create a transition from s3 to s1 when the button is clicked
            DSM.SignalTransition {
                targetState: s1
                signal: button.clicked
            }

            // do something when the state enters/exits
            onEntered:{
                grid =  component_grid.createObject(client1)
                console.log("s3 entered")
            }
            onExited:{
                grid.destroy()
                console.log("s3 exited")
                // QUESTION: How to destroy object?
            }
        }
    }


    ////////////////////////LOBBY/////////////////

    Component{ id: component_lobby



        Rectangle{ id: lobby


            height: parent.height*0.5
            width: parent.width*0.5

            anchors{
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            color: "white"

            Component.onCompleted:{
                indicator_busy.visible = true
                timer_retry.running = true
                socket.active = true
            }


            Text {
                id: textlobby
                anchors{
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                text: qsTr("Connexion au serveur en cours")
            }


            BusyIndicator{
                id: indicator_busy
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height -100
                visible: false
            }
            Timer {
                id: timer_retry
                interval: 2000; running: false; repeat: true
                onTriggered: socket.active = true
            }

            Connections{
                target: socket
                onConnexion_open: {
                    textlobby.text = "attente adversaire"
                    timer_retry.running = false
                }
            }
        }
    }


    ////////////WebSocket//////////


    WebSocket {
        id: socket
        signal connexion_open()
        signal opponent_found()
        url: "ws://127.0.0.1:35479"
        active: false
        onTextMessageReceived:{

            // if receive message new player ready : go to s3 : duel
            var message_json = JSON.parse(message);
            if (message_json.command === "Duel")
            {
                socket.opponent_found()
            }

        }
        onStatusChanged: {
            var pseudo
            if (socket.status == WebSocket.Error) {
                appendMessage(qsTr("Client error: %1").arg(socket.errorString));
            } else if (socket.status == WebSocket.Closed) {
                active = false
                appendMessage(qsTr("Client socket closed."));
            } else if (socket.status == WebSocket.Open) {
                appendMessage(qsTr("Client connected to server"))
                socket.connexion_open()
                // Go to s2 : attente adversaire
                // Send register message to server with name in JSON
                if (pseudo_field.text != "")
                {
                    pseudo = pseudo_field.text
                }
                else
                {
                    pseudo = "joueur1"
                }

                var myObj = {name:pseudo , command: "Register"};
                var myJSON = JSON.stringify(myObj);
                socket.sendTextMessage(myJSON);

                //            component_lobby.textlobby.text = "En attente d'un adversaire.."

            }
        }

    }



    //////////////////////////



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


    // TEST MESSAGE LABEL ///////////
    //    Column {
    //        width: 180
    //        height: 180
    //        padding: 1.5
    //        topPadding: 10.0
    //        bottomPadding: 10.0
    //        spacing: 5

    //        x : parent.width - width
    //        anchors.verticalCenter: parent.verticalCenter


    //        MessageLabel{
    //            width: parent.width - 2
    //            msgType: "debug"
    //        }
    //        MessageLabel {
    //            width: parent.width - 2
    //            message: "This is a warning!"
    //            msgType: "warning"
    //        }
    //        MessageLabel {
    //            width: parent.width - 2
    //            message: "A critical warning!"
    //            msgType: "critical"
    //        }


    //    }




    Window{
        visible: true
        width: 640
        height: 480
        title: qsTr("Client test")

        Component.onCompleted:{
            var myObj = {name: "John", age: 31, city: "New York"};
            var myJSON = JSON.stringify(myObj);
            console.log("completed truc")

        }


        WebSocket {
            id: socket2
            url: "ws://127.0.0.1:35479"
            active: true
            onTextMessageReceived: appendMessage(qsTr("Client received message: %1").arg(message))
            onStatusChanged: {
                if (socket2.status == WebSocket.Error) {
                    appendMessage(qsTr("Client error: %1").arg(socket2.errorString));
                } else if (socket2.status == WebSocket.Closed) {
                    active = false
                    appendMessage(qsTr("Client socket closed."));
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                socket2.active = true
                var myObj = {name: "John", age: 31, city: "New York"};
                var myJSON = JSON.stringify(myObj);
                socket2.sendTextMessage(qsTr("Hello Server! get json: "));
                socket2.sendTextMessage(myJSON);
                //                appendMessage( qsTr("Websocket adress: %1").arg(socket2.url))
            }
            Text {

                text: qsTr("Clique ici pour envoyer un message au serveur")
            }
        }

        Text {
            id: messageBox
        }



    }


}







