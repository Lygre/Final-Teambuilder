import Cocoa


var monImport = """
Landorus-Therian @ Choice Scarf
Ability: Intimidate
EVs: 128 HP / 104 Atk / 44 Def / 232 Spe
Jolly Nature
- U-turn
- Earthquake
- Defog
- Knock Off
"""

var monStringArray = [String]()
monStringArray = monImport.components(separatedBy: "\n")
var name, item, ability, nature, move1, move2, move3, move4: String
var eVs = [String: Int]()
var iVs = [String: Int]()
var moves = [String]()
for line in monStringArray {
	if line.contains("@") {
		let nameIndex = monImport.startIndex..<monImport.index(monImport.firstIndex(of: "@")!, offsetBy: -1)
		//this returns mon's name
		name = String(monImport[nameIndex])
		
		//this gets item
		let itemIndex = monImport.index(monImport.firstIndex(of: "@")!, offsetBy: 2)..<monImport.firstIndex(of: "\n")!
		item = String(monImport[itemIndex])
	}
	if line.contains("Ability: ") {
		let abilityStartIndex = line.firstIndex(of: " ")
		let abilityEndIndex = line.index(line.endIndex, offsetBy: 0)
		let abilityIndex = line.index(after: abilityStartIndex!)..<abilityEndIndex
		ability = String(line[abilityIndex])
	}
	if line.contains("EVs: ") {
		let evString = line[line.index(line.firstIndex(of: " ")!, offsetBy: 1)..<line.endIndex]
		let evStringArray = evString.components(separatedBy: " / ")
		for string in evStringArray {
			var evLabel: String = String()
			var evValue: Int = Int()
			if string.contains("HP") {
				evLabel = String(string[string.index(string.endIndex, offsetBy: -2)..<string.endIndex].lowercased())
				evValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])!
			} else {
				evLabel = String(string[string.index(string.endIndex, offsetBy: -3)..<string.endIndex].lowercased())
				evValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])!
			}
			eVs[evLabel] = evValue
		}
	}
	if line.contains(" Nature") {
		let natureLabel = line[line.startIndex..<line.firstIndex(of: " ")!]
		nature = String(natureLabel)
	}
	if line.contains("IVs: ") {
		let ivString = line[line.index(line.firstIndex(of: " ")!, offsetBy: 1)..<line.endIndex]
		let ivStringArray = ivString.components(separatedBy: " / ")
		for string in ivStringArray {
			let ivLabel = String(string[string.index(string.endIndex, offsetBy: -3)..<string.endIndex].lowercased())
			let ivValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])
			iVs[ivLabel] = ivValue
		}
	}
	if line.contains("- ") {
		let moveString = String(line[line.index(line.firstIndex(of: " ")!, offsetBy: 1)..<line.endIndex])
		moves.append(moveString)
		print(moveString)
	}
}

move1 = moves[0]
move2 = moves[1]
move3 = moves[2]
move4 = moves[3]
iVs
eVs

Double(1.0 + 1.0)
