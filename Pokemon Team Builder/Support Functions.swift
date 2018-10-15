//
//  Support Functions.swift
//  Test4
//
//  Created by Hugh Broome on 7/13/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

// Function to convert Array of Pokemon objects to string array of their names

func convertPokemonToDict(_ pokemon: [Pokemon]) -> [[String: AnyObject]] {
	var result = [[String: AnyObject]]()
	
	for mon in pokemon {
		var monDict = [String: AnyObject]()
		
		monDict["num"] = mon.num as AnyObject
		monDict["species"] = mon.species as AnyObject
//		monDict["types"] = mon.types as Array as AnyObject
//		monDict["baseStats"] = mon.baseStats as AnyObject
//		monDict["abilities"] = mon.abilities as AnyObject
		
		var typesString = String("    ")
		for type in mon.types {
			typesString.append("\(type)    ")
		}
		monDict["types"] = typesString as AnyObject
		
//		var bsString = String()
		for (stat, value) in mon.baseStats {
//			bsString.append("\(stat): \(value) ")
			monDict[stat] = value as AnyObject
		}
//		monDict["baseStats"] = bsString as AnyObject
		
		monDict["BST"] = Pokemon.calcBST(pokemon: mon) as AnyObject
		
		var abilityString = String()
		for ability in mon.abilities {
			abilityString.append("\(ability) ")
		}
		monDict["abilities"] = abilityString as AnyObject
		
		result.append(monDict)
	}
	
	return result
}

func convertSinglePokemonToDict(_ pokemon: Pokemon) -> [String: AnyObject] {
	var monDict = [String: AnyObject]()
	
	monDict["num"] = pokemon.num as AnyObject
	monDict["species"] = pokemon.species as AnyObject
	//		monDict["types"] = mon.types as Array as AnyObject
	//		monDict["baseStats"] = mon.baseStats as AnyObject
	//		monDict["abilities"] = mon.abilities as AnyObject
	
	var typesString = String("    ")
	for type in pokemon.types {
		typesString.append("\(type)    ")
	}
	monDict["types"] = typesString as AnyObject
	
	//		var bsString = String()
	for (stat, value) in pokemon.baseStats {
		//			bsString.append("\(stat): \(value) ")
		monDict[stat] = value as AnyObject
	}
	//		monDict["baseStats"] = bsString as AnyObject
	
	monDict["BST"] = Pokemon.calcBST(pokemon: pokemon) as AnyObject
	
	var abilityString = String()
	for ability in pokemon.abilities {
		abilityString.append("\(ability) ")
	}
	monDict["abilities"] = abilityString as AnyObject
	return monDict
}

func makeDexToUseableMons(_ pokedex: [Pokemon]) -> [String: Pokemon] {
	var aliasedDex = [String: Pokemon]()
	for mon in pokedex {
		let name = mon.species.lowercased().replacingOccurrences(of: " ", with: "")
		aliasedDex.updateValue(mon, forKey: name)
	}
	return aliasedDex
}

func dexNumToIcon(_ mon: Pokemon) -> String? {
	let dexNum: Int? = mon.num
	var iconName: String?
	
	if dexNum! < 10 {
		iconName = "00" + "\(dexNum ?? 0)"
	} else if dexNum! < 100 {
		iconName = "0" + "\(dexNum ?? 10)"
	} else {
		iconName = "\(dexNum ?? 100)"
	}
	
	if mon.species.contains("-Alola") {
		iconName = iconName! + "-alola"
	}
	if mon.species.contains("-Mega") {
		iconName = iconName! + "-mega"
	}
	
	iconName = iconName! + ".png"
	
	return iconName!
}

func dexNumToSprite(_ mon: Pokemon) -> String? {
	let dexNum: Int? = mon.num
	var spriteName: String?
	
	spriteName = "\(dexNum ?? 0)"
	
	if mon.species.contains("-Alola") {
		spriteName = spriteName! + "-alola"
	} else if mon.species.contains("-Mega") {
		spriteName = spriteName! + "-mega"
	} else if mon.species.contains("-") && !mon.species.contains("ommo-") {
		let lowerSpecies = mon.species.lowercased()
		var index = lowerSpecies.firstIndex(of: "-")
//		if lowerSpecies.contains("kommo") { index = }
		spriteName = spriteName! + lowerSpecies[index!...]
	}
	
	spriteName = spriteName! + ".png"
	
	return spriteName!
}


func determineMonInteractionIconTable(pokemon: Pokemon) -> [String: NSImage] {
	var monWeaknessDict: [String: Int]
	
	var monWeaknessDictTransformed: [String: NSImage] = [:]
	
	monWeaknessDict = pokemon.getPokemonWeaknesses(pokemonName: pokemon)
	
	
	for (type, scalar) in monWeaknessDict {
		var typeModImg: NSImage = NSImage(imageLiteralResourceName: "neutral.png")
		if scalar == 0 {
			typeModImg = NSImage(imageLiteralResourceName: "immune.png")
		} else if scalar == 1 {
			typeModImg = NSImage(imageLiteralResourceName: "neutral.png")
		} else if scalar == -2 {
			typeModImg = NSImage(imageLiteralResourceName: "resist2.png")
		} else if scalar == -4 {
			typeModImg = NSImage(imageLiteralResourceName: "resist4.png")
		} else if scalar == 2 {
			typeModImg = NSImage(imageLiteralResourceName: "weak2.png")
		} else if scalar == 4 {
			typeModImg = NSImage(imageLiteralResourceName: "weak4.png")
		}
		monWeaknessDictTransformed[type] = typeModImg
	}
	
	return monWeaknessDictTransformed
	
}


// Import mon from text
func importMonFromShowdown(showdownExportText: String) -> Pokemon {
	let monImport = """
\(showdownExportText)
"""
	var constructedImportMon: Pokemon
	
	var monStringArray = [String]()
	monStringArray = monImport.components(separatedBy: "\n")
	var name, item, ability, nature: String
	name = ""; item = ""; ability = ""; nature = ""
	var eVs = [String: Int]() ; eVs = ["hp": 0, "atk": 0, "def": 0, "spa": 0, "spd": 0, "spe": 0]
	var iVs = [String: Int]() ; iVs = ["hp": 31, "atk": 31, "def": 31, "spa": 31, "spd": 31, "spe": 31]
	var moves = [Move]()
	var move1, move2, move3, move4: Move
	var itemForConstruct: Item = Item()
	for line in monStringArray {
		if line.contains("@") {
			let nameIndex = monImport.startIndex..<monImport.index(monImport.firstIndex(of: "@")!, offsetBy: -1)
			//this returns mon's name
			name = String(monImport[nameIndex])
			
			//this gets item
			let itemIndex = monImport.index(monImport.firstIndex(of: "@")!, offsetBy: 2)..<monImport.firstIndex(of: "\n")!
			item = String(monImport[itemIndex])
			itemForConstruct = ItemDex.searchItemDex(searchParam: item)
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
				} else if (evStringArray.endIndex - 1) == evStringArray.lastIndex(of: string)  {
					evLabel = String(string[string.index(string.endIndex, offsetBy: -5)..<string.index(string.endIndex, offsetBy: -2)].lowercased())
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
				var ivLabel = String(string[string.index(string.endIndex, offsetBy: -3)..<string.endIndex].lowercased())
				var ivValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])
				if string.contains("HP") {
					ivLabel = String(string[string.index(string.endIndex, offsetBy: -2)..<string.endIndex].lowercased())
					ivValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])!
				} else if (ivStringArray.endIndex - 1) == ivStringArray.lastIndex(of: string)  {
					ivLabel = String(string[string.index(string.endIndex, offsetBy: -5)..<string.index(string.endIndex, offsetBy: -2)].lowercased())
					ivValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])!
				} else {
					ivLabel = String(string[string.index(string.endIndex, offsetBy: -3)..<string.endIndex].lowercased())
					ivValue = Int(string[string.startIndex..<string.firstIndex(of: " ")!])!
				}
				iVs[ivLabel] = ivValue
			}
		}
		if line.contains("- ") {
			let moveString = String(line[line.index(line.firstIndex(of: " ")!, offsetBy: 1)..<line.endIndex])
			let moveLiteral: Move = Move.init(id: moveString)
			moves.append(moveLiteral)
		}
	}
	
	move1 = moves[0]
	move2 = moves[1]
	move3 = moves[2]
	move4 = moves[3]
	
	constructedImportMon = Pokemon.init(species: name, level: 100, nature: nature, ability: ability, iVs: iVs, eVs: eVs, move1: move1, move2: move2, move3: move3, move4: move4, item: itemForConstruct)
	
//	print(constructedImportMon)
	return constructedImportMon
}
