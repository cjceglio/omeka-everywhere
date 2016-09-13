import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../../utils"

ListView{
    id: list

    property real sourceWidth: 0
    property real sourceHeight: 0
    property var imageWidth
    property var imageHeight
    property var images: []
    property var urls

    anchors.centerIn: parent
    orientation: ListView.Horizontal
    snapMode: ListView.SnapOneItem
    cacheBuffer: viewer.width*model.count
    interactive: model.count > 1
    clip: true
    spacing: Resolution.applyScale(90)
    highlightRangeMode: ListView.StrictlyEnforceRange

    model: ListModel {}
    delegate: Image {
        anchors.verticalCenter: parent.verticalCenter
        width: list.imageWidth
        height: list.imageHeight
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        source: src
        onWidthChanged: size()
        onHeightChanged: size()
        onStatusChanged: {
            if(status === Image.Ready){
                images.push(this)
                size()
            }
        }
    }

    onUrlsChanged: {
        images.length = 0
        list.model.clear();
        for(var i=0; i<urls.length; i++) {
            list.model.append({src:urls[i]})
        }
    }

    function size() {
        if(urls.length === images.length) {
            list.width = list.height = list.sourceWidth = list.sourceHeight = 0
            for(var i=0; i<images.length; i++) {
                list.sourceWidth = Math.max(list.sourceWidth, images[i].sourceSize.width)
                list.sourceHeight = Math.max(list.sourceHeight, images[i].sourceSize.height)
                list.width = Math.max(list.width, images[i].width)
                list.height = Math.max(list.height, images[i].height)
            }
        }
    }

    IndexIndicator {
        visible: list.interactive
        anchors.bottom: parent.bottom
        width: parent.width
        height: Resolution.applyScale(150)
    }
}
