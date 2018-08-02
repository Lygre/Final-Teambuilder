//
//  Team.swift
//  Test4
//
//  Created by Hugh Broome on 7/11/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

struct Team {
	var members = [Pokemon]()
	var teamWeaknesses = [String: Int]()
	var teamCoverage = [String: [String: Bool]]()
	// [Type: [Coverage: Bool, STAB: Bool]]
	var additionalAttributes = [String: Bool]()
	// stealthRocks, spikes, toxicSpikes, auroraVeil, lightScreen, reflect, statusMoves: thunderWave, willoWisp, slp status, toxic| defog, rapidSpin, regeneratorPivot, zMoveUser, mega
	
//	init() {
//		self.members = [Pokemon]()
//	}
	// Moving on to Team methods
	// Method for calculating team weaknesses
	func determineTeamWeaknesses() -> [String: Int] {
		var teamWeaknessDict = [String: Int]()
		
		for mon in members {
			let monWeaknessDict = Pokemon.getPokemonWeaknesses(pokemonName: mon)
			for (type, scalar) in monWeaknessDict {
				if scalar == 0 {
					teamWeaknessDict[type] = 0
				} else {
					teamWeaknessDict[type]! += scalar
				}
			}
		}
		for (type, scalar) in teamWeaknessDict {
			if scalar < 0 {
				teamWeaknessDict[type] = (1 / scalar * -1)
			} else {
				teamWeaknessDict[type] = scalar / members.count
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
			for move in mon.moves {
				if move.category != "Status" {
					for type in mon.types {
						if move.type == type {
							// create translation for coverage/stab determination
							for (type, bool) in Dex.typeEffectiveness[move.type]! {
								if bool == true {
									coverageDict[type] = ["Coverage": true, "STAB": true]
								}
							}
						} else {
							for (type, bool) in Dex.typeEffectiveness[move.type]! {
								if bool == true {
									coverageDict[type]!["Coverage"] = true
								}
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
			"stealthrock": false,
			"stickyweb": false,
			"spikes": false,
			"lightscreen": false,
			"reflect": false,
			"auroraveil": false,
			"defog": false,
			"rapidspin": false,
			"taunt": false,
//			"phaser": false,
//			"statusMove": false
		]
		
		let attrLabelArray = ["stealthrock", "stickyweb", "spikes", "lightscreen", "reflect", "auroraveil", "defog", "rapidspin", "taunt"]
		
		for mon in members {
			for move in mon.moves {
				if attrLabelArray.contains(move.id) {
					attrDict[move.id] = true
				}
			}
		}
		
		return attrDict
	}
	
	mutating func addMember(_ pokemon: Pokemon) {
		members.append(pokemon)
	}
}
