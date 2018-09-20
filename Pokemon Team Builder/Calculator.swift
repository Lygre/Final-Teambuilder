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
	//checkStatBoost(p1, p2)
	//var results = getDamageResult()
	
}

func getDamageResult(attacker: Pokemon, defender: Pokemon, move: Move, field: Field) -> [Move: Int] {
	var dmgResult: [Move: Int] = [Move: Int]()
	var baseDamage: Int = Int()
	var finalD = Int()
	var D: Int = Int()
	var attack = Int()
	var defense = Int()
	var modifier = Double()
	
	if move.category == "Physical" {
//		D = (((((2*attacker.level/5)+2) * move.basePower * (attacker.virtualStats["atk"] / defender.virtualStats["def"])) / 50)+2)
	} else if move.category == "Special" {
//		D = (((((2*attacker.level/5)+2) * move.basePower * (attacker.virtualStats["spa"] / defender.virtualStats["spd"])) / 50)+2)
	}
	var weather, crit, random, stab, type, burn, other: Double
	//calc weather mod
	if field.weather != "None" {
		if field.weather == "Rain" && move.type == "Water" {
			weather = 1.5
		} else if field.weather == "Rain" && move.type == "Fire" {
			weather = 0.5
		} else if field.weather == "Sun" && move.type == "Water" {
			weather = 0.5
		} else if field.weather == "Sun" && move.type == "Fire" {
			weather = 1.5
		}
	} else { weather = 1.0 }
	// crit mod to fix later
	crit = 1.0
	// random to make later
	random = 1.0
	//stab mod
	for type in attacker.types {
		if move.type == type {
			stab = 1.5
			break
		}
	}
	//type mod
	var defenderTypeTable: [String: Int] = defender.getPokemonWeaknesses(pokemonName: defender)
	//make iterator over dictionary here
	modifier = 1.0
	
	var modD = Double.init(D) * modifier
	finalD = Int.init(modD)
	
	
	
	return dmgResult
}

//func getFinalDamage(level: Int, modifier: Double, power: Int, d:, e: ) -> Int {
//	var finalD = Int()
//	var D = (((((2*level/5)+2) * power * (attack / defense)) / 50)+2)
//	var modD = Double.init(D) * modifier
//	finalD = Int.init(modD)
//
//
//
//	return finalD
//}


//----------------------------- Class-based resist search functions
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
