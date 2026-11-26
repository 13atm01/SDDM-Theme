// ╔═══════════════════════════════════════════════════════════════════════════════╗
// ║Edit carefully, I’ve included title and description tags to make the editing   ║
// ║process easier for you. Also, don’t forget to include the copyright information║
// ║in the “copyright” tag. For example, if you’re creating a theme based on an    ║
// ║anime or game, be sure to mention the title and the character name.            ║
// ║                                                                               ║
// ║                     ©13atm01 alias Andi Trisna Mukti                         ║
// ╚═══════════════════════════════════════════════════════════════════════════════╝
import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0
import "components"

Rectangle {
    id: root
    width: 1920
    height: 1080

    property color cPanel:  (config && config.panelColor)  ? config.panelColor  : "#ffffff"
    property color cAccent: (config && config.accentColor) ? config.accentColor : "#e8943a"
    property color cText:   (config && config.textColor)   ? config.textColor   : "#2c3e50"
    property color cMuted:  (config && config.textMuted)   ? config.textMuted   : "#7f8c8d"
    property string fMain:  (config && config.fontMain)    ? config.fontMain    : "Exo 2"
    property string fClock: (config && config.fontClock)   ? config.fontClock   : "Orbitron"
    property string bgSrc:  (config && config.background)  ? config.background  : "Background.jpg"
    property int   pWidth:  (config && config.panelWidth)  ? parseInt(config.panelWidth)  : 440  // <-- width of the login panel
    property real  pOpacity:(config && config.panelOpacity)? parseFloat(config.panelOpacity): 0.18

    property int selectedSessionIndex: 0
    Component.onCompleted: {
        if (typeof sessionModel !== 'undefined' && sessionModel.lastIndex >= 0)
            root.selectedSessionIndex = sessionModel.lastIndex
    }

    // ===== BACKGROUND =====
    Image {
        anchors.fill: parent
        source: bgSrc
        fillMode: Image.PreserveAspectCrop
    }

    // ===== SNOW EFFECTS =====
    Canvas {
        id: snowCanvas
        anchors.fill: parent
        z: 1
        property var snowflakes: []
        property int maxSnowflakes: 120
        function initSnow() {
            snowflakes = []
            for (var i = 0; i < maxSnowflakes; i++)
                snowflakes.push({ x: Math.random()*width, y: Math.random()*height,
                    r: Math.random()*3+1, speed: Math.random()*1.5+0.5,
                                opacity: Math.random()*0.6+0.3, drift: Math.random()*0.5-0.25 })
        }
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            for (var i = 0; i < snowflakes.length; i++) {
                var f = snowflakes[i]
                ctx.beginPath()
                ctx.arc(f.x, f.y, f.r, 0, Math.PI*2)
                ctx.fillStyle = "rgba(255,255,255," + f.opacity + ")"
                ctx.fill()
                f.y += f.speed; f.x += f.drift + Math.sin(f.y*0.01)*0.3
                if (f.y > height) { f.y = -5; f.x = Math.random()*width }
                if (f.x > width) f.x = 0
                    if (f.x < 0) f.x = width
            }
        }
        Timer { interval: 16; running: true; repeat: true; onTriggered: snowCanvas.requestPaint() }
        Component.onCompleted: initSnow()
    }

    // ===== CLOCK + ORBIT EFFECT =====
    Item {
        id: clockOrbit
        anchors.top: parent.top; anchors.right: parent.right
        anchors.margins: 0
        width: 300; height: 170
        z: 10

        Item {
            id: orbitGroup
            anchors.fill: parent
            rotation: -12          // <-- slope angle

            Canvas {
                id: orbitCanvas
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    var cx = width / 2, cy = height / 2
                    var rx = width / 2 - 8, ry = height / 2 - 22
                    ctx.save()
                    ctx.translate(cx, cy)
                    ctx.scale(1, ry / rx)
                    ctx.beginPath()
                    ctx.arc(0, 0, rx, 0, 2 * Math.PI)
                    ctx.restore()
                    ctx.strokeStyle = "#7fb3d5"         // <-- color of the orbital ring
                    ctx.globalAlpha = 0.55
                    ctx.lineWidth = 2.5
                    ctx.stroke()
                    ctx.globalAlpha = 1.0
                }
            }

            // PLANET 1 (Orange)
            Rectangle {
                id: orbitDot1
                width: 9; height: 9; radius: 4.5
                color: cAccent              // <-- color of the planet
                Rectangle {
                    anchors.centerIn: parent
                    width: 20; height: 20; radius: 10
                    color: cAccent          // <-- color of the planet shadow
                    opacity: 0.35
                }
                property real t1: 0
                NumberAnimation on t1 {
                    from: 0; to: 2 * Math.PI
                    duration: 9000
                    loops: Animation.Infinite
                    running: true
                }
                x: (parent.width  / 2) + (parent.width  / 2 - 8)  * Math.cos(t1) - width  / 2
                y: (parent.height / 2) + (parent.height / 2 - 22) * Math.sin(t1) - height / 2
            }

            // PLANET 2 (Pink)
            Rectangle {
                id: orbitDot2
                width: 9; height: 9; radius: 4.5
                color: "#f988a9"            // <-- color of the planet
                Rectangle {
                    anchors.centerIn: parent
                    width: 20; height: 20; radius: 10
                    color: "#f988a9"        // <-- color of the planet shadow
                    opacity: 0.35
                }
                property real t2: 0
                NumberAnimation on t2 {
                    from: 0; to: 2 * Math.PI
                    duration: 9000
                    loops: Animation.Infinite
                    running: true
                }
                x: (parent.width  / 2) + (parent.width  / 2 - 8)  * Math.cos(t2 + Math.PI) - width  / 2
                y: (parent.height / 2) + (parent.height / 2 - 22) * Math.sin(t2 + Math.PI) - height / 2
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 1
            Text {
                id: clockTime
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fClock; font.pixelSize: 58; font.weight: Font.Bold
                color: "#2c3e50"; style: Text.Outline; styleColor: "#ffffffcc"
                horizontalAlignment: Text.AlignHCenter
                Timer { interval: 1000; running: true; repeat: true;
                    onTriggered: clockTime.text = Qt.formatTime(new Date(), "hh:mm") }
                    Component.onCompleted: text = Qt.formatTime(new Date(), "hh:mm")
            }
            Text {
                id: clockDate
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: fMain; font.pixelSize: 16; font.weight: Font.Medium
                color: "#2c3e50"; style: Text.Outline; styleColor: "#ffffffcc"
                horizontalAlignment: Text.AlignHCenter
                Timer { interval: 60000; running: true; repeat: true;
                    onTriggered: clockDate.text = Qt.formatDate(new Date(), "dddd, dd MMMM yyyy") }
                    Component.onCompleted: text = Qt.formatDate(new Date(), "dddd, dd MMMM yyyy")
            }
        }
    }

    // ===== LOGIN PANEL =====
    Rectangle {
        id: loginPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.min(pWidth, parent.width * 0.45)
        z: 10
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#7fb3d5"       // <-- color of the login panel
            opacity: 0.85          // <-- You can adjust the transparency in here
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "#ffffff"
            border.width: 2
        }

        // ===== HEADER (Logo + Text) =====
        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 56
            anchors.topMargin: 34
            anchors.bottomMargin: 540
            spacing: 34

            // HEADER
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 15

                Item {
                    Layout.preferredWidth: 137           // <-- You can adjust the logo size here
                    Layout.preferredHeight: 137
                    Layout.alignment: Qt.AlignHCenter
                    Image {
                        anchors.fill: parent
                        source: "Spacetrek_Collective.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }

                Column {
                    spacing: 5
                    Layout.alignment: Qt.AlignHCenter
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "RESONATOR"
                        font.family: fMain; font.pixelSize: 30; font.weight: Font.Bold
                        color: "#000000"; horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "AUTHENTICATION REQUIRED"
                        font.family: fMain; font.pixelSize: 15
                        color: "#000000"; horizontalAlignment: Text.AlignHCenter
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; height: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.5; color: "#000000" }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
            }

            // ===== INPUT AREA =====
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 18

                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 45; radius: 14       // <-- input area roundness level
                    color: "#dde9f7"          // <-- color of the input area
                    border.color: usernameInput.activeFocus ? "#f988a9" : "transparent"  // <-- color of the border input area
                    border.width: 2
                    TextInput {
                        id: usernameInput
                        anchors.fill: parent; anchors.margins: 15
                        font.family: fMain; font.pixelSize: 16; color: cText
                        verticalAlignment: TextInput.AlignVCenter
                        selectByMouse: true
                        onAccepted: passwordInput.forceActiveFocus()
                    }
                    Text {
                        visible: usernameInput.text.length === 0
                        anchors.left: parent.left; anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Username"; color: cMuted; font.family: fMain; font.pixelSize: 16
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 45; radius: 14       // <-- input area roundness level
                    color: "#dde9f7"           // <-- color of the input area
                    border.color: passwordInput.activeFocus ? "#f988a9" : "transparent"  // <-- color of the border input area
                    border.width: 2
                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.leftMargin: 15; anchors.rightMargin: 45
                        font.family: fMain; font.pixelSize: 16; color: cText
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password
                        selectByMouse: true
                        onAccepted: sddm.login(usernameInput.text, passwordInput.text, root.selectedSessionIndex)
                    }
                    Text {
                        visible: passwordInput.text.length === 0
                        anchors.left: parent.left; anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Password"; color: cMuted; font.family: fMain; font.pixelSize: 16
                    }
                    Image {
                        id: eyeIcon
                        anchors.right: parent.right; anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20; height: 20
                        source: passwordInput.echoMode === TextInput.Password ? "eye-off.svg" : "eye.svg"
                        opacity: mouseAreaEye.containsMouse ? 1.0 : 0.6
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    MouseArea {
                        id: mouseAreaEye
                        anchors.fill: eyeIcon
                        hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            passwordInput.echoMode = passwordInput.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password
                            passwordInput.forceActiveFocus()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 47; radius: 14
                    color: mouseAreaLogin.containsMouse ? "#d48533" : cAccent// <-- color of the login button (main and mouse area)
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Text {
                        anchors.centerIn: parent; text: "Login"
                        font.family: fMain; font.pixelSize: 17; font.weight: Font.SemiBold; color: "#ffffff"
                    }
                    MouseArea {
                        id: mouseAreaLogin
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: sddm.login(usernameInput.text, passwordInput.text, root.selectedSessionIndex)
                    }
                }

                Text {
                    id: errorMsg
                    text: ""; font.family: fMain; font.pixelSize: 13; color: "#e74c3c"
                    Layout.alignment: Qt.AlignHCenter; visible: text !== ""
                }
            }
        }

        // ===== SYSTEM BUTTON =====
        Row {
            id: systemButtonsRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            spacing: 17
            z: 11

            SystemButton { iconSource: "../power.svg";    tooltipText: "Shutdown"; onClicked: sddm.powerOff() }
            SystemButton { iconSource: "../restart.svg";  tooltipText: "Restart";  onClicked: sddm.reboot() }
            SystemButton { iconSource: "../sleep.svg";    tooltipText: "Sleep";    onClicked: sddm.suspend() }
            SystemButton { iconSource: "../settings.svg"; tooltipText: "Session";  onClicked: sessionPopup.visible = !sessionPopup.visible }
        }

        // ===== COPYRIGHT =====
        Text {
            text: "Wuthering Waves | Mornye"
            font.family: fMain
            font.pixelSize: 14
            font.weight: Font.Medium
            font.letterSpacing: 1.5
            color: "#000000"
            opacity: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 13
            z: 11
        }

        // ===== SESSION POPUP =====
        Rectangle {
            id: sessionPopup
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: systemButtonsRow.top
            anchors.bottomMargin: 12
            width: parent.width - 100
            height: sessionRepeater.count * 45 + 20
            radius: 12
            z: 20
            visible: false
            clip: true

            color: "#1e293bd9"
            border.color: "#ffffff66"
            border.width: 1

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#9dc8fa" }
                GradientStop { position: 0.2; color: "#9dc8fa" }
                GradientStop { position: 0.9; color: "#ffffff" }
            }

            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Column {
                anchors.fill: parent; anchors.margins: 10; spacing: 5
                Repeater {
                    id: sessionRepeater
                    model: sessionModel
                    Rectangle {
                        width: sessionPopup.width - 20; height: 40; radius: 8
                        color: mouseAreaSession.containsMouse ? "#f988a9" : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Text {
                            anchors.centerIn: parent; text: model.name
                            font.family: fMain; font.pixelSize: 13; font.weight: Font.Medium; color: "#000000"
                        }
                        MouseArea {
                            id: mouseAreaSession
                            anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: { root.selectedSessionIndex = index; sessionPopup.visible = false }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() { errorMsg.text = "Login failed. Check your username or password" }
        function onLoginSucceeded() { }
    }
}
