import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Ui
import "CharacterSearch.js" as CharacterSearch

Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false
  property string filterText: ""
  property int selectedIndex: 0
  property var filteredCharacters: []
  property bool quickMode: false
  property string sourceSelection: ""
  property int popupX: 0
  property int popupY: 0

  readonly property var characters: [
    { character: "à", base: "a", name: "a accent grave", keywords: "lowercase minuscule" },
    { character: "á", base: "a", name: "a accent aigu", keywords: "lowercase minuscule" },
    { character: "â", base: "a", name: "a accent circonflexe", keywords: "lowercase minuscule" },
    { character: "ä", base: "a", name: "a tréma", keywords: "lowercase minuscule" },
    { character: "À", base: "a", name: "A accent grave", keywords: "uppercase majuscule" },
    { character: "Á", base: "a", name: "A accent aigu", keywords: "uppercase majuscule" },
    { character: "Â", base: "a", name: "A accent circonflexe", keywords: "uppercase majuscule" },
    { character: "Ä", base: "a", name: "A tréma", keywords: "uppercase majuscule" },
    { character: "æ", base: "ae", name: "e dans l’a ligature", keywords: "lowercase minuscule ligature" },
    { character: "Æ", base: "ae", name: "E dans l’A ligature", keywords: "uppercase majuscule ligature" },
    { character: "ç", base: "c", name: "c cédille", keywords: "lowercase minuscule cedille" },
    { character: "Ç", base: "c", name: "C cédille", keywords: "uppercase majuscule cedille" },
    { character: "é", base: "e", name: "e accent aigu", keywords: "lowercase minuscule" },
    { character: "è", base: "e", name: "e accent grave", keywords: "lowercase minuscule" },
    { character: "ê", base: "e", name: "e accent circonflexe", keywords: "lowercase minuscule" },
    { character: "ë", base: "e", name: "e tréma", keywords: "lowercase minuscule" },
    { character: "É", base: "e", name: "E accent aigu", keywords: "uppercase majuscule" },
    { character: "È", base: "e", name: "E accent grave", keywords: "uppercase majuscule" },
    { character: "Ê", base: "e", name: "E accent circonflexe", keywords: "uppercase majuscule" },
    { character: "Ë", base: "e", name: "E tréma", keywords: "uppercase majuscule" },
    { character: "î", base: "i", name: "i accent circonflexe", keywords: "lowercase minuscule" },
    { character: "ï", base: "i", name: "i tréma", keywords: "lowercase minuscule" },
    { character: "Î", base: "i", name: "I accent circonflexe", keywords: "uppercase majuscule" },
    { character: "Ï", base: "i", name: "I tréma", keywords: "uppercase majuscule" },
    { character: "ô", base: "o", name: "o accent circonflexe", keywords: "lowercase minuscule" },
    { character: "ö", base: "o", name: "o tréma", keywords: "lowercase minuscule" },
    { character: "Ô", base: "o", name: "O accent circonflexe", keywords: "uppercase majuscule" },
    { character: "Ö", base: "o", name: "O tréma", keywords: "uppercase majuscule" },
    { character: "œ", base: "oe", name: "e dans l’o ligature", keywords: "lowercase minuscule ligature" },
    { character: "Œ", base: "oe", name: "E dans l’O ligature", keywords: "uppercase majuscule ligature" },
    { character: "ù", base: "u", name: "u accent grave", keywords: "lowercase minuscule" },
    { character: "û", base: "u", name: "u accent circonflexe", keywords: "lowercase minuscule" },
    { character: "ü", base: "u", name: "u tréma", keywords: "lowercase minuscule" },
    { character: "Ù", base: "u", name: "U accent grave", keywords: "uppercase majuscule" },
    { character: "Û", base: "u", name: "U accent circonflexe", keywords: "uppercase majuscule" },
    { character: "Ü", base: "u", name: "U tréma", keywords: "uppercase majuscule" },
    { character: "ÿ", base: "y", name: "y tréma", keywords: "lowercase minuscule" },
    { character: "Ÿ", base: "y", name: "Y tréma", keywords: "uppercase majuscule" },
    { character: "•", base: "puce", name: "puce typographique", keywords: "ponctuation bullet liste point" },
    { character: "«", base: "guillemet", name: "guillemet français ouvrant", keywords: "ponctuation quote left" },
    { character: "»", base: "guillemet", name: "guillemet français fermant", keywords: "ponctuation quote right" },
    { character: "“", base: "guillemet", name: "guillemet anglais ouvrant", keywords: "ponctuation quote courbe double left" },
    { character: "”", base: "guillemet", name: "guillemet anglais fermant", keywords: "ponctuation quote courbe double right" },
    { character: "’", base: "apostrophe", name: "apostrophe typographique", keywords: "punctuation quote" },
    { character: "…", base: "points", name: "points de suspension", keywords: "ponctuation ellipsis" },
    { character: "–", base: "tiret", name: "tiret demi-cadratin", keywords: "ponctuation en dash" },
    { character: "—", base: "tiret", name: "tiret cadratin", keywords: "ponctuation em dash" },
    { character: "©", base: "copyright", name: "symbole copyright", keywords: "droits auteur copie" },
    { character: "€", base: "euro", name: "symbole euro", keywords: "monnaie currency" },
    { character: "∞", base: "infini", name: "symbole infini", keywords: "mathématiques infinity" },
    { character: "½", base: "fraction", name: "un demi", keywords: "fraction moitié half 1/2" },
    { character: "¼", base: "fraction", name: "un quart", keywords: "fraction quarter 1/4" },
    { character: "¦", base: "barre", name: "barre verticale discontinue", keywords: "symbole broken bar" },
    { character: "°", base: "degré", name: "symbole degré", keywords: "unité temperature angle degree" },
    { character: "℃", base: "température", name: "degré Celsius", keywords: "unité temperature centigrade" },
    { character: "℉", base: "température", name: "degré Fahrenheit", keywords: "unité temperature" },
    { character: " ", base: "espace", name: "espace insécable", keywords: "ponctuation nbsp non breaking space" },
    { character: " ", base: "espace", name: "espace fine insécable", keywords: "ponctuation narrow nbsp non breaking space" },
    { character: "░", base: "bloc", name: "bloc ombré léger", keywords: "graphique trame shading light" },
    { character: "▒", base: "bloc", name: "bloc ombré moyen", keywords: "graphique trame shading medium" },
    { character: "▓", base: "bloc", name: "bloc ombré foncé", keywords: "graphique trame shading dark" },
    { character: "█", base: "bloc", name: "bloc plein", keywords: "graphique carré full block" },
    { character: "★", base: "décoratif", name: "étoile noire", keywords: "symbole star favoris" },
    { character: "❤", base: "décoratif", name: "cœur noir", keywords: "symbole heart amour" },
    { character: "웃", base: "visage", name: "visage coréen", keywords: "émoticône emoticon sourire humain" },
    { character: "ツ", base: "visage", name: "visage japonais", keywords: "émoticône emoticon sourire katakana" }
  ]

  property color background: Color.menu.background
  property color foreground: Color.menu.text
  property color border: Color.menu.border
  property var borderSpec: Border.surfaceSpec("menu", "border", border, Math.max(1, Style.space(2)))
  property color scrim: Color.menu.scrim
  property color selectedBackground: Color.menu.selectedBackground
  property color selectedText: Color.menu.selectedText
  readonly property int cornerRadius: Style.cornerRadius
  property string fontFamily: Style.font.menuFamily
  property int contentMargin: Style.spacing.panelPadding
  property int quickPadding: Style.space(2)
  property int mainPadding: Style.space(6)
  property int contentSpacing: quickMode ? 0 : Style.space(4)
  property int cardWidth: quickMode
    ? Math.min(displayModel.count * Style.space(34) + quickPadding * 2, panel.width - Style.gapsOut * 2)
    : Math.min(Style.space(348), panel.width - Style.gapsOut * 2)
  property int cellHeight: quickMode ? Style.space(34) : Style.space(38)
  readonly property int columns: quickMode ? Math.max(1, displayModel.count) : 8
  readonly property int visibleRows: Math.min(8, Math.max(1, Math.ceil(displayModel.count / columns)))
  property int cardHeight: quickMode
    ? Style.space(38)
    : Math.min(mainPadding * 2 + Style.space(34) + contentSpacing + visibleRows * cellHeight, panel.height - Style.gapsOut * 2)

  function open(payloadJson) {
    var payload = {}
    try { payload = JSON.parse(String(payloadJson || "{}")) } catch (e) { payload = {} }
    opened = true
    quickMode = payload.quick === true
    sourceSelection = String(payload.selection || "")
    popupX = Number(payload.x || 0)
    popupY = Number(payload.y || 0)
    filterText = quickMode ? sourceSelection : ""
    selectedIndex = 0
    rebuildDisplay()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() { opened = false }
  function dismiss() {
    opened = false
    if (shell && typeof shell.hide === "function") shell.hide("fr.ldng.caracteres-francais")
  }
  function toggle() { opened ? dismiss() : open("{}") }

  function rebuildDisplay() {
    filteredCharacters = quickMode
      ? CharacterSearch.filterVariants(characters, sourceSelection)
      : CharacterSearch.filterCharacters(characters, filterText)
    displayModel.clear()
    for (var i = 0; i < filteredCharacters.length; i++) {
      var item = filteredCharacters[i]
      displayModel.append({ character: item.character, characterName: item.name })
    }
    selectedIndex = displayModel.count === 0 ? 0 : Math.min(selectedIndex, displayModel.count - 1)
    Qt.callLater(function() {
      if (displayModel.count > 0) resultGrid.positionViewAtIndex(selectedIndex, GridView.Contain)
    })
  }

  function setFilter(value) {
    filterText = value
    selectedIndex = 0
    rebuildDisplay()
  }

  function select(delta) {
    if (displayModel.count === 0) return
    selectedIndex = (selectedIndex + delta + displayModel.count) % displayModel.count
    resultGrid.positionViewAtIndex(selectedIndex, GridView.Contain)
  }

  function copyIndex(index) {
    if (index < 0 || index >= displayModel.count) return
    var value = displayModel.get(index).character
    if (quickMode)
      Quickshell.execDetached([
        Quickshell.env("HOME") + "/.config/omarchy/plugins/fr.ldng.caracteres-francais/replace-selection",
        value,
        sourceSelection
      ])
    else
      Quickshell.execDetached(["wl-copy", value])
    dismiss()
  }

  ListModel { id: displayModel }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "caracteres-francais"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Rectangle { anchors.fill: parent; color: "transparent" }
    MouseArea { anchors.fill: parent; onClicked: root.dismiss() }

    BorderSurface {
      id: card
      width: root.cardWidth
      height: root.cardHeight
      x: root.quickMode
        ? Math.max(Style.gapsOut, Math.min(root.popupX - width / 2, panel.width - width - Style.gapsOut))
        : (panel.width - width) / 2
      y: root.quickMode
        ? Math.max(Style.gapsOut, Math.min(root.popupY - height - Style.space(4), panel.height - height - Style.gapsOut))
        : (panel.height - height) / 2
      radius: Style.space(4)
      color: Qt.lighter(root.background, 1.18)
      borderSpec: Border.none()
      padding: root.quickMode ? root.quickPadding : root.mainPadding

      MouseArea { anchors.fill: parent; onClicked: {} }

      Item {
        id: keyCatcher
        anchors.fill: parent
        focus: true
        Keys.priority: Keys.BeforeItem
        Keys.onPressed: function(event) {
          if (event.key === Qt.Key_Escape) {
            if (root.filterText) root.setFilter("")
            else root.dismiss()
            event.accepted = true
          } else if (event.key === Qt.Key_Backspace) {
            root.setFilter(root.filterText.slice(0, -1))
            event.accepted = true
          } else if (event.key === Qt.Key_Left) {
            root.select(-1); event.accepted = true
          } else if (event.key === Qt.Key_Right) {
            root.select(1); event.accepted = true
          } else if (event.key === Qt.Key_Up) {
            root.select(-root.columns); event.accepted = true
          } else if (event.key === Qt.Key_Down) {
            root.select(root.columns); event.accepted = true
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.copyIndex(root.selectedIndex); event.accepted = true
          } else if (event.text && event.text.length === 1 && event.text.charCodeAt(0) >= 32) {
            root.setFilter(root.filterText + event.text)
            event.accepted = true
          }
        }
      }

      Column {
        anchors.fill: parent
        anchors.topMargin: card.contentTopInset
        anchors.rightMargin: card.contentRightInset
        anchors.bottomMargin: card.contentBottomInset
        anchors.leftMargin: card.contentLeftInset
        spacing: root.contentSpacing

        Row {
          visible: false
          width: parent.width
          height: Style.space(26)
          spacing: Style.spacing.sm
          Text {
            text: "󰌌"
            color: root.selectedText
            font.family: "Symbols Nerd Font Mono"
            font.pixelSize: Style.font.title
            anchors.verticalCenter: parent.verticalCenter
          }
          Text {
            text: root.quickMode ? "Remplacer « " + root.sourceSelection + " »" : "Caractères français"
            color: root.foreground
            font.family: root.fontFamily
            font.pixelSize: Style.font.title
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        Rectangle {
          visible: !root.quickMode
          width: parent.width
          height: Style.space(34)
          radius: Style.space(3)
          color: Qt.rgba(root.foreground.r, root.foreground.g, root.foreground.b, 0.07)
          border.width: 0

          Text {
            anchors.left: parent.left
            anchors.leftMargin: Style.space(9)
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: root.foreground
            opacity: 0.55
            font.family: "Symbols Nerd Font Mono"
            font.pixelSize: Style.font.heading
          }

          Text {
            anchors.left: parent.left
            anchors.leftMargin: Style.space(30)
            anchors.right: parent.right
            anchors.rightMargin: Style.space(9)
            anchors.verticalCenter: parent.verticalCenter
            text: root.filterText || "Rechercher une lettre, un accent, une ligature…"
            color: root.foreground
            opacity: root.filterText ? 1 : 0.58
            font.family: root.fontFamily
            font.pixelSize: Style.font.title
            elide: Text.ElideRight
          }
        }

        Item {
          width: parent.width
          height: root.quickMode
            ? parent.height
            : parent.height - Style.space(34) - root.contentSpacing

          GridView {
            id: resultGrid
            anchors.fill: parent
            model: displayModel
            clip: true
            cellWidth: Math.floor(width / root.columns)
            cellHeight: root.cellHeight
            boundsBehavior: Flickable.StopAtBounds
            interactive: !root.quickMode

            delegate: Rectangle {
              required property int index
              required property string character
              required property string characterName
              width: resultGrid.cellWidth - Style.space(1)
              height: root.cellHeight - Style.space(1)
              radius: Style.space(3)
              color: index === root.selectedIndex ? root.selectedBackground : "transparent"

              Column {
                anchors.centerIn: parent
                width: parent.width - Style.space(8)
                spacing: Style.space(2)
                Text {
                  width: parent.width
                  text: parent.parent.character === " " ? "NB" : (parent.parent.character === " " ? "NNB" : parent.parent.character)
                  color: index === root.selectedIndex ? root.selectedText : root.foreground
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.heading
                  horizontalAlignment: Text.AlignHCenter
                }
                Text {
                  visible: false
                  width: parent.width
                  text: parent.parent.characterName
                  color: index === root.selectedIndex ? root.selectedText : root.foreground
                  opacity: 0.72
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.caption
                  horizontalAlignment: Text.AlignHCenter
                  elide: Text.ElideRight
                }
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onContainsMouseChanged: if (containsMouse) root.selectedIndex = index
                onClicked: root.copyIndex(index)
              }
            }
          }

          Text {
            visible: displayModel.count === 0
            anchors.centerIn: parent
            text: "Aucun caractère trouvé pour « " + root.filterText + " »"
            color: root.foreground
            opacity: 0.7
            font.family: root.fontFamily
            font.pixelSize: Style.font.title
          }
        }
      }
    }
  }
}
