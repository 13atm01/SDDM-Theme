// ╔════════════════════════════════════════════════════════════════════════════════════╗
// ║Edit carefully, I’ve included title and description tags to make the editing        ║
// ║process easier for you. If you want to change the color of the logo setting buttons,║
// ║you'll need to edit the SVG file directly. Open the SVG file in your text editor    ║
// ║and search word "stroke"                                                            ║
// ║                                                                                    ║
// ║                         ©13atm01 alias Andi Trisna Mukti                          ║
// ╚════════════════════════════════════════════════════════════════════════════════════╝
import QtQuick 2.15

Rectangle {
    id: control
    width: 48; height: 48; radius: 12           // <-- setting buttons roundness level

    property string iconSource: ""
    property string tooltipText: ""
    signal clicked()

    color: mouseAreaBtn.containsMouse ? "#e74c3c" : "#e8943a"  // <-- color of the setting buttons (main and mouse area)
    border.color: "#ffffff66"; border.width: 1
    Behavior on color { ColorAnimation { duration: 150 } }

    Image {
        anchors.centerIn: parent
        source: control.iconSource
        sourceSize: Qt.size(22, 22)
        fillMode: Image.PreserveAspectFit
        opacity: mouseAreaBtn.containsMouse ? 1.0 : 0.8
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    // ===== Tooltip manual =====
    Rectangle {
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 8
        width: tipText.implicitWidth + 16
        height: tipText.implicitHeight + 10
        radius: 8
        color: "#e74c3c"; border.color: "#ffffff66"; border.width: 1    // <-- color of the login button (popup session)
        visible: mouseAreaBtn.containsMouse
        opacity: visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
        Text {
            id: tipText
            anchors.centerIn: parent
            text: control.tooltipText
            font.family: "Exo 2"; font.pixelSize: 12; color: "#ffffff"
        }
    }

    MouseArea {
        id: mouseAreaBtn
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }
}
