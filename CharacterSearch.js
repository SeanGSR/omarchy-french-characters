function normalize(value) {
  return String(value || "").trim().toLowerCase()
}

function filterCharacters(characters, query) {
  var needle = normalize(query)
  if (!needle) return characters

  var matches = []
  for (var i = 0; i < characters.length; i++) {
    var item = characters[i]
    if (/^[a-z]$/.test(needle)) {
      if (normalize(item.base) === needle) matches.push(item)
      continue
    }
    var searchable = normalize(item.base + " " + item.name + " " + item.keywords + " " + item.character)
    if (searchable.indexOf(needle) >= 0) matches.push(item)
  }
  return matches
}

function filterVariants(characters, selection) {
  var raw = String(selection || "").trim()
  var bases = {
    "à": "a", "á": "a", "â": "a", "ä": "a", "À": "a", "Á": "a", "Â": "a", "Ä": "a",
    "æ": "ae", "Æ": "ae",
    "ç": "c", "Ç": "c",
    "é": "e", "è": "e", "ê": "e", "ë": "e",
    "É": "e", "È": "e", "Ê": "e", "Ë": "e",
    "î": "i", "ï": "i", "Î": "i", "Ï": "i",
    "ô": "o", "ö": "o", "Ô": "o", "Ö": "o",
    "œ": "oe", "Œ": "oe",
    "ù": "u", "û": "u", "ü": "u", "Ù": "u", "Û": "u", "Ü": "u",
    "ÿ": "y", "Ÿ": "y"
  }
  var base = bases[raw] || raw.toLowerCase()
  if (!base) return []
  var wantsUppercase = raw === raw.toUpperCase() && raw !== raw.toLowerCase()
  var matches = []
  var plain = wantsUppercase ? base.toUpperCase() : base

  if (raw !== plain) {
    matches.push({
      character: plain,
      base: base,
      name: plain + " sans accent",
      keywords: "lettre simple non accentuée"
    })
  }

  for (var i = 0; i < characters.length; i++) {
    var item = characters[i]
    if (normalize(item.base) !== base) continue
    var character = String(item.character || "")
    if (character === raw) continue
    var isUppercase = character === character.toUpperCase() && character !== character.toLowerCase()
    if (isUppercase === wantsUppercase) matches.push(item)
  }
  return matches
}

if (typeof module !== "undefined") {
  module.exports = {
    normalize: normalize,
    filterCharacters: filterCharacters,
    filterVariants: filterVariants
  }
}
