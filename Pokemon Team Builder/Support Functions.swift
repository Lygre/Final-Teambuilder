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
	}
	if mon.species.contains("-Mega") {
		spriteName = spriteName! + "-mega"
	}
	
	spriteName = spriteName! + ".png"
	
	return spriteName!
}


//class Result: NSObject {
//	var num: Int? = 0
//	var species: String? = ""
//	var types: [String]? = []
//	var baseStats: [String: Int]? = [:]
//	var abilities: [String]? = []
//
//	init(dictionary: Dictionary<String, AnyObject>) {
//		num = dictionary["num"] as? Int
//		species = dictionary["species"] as? String
//		types = dictionary["types"] as? [String]
//		baseStats = dictionary["baseStats"] as? [String: Int]
//		abilities = dictionary["abilities"] as? [String]
//
//		super.init()
//	}
//}
