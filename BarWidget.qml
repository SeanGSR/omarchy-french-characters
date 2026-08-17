import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "fr.ldng.caracteres-francais"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰌌"
    fontFamily: "Symbols Nerd Font Mono"
    horizontalMargin: 8
    tooltipText: "Caractères français"
    onPressed: function(mouseButton) {
      if (!root.bar || mouseButton !== Qt.LeftButton) return
      root.bar.run("omarchy-shell shell toggle fr.ldng.caracteres-francais '{}'")
    }
  }
}
