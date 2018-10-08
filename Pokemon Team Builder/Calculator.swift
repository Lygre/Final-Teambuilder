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

func getDamageResult(attacker: Pokemon, defender: Pokemon, move: Move, field: Field) -> (Int, Double) {
	var dmgResult: (Int, Double) = (1, 1.00)
	var _: Int = Int()
	var finalD = Int()
	var D: Double = Double()
//	var attack = Int()
//	var defense = Int()
	var modifier = Double()
	var adRatio: Double = Double()
	
	var percentHP: Double = Double()
	
	if move.category == "Physical" {
		adRatio = (Double.init(attacker.virtualStats["atk"]!) / Double.init(defender.virtualStats["def"]!))
	} else if move.category == "Special" {
		adRatio = (Double.init(attacker.virtualStats["spa"]!) / Double.init(defender.virtualStats["spd"]!))
	}

	D = (((((2.0*Double.init(attacker.level)/5.0)+2.0) * Double.init(move.basePower) * adRatio) / 50.0)+2.0)

	var terrain, weather, crit, random, stab, typeMod, other: Double
	//removed 'burn' var because do not have property for status added to class Pokemon yet
	
	//calc weather mod
	weather = 1.0
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
	//calc terrain mod
	terrain = 1.0
	if field.terrain != "None" {
		if field.terrain == "Psychic" && move.type == "Psychic" {
			terrain = 1.5
		} else if field.terrain == "Electric" && move.type == "Electric" {
			terrain = 1.5
		} else if field.terrain == "Grassy" && move.type == "Grass" {
			terrain = 1.5
		}
	} else { terrain = 1.0 }
	// crit mod to fix later
	crit = 1.0
	// random to make later
	random = 1.0
	//stab mod
	stab = 1.0
	for type in attacker.types {
		if move.type == type {
			stab = 1.5
			break
		}
	}
	//type mod
	typeMod = 1.0
	let defenderTypeTable: [String: Int] = defender.getPokemonWeaknesses(pokemonName: defender)
	//make iterator over dictionary here
	for (type, vector) in defenderTypeTable {
		if type == move.type {
			switch vector {
			case 1:
				typeMod = 1.0
			case 2:
				typeMod = 2.0
			case 4:
				typeMod = 4.0
			case -2:
				typeMod = 0.5
			case -4:
				typeMod = 0.25
			default:
				typeMod = 1.0
			}
		}
	}
	
	other = 1.0
	
	modifier = terrain * weather * crit * random * stab * typeMod * other
	
	let modD = D * modifier
	finalD = Int.init(modD)
	percentHP = modD / Double(defender.virtualStats["hp"]!)
	
	dmgResult = (finalD, percentHP)

//	for (move, dmg) in dmgResult {
//		print(move.name, dmg.0, dmg.1)
//	}
	
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
