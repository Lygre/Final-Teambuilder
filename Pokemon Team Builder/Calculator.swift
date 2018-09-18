//
//  Calculator.swift
//  Pokemon Team Builder
//
//  Created by Hugh Broome on 9/16/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Foundation

class Field: NSObject {
	@objc dynamic var terrain: String
	@objc dynamic var weather: String
	@objc dynamic var screens: [String: Bool]
	
	override init() {
		terrain = "None"
		weather = "None"
		screens = ["Reflect": false,
				   "Light Screen": false,
				   "Aurora Veil": false]
		super.init()
	}
	init(terrain: String) {
		self.terrain = terrain
		self.weather = "None"
		self.screens = ["Reflect": false,
						"Light Screen": false,
						"Aurora Veil": false]
	}
}

func calculateAllMoves(p1: Pokemon, p2: Pokemon, field: Field) {
	
}

func resistSearch(types: [String]) -> [Pokemon] {
	var matchMons: [Pokemon] = [Pokemon]()
	
	for mon in Dex.dexArray {
		let monWeaknessDict = mon.getPokemonWeaknesses(pokemonName: mon)
		var candidate: Bool = true
		
		for type in types {
			if monWeaknessDict[type]! > 0 {
				candidate = false
			}
		}
		if candidate == true {
			matchMons.append(mon)
		}
	}
	
	return matchMons
}

func findSuggestedMons(team: Team) -> [Pokemon] {
	var suggestedMons: [Pokemon] = [Pokemon]()
//	let currentMons: [Pokemon] = team.members
	let teamWeaknesses = team.determineTeamWeaknesses()
	print(teamWeaknesses)
	var resistSearchTypes: [String] = [String]()
//	let suggestedMonStringArray: [String] = Dex.findResistances(resistTypes: resistSearchTypes)
	
	for (type, vector) in teamWeaknesses {
		if vector > 1 {
			resistSearchTypes.append(type)
		}
	}
	suggestedMons = resistSearch(types: resistSearchTypes)
	
	return suggestedMons
}
