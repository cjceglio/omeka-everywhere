import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../../utils"
import "../../base"

/*!
  \qmltype Setting

  Setting is a control composed of a category item and content item used to modify
  or display user settings
*/
Item {
    id: setting
    width: parent.width
    height: childrenRect.height
    clip: true

    /*! \qml property string Setting::title
      Setting name
    */
    property alias title: category.text

    /*! \qml property Item Setting::content
      Setting name
    */
    property Item content

    /*! \qml property bool Setting::uncheck
      Uncheck currently selected
    */
    property bool uncheck: false

    property real transitionTime: 0

    /*! \qml property bool Setting::checked
      Checked state
    */
    property alias checked: category.checked

    /*! \qml property bool Setting::enableArrow
      Enables/disables rendering of arrow
    */
    property alias enableArrow: arrow.visible    

    //change state on check
    onCheckedChanged: {
        state = checked ? "expand" : "collapse"
    }

    //set initial state after dimensions
    onWidthChanged: {
        if(width) {
            state = "collapse"
            transitionTime = 250
        }
    }

    //content bindings
    Binding { target: content; property: "parent"; value: setting }
    Binding { target: content; property: "width"; value: setting.width }
    Binding { target: content.anchors; property: "topMargin"; value: Resolution.applyScale(2) }

    //toggles the expanded state of setting
    Button{
        id: category
        width: parent.width
        height: Resolution.applyScale(150)
        z: 1
        checkable: true
        exclusiveGroup: settingsGroup

        //cutom style
        style: ButtonStyle {
            background: Rectangle { color: "white" }
            label: OmekaText {
                text: control.text
                _font: Style.settingFont
                center: true
            }
        }

        //expanded indicator
        Image {
            id: arrow
            height: parent.height * .35
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: Resolution.applyScale(30)
            source: Style.expand
        }        

        //uncheck current selection
        onPressedChanged: {
            if(pressed) {
                uncheck = exclusiveGroup.current === category
            } else if(uncheck) {
                exclusiveGroup.current = null
            }
        }
    }

    //collapse and expand states
    states: [
        State {
            name: "expand"
            AnchorChanges { target: content; anchors.top: category.bottom; anchors.bottom: undefined }
        },
        State {
            name: "collapse"
            PropertyChanges { target: setting; explicit: true; height: category.height }
            PropertyChanges { target: arrow; explicit: true; opacity: 0 }
            AnchorChanges { target: content; anchors.top: undefined; anchors.bottom: category.bottom }
        }
    ]

    //state transitions
    transitions: Transition {
        AnchorAnimation { duration: transitionTime; easing.type: Easing.OutQuad }
        PropertyAnimation { target: arrow; property: "opacity"; duration: transitionTime; easing.type: Easing.OutQuad }
        PropertyAnimation { target: setting; property: "height"; duration: transitionTime; easing.type: Easing.OutQuad }
    }
}
