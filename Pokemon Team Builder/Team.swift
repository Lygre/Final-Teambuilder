//
//  Team.swift
//  Test4
//
//  Created by Hugh Broome on 7/11/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

class Team: NSObject {
	@objc dynamic var members: [Pokemon]
	@objc dynamic var teamWeaknesses: [String: Int]
	@objc dynamic var teamCoverage: [String: [String: Bool]]
	// [Type: [Coverage: Bool, STAB: Bool]]
	@objc dynamic var additionalAttributes: [String: Bool]
	// stealthRocks, spikes, toxicSpikes, auroraVeil, lightScreen, reflect, statusMoves: thunderWave, willoWisp, slp status, toxic| defog, rapidSpin, regeneratorPivot, zMoveUser, mega

	override init() {
		members = [Pokemon]()
		teamWeaknesses = ["": 0]
		teamCoverage = ["": ["": false]]
		additionalAttributes = ["": false]
		
		super.init()
	}
	init(members: [Pokemon]) {
		self.members = members
		
		self.teamWeaknesses = ["": 0]
		self.teamCoverage = ["": ["": false]]
		self.additionalAttributes = ["": false]
		
		super.init()
	}
	// Moving on to Team methods
	// Method for calculating team weaknesses
	func determineTeamWeaknesses() -> [String: Int] {
		var teamWeaknessDict: [String: Int] = ["Bug": 0,
											   "Dark": 0,
											   "Dragon": 0,
											   "Electric": 0,
											   "Fairy": 0,
											   "Fighting": 0,
											   "Fire": 0,
											   "Flying": 0,
											   "Ghost": 0,
											   "Grass": 0,
											   "Ground": 0,
											   "Ice": 0,
											   "Normal": 0,
											   "Poison": 0,
											   "Psychic": 0,
											   "Rock": 0,
											   "Steel": 0,
											   "Water": 0]
		var immunities = [String]()
		
		for mon in members {
			let monWeaknessDict = mon.getPokemonWeaknesses(pokemonName: mon)
			for (type, scalar) in monWeaknessDict {
				if scalar == 0 {
					immunities.append(type)
//					teamWeaknessDict[type] = 1
				} else if scalar == 1 {
					//do nothing
				} else {
					teamWeaknessDict[type] = teamWeaknessDict[type]! + scalar
				}
			}
		}
		for (type, scalar) in teamWeaknessDict {
			if immunities.contains(type) {
				teamWeaknessDict[type] = 0
			} else if scalar == 0 {
				teamWeaknessDict[type] = 1
			} else {
				if self.members.count > 1 {
					teamWeaknessDict[type] = scalar / (self.members.count - 1)
				} else {
					teamWeaknessDict[type] = scalar / (self.members.count)
				}
			}
		}
		return teamWeaknessDict
	}
	
	// Method for calculating team type coverage
	func determineTeamCoverage() -> [String: [String: Bool]] {
		var coverageDict = [String: [String: Bool]]()
		for type in Dex.typeList {
			coverageDict[type] = ["Coverage": false, "STAB": false]
		}
		for mon in members {
			if mon.move1.category != "Status" {
				for type in mon.types {
					if mon.move1.type == type {
						// create translation for coverage/stab determination
						for (type, bool) in Dex.typeEffectiveness[mon.move1.type]! {
							if bool == true {
								coverageDict[type] = ["Coverage": true, "STAB": true]
							}
						}
					} else {
						for (type, bool) in Dex.typeEffectiveness[mon.move1.type]! {
							if bool == true {
								coverageDict[type]!["Coverage"] = true
							}
						}
					}
				}
			}
			if mon.move2.category != "Status" {
				for type in mon.types {
					if mon.move2.type == type {
						// create translation for coverage/stab determination
						for (type, bool) in Dex.typeEffectiveness[mon.move2.type]! {
							if bool == true {
								coverageDict[type] = ["Coverage": true, "STAB": true]
							}
						}
					} else {
						for (type, bool) in Dex.typeEffectiveness[mon.move2.type]! {
							if bool == true {
								coverageDict[type]!["Coverage"] = true
							}
						}
					}
				}
			}
			if mon.move3.category != "Status" {
				for type in mon.types {
					if mon.move3.type == type {
						// create translation for coverage/stab determination
						for (type, bool) in Dex.typeEffectiveness[mon.move3.type]! {
							if bool == true {
								coverageDict[type] = ["Coverage": true, "STAB": true]
							}
						}
					} else {
						for (type, bool) in Dex.typeEffectiveness[mon.move3.type]! {
							if bool == true {
								coverageDict[type]!["Coverage"] = true
							}
						}
					}
				}
			}
			if mon.move4.category != "Status" {
				for type in mon.types {
					if mon.move4.type == type {
						// create translation for coverage/stab determination
						for (type, bool) in Dex.typeEffectiveness[mon.move4.type]! {
							if bool == true {
								coverageDict[type] = ["Coverage": true, "STAB": true]
							}
						}
					} else {
						for (type, bool) in Dex.typeEffectiveness[mon.move4.type]! {
							if bool == true {
								coverageDict[type]!["Coverage"] = true
							}
						}
					}
				}
			}
		}
		return coverageDict
	}
	
	// Method for assessing additionalAttributes that team members allow us to meet
	func determineAttributes() -> [String: Bool] {
		var attrDict: [String: Bool] = [
			"Stealth Rock": false,
			"Sticky Web": false,
			"Spikes": false,
			"Light Screen": false,
			"Reflect": false,
			"Aurora Veil": false,
			"Defog": false,
			"Rapid Spin": false,
			"Taunt": false,
			"Phaser": false
		]
//			"statusMove": false
		let attrLabelArray = ["stealthrock", "stickyweb", "spikes", "lightscreen", "reflect", "auroraveil", "defog", "rapidspin", "taunt"]
		let phaserLabelArray = ["roar", "whirlwind", "dragontail", "circlethrow"]
		
		for mon in members {
			let monMoveArray: [Move] = [mon.move1, mon.move2, mon.move3, mon.move4]
			for move in monMoveArray {
				if attrLabelArray.contains(move.id) {
					attrDict[move.name] = true
				}
				if phaserLabelArray.contains(move.id) {
					attrDict["Phaser"] = true
				}
			}

		}
		
		return attrDict
	}
	
	func addMember(_ pokemon: Pokemon) {
		members.append(pokemon)
	}
}
