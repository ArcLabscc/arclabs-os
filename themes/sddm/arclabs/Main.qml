import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    
    property color accent: "#00ff99"
    property color background: "#0d1117"
    property color foreground: "#e0e0e0"
    property color inputBg: "#161b22"
    property color inputBorder: "#30363d"
    
    color: background
    
    // Background image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        visible: status === Image.Ready
    }
    
    // Dark overlay
    Rectangle {
        anchors.fill: parent
        color: background
        opacity: backgroundImage.visible ? 0.75 : 1.0
    }
    
    // Clock (top right)
    Column {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 40
        spacing: 5
        
        Text {
            id: clock
            anchors.right: parent.right
            color: foreground
            opacity: 0.7
            font.family: "JetBrains Mono"
            font.pixelSize: 48
            
            function updateTime() {
                text = Qt.formatDateTime(new Date(), "HH:mm")
            }
            
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.updateTime()
            }
            
            Component.onCompleted: updateTime()
        }
        
        Text {
            anchors.right: parent.right
            color: foreground
            opacity: 0.4
            font.family: "JetBrains Mono"
            font.pixelSize: 14
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        }
    }
    
    // Center container
    Column {
        anchors.centerIn: parent
        spacing: 15
        
        // Simple text logo
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "ARCLABS"
            color: accent
            font.family: "JetBrains Mono"
            font.pixelSize: 42
            font.bold: true
            font.letterSpacing: 8
        }
        
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "OS"
            color: foreground
            opacity: 0.6
            font.family: "JetBrains Mono"
            font.pixelSize: 24
            font.letterSpacing: 12
        }
        
        // Subtitle
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "ARM64 Linux for Apple Silicon"
            color: foreground
            opacity: 0.4
            font.family: "JetBrains Mono"
            font.pixelSize: 12
        }
        
        // Spacer
        Item { width: 1; height: 40 }
        
        // Username field
        Rectangle {
            width: 320
            height: 50
            color: inputBg
            border.color: userField.activeFocus ? accent : inputBorder
            border.width: 2
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            
            TextInput {
                id: userField
                anchors.fill: parent
                anchors.margins: 15
                color: foreground
                font.family: "JetBrains Mono"
                font.pixelSize: 16
                text: userModel.lastUser
                selectByMouse: true
                clip: true
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "username"
                    color: foreground
                    opacity: 0.3
                    font: parent.font
                    visible: parent.text === ""
                }
                
                Keys.onReturnPressed: passwordField.forceActiveFocus()
                Keys.onTabPressed: passwordField.forceActiveFocus()
            }
        }
        
        // Password field
        Rectangle {
            width: 320
            height: 50
            color: inputBg
            border.color: passwordField.activeFocus ? accent : inputBorder
            border.width: 2
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            
            TextInput {
                id: passwordField
                anchors.fill: parent
                anchors.margins: 15
                color: foreground
                font.family: "JetBrains Mono"
                font.pixelSize: 16
                echoMode: TextInput.Password
                selectByMouse: true
                clip: true
                
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "password"
                    color: foreground
                    opacity: 0.3
                    font: parent.font
                    visible: parent.text === ""
                }
                
                Keys.onReturnPressed: login()
            }
        }
        
        // Login button
        Rectangle {
            width: 320
            height: 50
            color: loginMouse.pressed ? Qt.darker(accent, 1.3) : (loginMouse.containsMouse ? accent : Qt.darker(accent, 1.1))
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            
            Text {
                anchors.centerIn: parent
                text: "LOGIN"
                color: background
                font.family: "JetBrains Mono"
                font.pixelSize: 14
                font.bold: true
                font.letterSpacing: 4
            }
            
            MouseArea {
                id: loginMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: login()
            }
        }
        
        // Error message
        Text {
            id: errorMessage
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#ff5555"
            font.family: "JetBrains Mono"
            font.pixelSize: 14
            visible: text !== ""
        }
    }
    
    // Session info (bottom left)
    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 30
        text: "hyprland-uwsm"
        color: foreground
        opacity: 0.3
        font.family: "JetBrains Mono"
        font.pixelSize: 11
    }
    
    // Power buttons (bottom right)
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        spacing: 25
        
        Text {
            text: "reboot"
            color: rebootMouse.containsMouse ? accent : foreground
            opacity: rebootMouse.containsMouse ? 1.0 : 0.3
            font.family: "JetBrains Mono"
            font.pixelSize: 11
            
            MouseArea {
                id: rebootMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.reboot()
            }
        }
        
        Text {
            text: "shutdown"
            color: shutdownMouse.containsMouse ? accent : foreground
            opacity: shutdownMouse.containsMouse ? 1.0 : 0.3
            font.family: "JetBrains Mono"
            font.pixelSize: 11
            
            MouseArea {
                id: shutdownMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sddm.powerOff()
            }
        }
    }
    
    function login() {
        errorMessage.text = ""
        sddm.login(userField.text, passwordField.text, 0)
    }
    
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "login failed"
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
    }
    
    Component.onCompleted: {
        if (userField.text !== "") {
            passwordField.forceActiveFocus()
        } else {
            userField.forceActiveFocus()
        }
    }
}
