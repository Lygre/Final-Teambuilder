//
//  ViewController.swift
//  Test4
//
//  Created by Hugh Broome on 7/4/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

class ResistSearchController: NSViewController {
	
	@IBOutlet weak var resistSearchString: NSTextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		Dex.initializeDex()
		Dex.defineTypeMatchups()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func resistSearch(_ sender: Any) {
		resultsString.stringValue = ""
		let resistSearchArray = resistSearchString.stringValue.components(separatedBy: ", ")
		let resultsArray = Dex.findResistances(resistTypes: resistSearchArray)
		for result in resultsArray {
			resultsString.stringValue += "\(result) \n"
		}
	}
	@IBOutlet weak var resultsString: NSTextField!
	
}


class TeamBuilderController: NSViewController {
	
	@IBOutlet var searchResultsController: NSArrayController!
	
	@IBOutlet weak var searchTextField: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		Dex.initializeDex()
//		Dex.defineTypeMatchups()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func searchClicked(_ sender: AnyObject) {
		if (searchTextField.stringValue == "") {
			return
		}
		
		let dexSearchResults = Dex.searchDex(searchParam: searchTextField.stringValue)
//		let finalResults = convertPokemonToDict(dexSearchResults).map { return $0["species"] }
		let finalResults = convertPokemonToDict(dexSearchResults)
//			.map { return ($0["species"], $0["num"]) }
//			.map { return Result(dictionary: $0) }
		
//		self.searchResultsController.content = convertPokemonToString(Dex.searchDex(searchParam: searchTextField.stringValue))
		self.searchResultsController.content = finalResults
		
		print(self.searchResultsController.content!)
	}
	
	// Button to add members to Team

	
}

//
//extension TeamBuilderController {
//	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
//		if commandSelector == #selector(insertNewline(_:)) {
//			searchClicked(searchTextField)
//		}
//		return false
//	}
//}

var teamMaster = Team()

class TeamViewController: NSViewController, ImportDelegate {
	
	static let notificationName = Notification.Name("importingPokemon")
	
	@IBOutlet var teamController: NSArrayController!
	@IBOutlet var suggestedMonController: NSArrayController!
	
	//@IBOutlet var teamMembersController: NSArrayController!
	@IBOutlet weak var searchForTeam: NSTextField!
	@IBOutlet weak var arrayImage: NSImageView!
	@IBOutlet weak var tableView: NSTableView!
	
	@IBOutlet weak var baseHP: NSTextField!
	@IBOutlet weak var baseATK: NSTextField!
	@IBOutlet weak var baseDEF: NSTextField!
	@IBOutlet weak var baseSPA: NSTextField!
	@IBOutlet weak var baseSPD: NSTextField!
	@IBOutlet weak var baseSPE: NSTextField!
	
	@IBOutlet weak var hpEVLabel: NSTextField!
	@IBOutlet weak var atkEVLabel: NSTextField!
	@IBOutlet weak var defEVLabel: NSTextField!
	@IBOutlet weak var spaEVLabel: NSTextField!
	@IBOutlet weak var spdEVLabel: NSTextField!
	@IBOutlet weak var speEVLabel: NSTextField!
	
	
	@IBOutlet weak var hpLevel: NSLevelIndicator!
	@IBOutlet weak var atkLevel: NSLevelIndicator!
	@IBOutlet weak var defLevel: NSLevelIndicator!
	@IBOutlet weak var spaLevel: NSLevelIndicator!
	@IBOutlet weak var spdLevel: NSLevelIndicator!
	@IBOutlet weak var speLevel: NSLevelIndicator!
	
	@IBOutlet weak var hpSlider: NSSlider!
	@IBOutlet weak var atkSlider: NSSlider!
	@IBOutlet weak var defSlider: NSSlider!
	@IBOutlet weak var spaSlider: NSSlider!
	@IBOutlet weak var spdSlider: NSSlider!
	@IBOutlet weak var speSlider: NSSlider!
	
	@IBOutlet weak var hpSliderCell: NSSliderCell!
	@IBOutlet weak var atkSliderCell: NSSliderCell!
	@IBOutlet weak var defSliderCell: NSSliderCell!
	@IBOutlet weak var spaSliderCell: NSSliderCell!
	@IBOutlet weak var spdSliderCell: NSSliderCell!
	@IBOutlet weak var speSliderCell: NSSliderCell!
	

	@IBOutlet weak var monWeaknesses: NSTextField!
	@IBOutlet weak var monResistances: NSTextField!
	@IBOutlet weak var monImmunities: NSTextField!
	
	@IBOutlet weak var itemSelectButton: NSPopUpButton!
	
	@IBOutlet weak var move1Select: NSPopUpButton!
	@IBOutlet weak var move2Select: NSPopUpButton!
	@IBOutlet weak var move3Select: NSPopUpButton!
	@IBOutlet weak var move4Select: NSPopUpButton!
	
	@IBOutlet weak var actualHP: NSTextField!
	@IBOutlet weak var actualATK: NSTextField!
	@IBOutlet weak var actualDEF: NSTextField!
	@IBOutlet weak var actualSPA: NSTextField!
	@IBOutlet weak var actualSPD: NSTextField!
	@IBOutlet weak var actualSPE: NSTextField!
	
	//virutal stat outlets
	
	
	@IBOutlet weak var virtualHP: NSTextField!
	@IBOutlet weak var virtualATK: NSTextField!
	@IBOutlet weak var virtualDEF: NSTextField!
	@IBOutlet weak var virtualSPA: NSTextField!
	@IBOutlet weak var virtualSPD: NSTextField!
	@IBOutlet weak var virtualSPE: NSTextField!
	
	@IBOutlet weak var teamInteractionTableView: NSTableView!

	
//	@objc dynamic var weaknessTable:
	
	@objc dynamic var team = [Pokemon]()
	
	@objc dynamic var team2test = Team()
	
	@objc dynamic var teamWeaknessTableBind: [String: [String: NSImage]] = [:]
	
	@objc dynamic var teamCoverageTableBind: [String: [String: Bool]] = [:]
	
	@objc dynamic var teamAttributeTableBind: [String: Bool] = [:]
	
	@objc dynamic var colorTable: [String: NSColor] = ["Weak": NSColor.systemRed,
													   "Resist": NSColor.systemGreen,
													   "Neutral": NSColor.systemGray]
	
	@objc dynamic var suggestedMonTableBind = [Pokemon]()
	
	@objc dynamic var itemList = [Item]()
	
	@objc dynamic var learnsetMoves = [Move]()
	
	@objc dynamic var movesToSet = [String: Move]()
	
	@objc dynamic var natureList = [String]()
	
	@objc dynamic var levelArray = [Int]()
	
	@objc dynamic var selectedMonImage = NSImage()
	
	@objc dynamic var evHPBind = Int()
	@objc dynamic var evATKBind = Int()
	@objc dynamic var evDEFBind = Int()
	@objc dynamic var evSPABind = Int()
	@objc dynamic var evSPDBind = Int()
	@objc dynamic var evSPEBind = Int()
	
	@objc dynamic var evHPMaxValueBind = Double()
	@objc dynamic var evATKMaxValueBind = Double()
	@objc dynamic var evDEFMaxValueBind = Double()
	@objc dynamic var evSPAMaxValueBind = Double()
	@objc dynamic var evSPDMaxValueBind = Double()
	@objc dynamic var evSPEMaxValueBind = Double()
	
	@IBOutlet weak var hpIVs: NSTextField!
	@IBOutlet weak var atkIVs: NSTextField!
	@IBOutlet weak var defIVs: NSTextField!
	@IBOutlet weak var spaIVs: NSTextField!
	@IBOutlet weak var spdIVs: NSTextField!
	@IBOutlet weak var speIVs: NSTextField!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: TeamViewController.notificationName, object: nil)
//
		// Do any additional setup after loading the view.
		Dex.initializeDex()
		Dex.defineTypeMatchups()
		MoveDex.initializeMoveDex()
		ItemDex.initializeItemDex()
		for item in ItemDex.itemDexArray {
			itemList.append(item)
		}
		for (nature, _) in Dex.natureList {
			natureList.append(nature)
		}
		natureList.sort()
		repeat {
			levelArray.append(levelArray.count + 1)
		} while levelArray.count < 100
		
		updateSliders()
		updateTeam()
		
//		tableView.canDragRows(with: tableView.selectedRowIndexes, at: NSPoint.init())
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
//			updateViewConstraints()
			
		}
	}
	
	func updateSliders() {
		hpSlider.minValue = 0.0
		hpSlider.maxValue = 252.0
		hpSlider.numberOfTickMarks = 63
		hpSlider.allowsTickMarkValuesOnly = false
		hpSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["hp"] = hpSlider.integerValue
		
		atkSlider.minValue = 0.0
		atkSlider.maxValue = 252.0
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = false
		atkSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["atk"] = atkSlider.integerValue
		
		defSlider.minValue = 0.0
		defSlider.maxValue = 252.0
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = false
		defSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["def"] = defSlider.integerValue
		
		spaSlider.minValue = 0.0
		spaSlider.maxValue = 252.0
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = false
		spaSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spa"] = spaSlider.integerValue
		
		spdSlider.minValue = 0.0
		spdSlider.maxValue = 252.0
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = false
		spdSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spd"] = spdSlider.integerValue
		
		speSlider.minValue = 0.0
		speSlider.maxValue = 252.0
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = false
		speSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spe"] = speSlider.integerValue
		
		//update pokemon
		
	}
	
	func updateTeam() {
		teamMaster = Team(members: team)
		teamMaster.teamWeaknesses = teamMaster.determineTeamWeaknesses()
		teamMaster.teamCoverage = teamMaster.determineTeamCoverage()
		teamMaster.additionalAttributes = teamMaster.determineAttributes()

		team2test = Team(members: team)
		team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
		team2test.teamCoverage = team2test.determineTeamCoverage()
		team2test.additionalAttributes = team2test.determineAttributes()
		
		team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
		teamWeaknessTableBind = [:]
		for mon in team2test.members {
			teamWeaknessTableBind[mon.species] = determineMonInteractionIconTable(pokemon: mon)
		}
		teamWeaknessTableBind["~~~"] = team2test.determineCumulativeInteractionIconTable()

		teamCoverageTableBind = team2test.teamCoverage
		teamAttributeTableBind = team2test.additionalAttributes
		
		suggestedMonTableBind = findSuggestedMons(team: teamMaster)
		
	}
	
	func updatePokemon() {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = team[index]
			//get sprite
			let imgFile = dexNumToSprite(mon)
			arrayImage.image = NSImage(imageLiteralResourceName: imgFile!)
			
			//get base stat values for selected mon
			baseHP.stringValue = "\(mon.baseStats["hp"] ?? 0)"
			baseATK.stringValue = "\(mon.baseStats["atk"] ?? 0)"
			baseDEF.stringValue = "\(mon.baseStats["def"] ?? 0)"
			baseSPA.stringValue = "\(mon.baseStats["spa"] ?? 0)"
			baseSPD.stringValue = "\(mon.baseStats["spd"] ?? 0)"
			baseSPE.stringValue = "\(mon.baseStats["spe"] ?? 0)"
			
			//get actual stat values for selected mon
			mon.actualStats = Pokemon.calcStats(pokemon: mon)
			actualHP.stringValue = "\(mon.actualStats["hp"] ?? 0)"
			actualATK.stringValue = "\(mon.actualStats["atk"] ?? 0)"
			actualDEF.stringValue = "\(mon.actualStats["def"] ?? 0)"
			actualSPA.stringValue = "\(mon.actualStats["spa"] ?? 0)"
			actualSPD.stringValue = "\(mon.actualStats["spd"] ?? 0)"
			actualSPE.stringValue = "\(mon.actualStats["spe"] ?? 0)"
			
			let evs = mon.eVs
			hpEVLabel.stringValue = "\(evs["hp"] ?? 0)"
			atkEVLabel.stringValue = "\(evs["atk"] ?? 0)"
			defEVLabel.stringValue = "\(evs["def"] ?? 0)"
			spaEVLabel.stringValue = "\(evs["spa"] ?? 0)"
			spdEVLabel.stringValue = "\(evs["spd"] ?? 0)"
			speEVLabel.stringValue = "\(evs["spe"] ?? 0)"
			
			let ivs = mon.iVs
			hpIVs.integerValue = ivs["hp"] ?? 0
			atkIVs.integerValue = ivs["atk"] ?? 0
			defIVs.integerValue = ivs["def"] ?? 0
			spaIVs.integerValue = ivs["spa"] ?? 0
			spdIVs.integerValue = ivs["spd"] ?? 0
			speIVs.integerValue = ivs["spe"] ?? 0
			
			// get virtual stat values for selected mon
			mon.virtualStats = Pokemon.calcVirtualStats(pokemon: mon)
			virtualHP.stringValue = "\(mon.virtualStats["hp"] ?? 0)"
			virtualATK.stringValue = "\(mon.virtualStats["atk"] ?? 0)"
			virtualDEF.stringValue = "\(mon.virtualStats["def"] ?? 0)"
			virtualSPA.stringValue = "\(mon.virtualStats["spa"] ?? 0)"
			virtualSPD.stringValue = "\(mon.virtualStats["spd"] ?? 0)"
			virtualSPE.stringValue = "\(mon.virtualStats["spe"] ?? 0)"
			
			// create bar graph level bars for corresponding baseStats
			
			hpLevel.integerValue = mon.virtualStats["hp"]!
			atkLevel.integerValue = mon.virtualStats["atk"]!
			defLevel.integerValue = mon.virtualStats["def"]!
			spaLevel.integerValue = mon.virtualStats["spa"]!
			spdLevel.integerValue = mon.virtualStats["spd"]!
			speLevel.integerValue = mon.virtualStats["spe"]!
			//alter level objects max value
			var maxStatsForLevel = Pokemon.calcMaxStats()
			hpLevel.maxValue = Double.init(maxStatsForLevel["hp"]!)
			atkLevel.maxValue = Double.init(maxStatsForLevel["atk"]!)
			defLevel.maxValue = Double.init(maxStatsForLevel["def"]!)
			spaLevel.maxValue = Double.init(maxStatsForLevel["spa"]!)
			spdLevel.maxValue = Double.init(maxStatsForLevel["spd"]!)
			speLevel.maxValue = Double.init(maxStatsForLevel["spe"]!)
			
			// populate mon type interaction table for selected mon
			let monWeaknessesDict: [String: Int] = mon.getPokemonWeaknesses(pokemonName: mon)
			monImmunities.stringValue = ""
			monResistances.stringValue = ""
			monResistances.textColor = NSColor.systemGreen
			monWeaknesses.stringValue = ""
			monWeaknesses.textColor = NSColor.systemRed
			for (type, scalar) in monWeaknessesDict {
				if scalar > 1 {
					monWeaknesses.stringValue += "\(type)\n"
				} else if scalar < 0 {
					monResistances.stringValue += "\(type)\n"
				} else if scalar == 0 {
					monImmunities.stringValue += "\(type)\n"
				}
			}
			// populate learnset table for selected mon
			let learnset = mon.getPokemonLearnset(pokemon: mon)
			learnsetMoves = [Move]()
			for move in learnset {
				let moveToAdd = MoveDex.searchMovedex(searchParam: move)
				learnsetMoves.append(moveToAdd)
			}
			//show any current moves set and update them in view
			if mon.move1.name != "Struggle" {
				move1Select.selectItem(withTitle: mon.move1.name)
			}
			if mon.move2.name != "Struggle" {
				move2Select.selectItem(withTitle: mon.move2.name)
			}
			if mon.move3.name != "Struggle" {
				move3Select.selectItem(withTitle: mon.move3.name)
			}
			if mon.move4.name != "Struggle" {
				move4Select.selectItem(withTitle: mon.move4.name)
			}
			//add mon's current item to itemList
			itemList.append(mon.item)
			
			//update EVs for evTableBind
			evHPBind = evs["hp"]!
			evATKBind = evs["atk"]!
			evDEFBind = evs["def"]!
			evSPABind = evs["spa"]!
			evSPDBind = evs["spd"]!
			evSPEBind = evs["spe"]!
			
			determineMaxValueForEVSliders()
			
			teamWeaknessTableBind[mon.species] = determineMonInteractionIconTable(pokemon: mon)
			team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
			teamWeaknessTableBind["~~~"] = team2test.determineCumulativeInteractionIconTable()
			teamCoverageTableBind = team2test.determineTeamCoverage()
			teamAttributeTableBind = team2test.determineAttributes()
		}
	}
	
	@IBAction func addToTeam(_ sender: Any) {
		if (searchForTeam.stringValue == "") {
			return
		}

		let monToAdd = Dex.searchDex(searchParam: searchForTeam.stringValue)[0]
		//set default level at 100
		monToAdd.level = 100
		//set default IVs all to 31
		for (stat, _) in monToAdd.iVs {
			monToAdd.iVs[stat] = 31
		}
		monToAdd.nature = "mild"
		//calc actual stats
		monToAdd.actualStats = Pokemon.calcStats(pokemon: monToAdd)
		monToAdd.virtualStats = Pokemon.calcVirtualStats(pokemon: monToAdd)
		//add pokemon object to objc team variable (bound to array controller)
		self.team.append(monToAdd)
		if team2test.members.isEmpty {
			team2test = Team(members: team)
		} else {
			team2test.addMember(monToAdd)
		}

		team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
		teamWeaknessTableBind[monToAdd.species] = determineMonInteractionIconTable(pokemon: monToAdd)
		teamWeaknessTableBind["~~~"] = team2test.determineCumulativeInteractionIconTable()
		team2test.additionalAttributes = team2test.determineAttributes()

		//---------
		team2test.teamCoverage = team2test.determineTeamCoverage()
		
		teamMaster = team2test
		suggestedMonTableBind = findSuggestedMons(team: teamMaster)
		print(suggestedMonTableBind)
		updateTeam()
	}

	func addToTeam2(pokemon: Pokemon) {
		
		let monToAdd: Pokemon = pokemon
		monToAdd.actualStats = Pokemon.calcStats(pokemon: monToAdd)
		monToAdd.virtualStats = Pokemon.calcVirtualStats(pokemon: monToAdd)
		
		self.team.append(monToAdd)
		if team2test.members.isEmpty {
			team2test = Team(members: team)
		} else {
			team2test.addMember(monToAdd)
		}
		
		team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
		
		for mon in team2test.members {
			teamWeaknessTableBind[mon.species] = determineMonInteractionIconTable(pokemon: mon)
		}
		teamWeaknessTableBind["~~~"] = team2test.determineCumulativeInteractionIconTable()
		
		team2test.additionalAttributes = team2test.determineAttributes()
		team2test.teamCoverage = team2test.determineTeamCoverage()
		
		teamCoverageTableBind = team2test.teamCoverage
		teamAttributeTableBind = team2test.additionalAttributes
		
		teamMaster = team2test
		suggestedMonTableBind = findSuggestedMons(team: teamMaster)
//		print(suggestedMonTableBind)
		updateTeam()

	}

	//remove from team
	
	@IBAction func removeFromTeam(_ sender: Any) {
//		let mon: Pokemon? = team[tableView.selectedRow]
//		let removedMon: Pokemon = self.team.remove(at: tableView.selectedRow)
		team.remove(at: tableView.selectedRow)

		updateTeam()
	}
	
	
	@IBAction func alteredIVs(_ sender: Any) {
		let mon: Pokemon = team[tableView.selectedRow]
		
		mon.iVs["hp"] = hpIVs.integerValue
		mon.iVs["atk"] = atkIVs.integerValue
		mon.iVs["def"] = defIVs.integerValue
		mon.iVs["spa"] = spaIVs.integerValue
		mon.iVs["spd"] = spdIVs.integerValue
		mon.iVs["spe"] = speIVs.integerValue
		updatePokemon()
	}
	
	
	
	@IBAction func teamTypeTableAction(_ sender: Any) {
		
	}

	
	@IBAction func tableViewAction(_ sender: Any) {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = team[index]
			
			// get sprite for selected mon
			let imgFile = dexNumToSprite(mon)
			arrayImage.image = NSImage(imageLiteralResourceName: imgFile!)
			
			//get base stat values for selected mon
			baseHP.stringValue = "\(mon.baseStats["hp"] ?? 0)"
			baseATK.stringValue = "\(mon.baseStats["atk"] ?? 0)"
			baseDEF.stringValue = "\(mon.baseStats["def"] ?? 0)"
			baseSPA.stringValue = "\(mon.baseStats["spa"] ?? 0)"
			baseSPD.stringValue = "\(mon.baseStats["spd"] ?? 0)"
			baseSPE.stringValue = "\(mon.baseStats["spe"] ?? 0)"
			
			//get actual stat values for selected mon
			mon.actualStats = Pokemon.calcStats(pokemon: mon)
			actualHP.stringValue = "\(mon.actualStats["hp"] ?? 0)"
			actualATK.stringValue = "\(mon.actualStats["atk"] ?? 0)"
			actualDEF.stringValue = "\(mon.actualStats["def"] ?? 0)"
			actualSPA.stringValue = "\(mon.actualStats["spa"] ?? 0)"
			actualSPD.stringValue = "\(mon.actualStats["spd"] ?? 0)"
			actualSPE.stringValue = "\(mon.actualStats["spe"] ?? 0)"
			
			let evs = mon.eVs
			print(evs)
			hpEVLabel.stringValue = "\(evs["hp"] ?? 0)"
			atkEVLabel.stringValue = "\(evs["atk"] ?? 0)"
			defEVLabel.stringValue = "\(evs["def"] ?? 0)"
			spaEVLabel.stringValue = "\(evs["spa"] ?? 0)"
			spdEVLabel.stringValue = "\(evs["spd"] ?? 1)"
			speEVLabel.stringValue = "\(evs["spe"] ?? 0)"
			
			let ivs = mon.iVs
			hpIVs.integerValue = ivs["hp"] ?? 0
			atkIVs.integerValue = ivs["atk"] ?? 0
			defIVs.integerValue = ivs["def"] ?? 0
			spaIVs.integerValue = ivs["spa"] ?? 0
			spdIVs.integerValue = ivs["spd"] ?? 0
			speIVs.integerValue = ivs["spe"] ?? 0

			// get virtual stat values for selected mon
			mon.virtualStats = Pokemon.calcVirtualStats(pokemon: mon)
			virtualHP.stringValue = "\(mon.virtualStats["hp"] ?? 0)"
			virtualATK.stringValue = "\(mon.virtualStats["atk"] ?? 0)"
			virtualDEF.stringValue = "\(mon.virtualStats["def"] ?? 0)"
			virtualSPA.stringValue = "\(mon.virtualStats["spa"] ?? 0)"
			virtualSPD.stringValue = "\(mon.virtualStats["spd"] ?? 0)"
			virtualSPE.stringValue = "\(mon.virtualStats["spe"] ?? 0)"
			
			// create bar graph level bars for corresponding baseStats
			
			hpLevel.integerValue = mon.virtualStats["hp"]!
			atkLevel.integerValue = mon.virtualStats["atk"]!
			defLevel.integerValue = mon.virtualStats["def"]!
			spaLevel.integerValue = mon.virtualStats["spa"]!
			spdLevel.integerValue = mon.virtualStats["spd"]!
			speLevel.integerValue = mon.virtualStats["spe"]!
			//alter level objects max value
			var maxStatsForLevel = Pokemon.calcMaxStats()
			hpLevel.maxValue = Double.init(maxStatsForLevel["hp"]!)
			atkLevel.maxValue = Double.init(maxStatsForLevel["atk"]!)
			defLevel.maxValue = Double.init(maxStatsForLevel["def"]!)
			spaLevel.maxValue = Double.init(maxStatsForLevel["spa"]!)
			spdLevel.maxValue = Double.init(maxStatsForLevel["spd"]!)
			speLevel.maxValue = Double.init(maxStatsForLevel["spe"]!)
			
			// populate mon type interaction table for selected mon
			let monWeaknessesDict: [String: Int] = mon.getPokemonWeaknesses(pokemonName: mon)
			monImmunities.stringValue = ""
			monResistances.stringValue = ""
			monResistances.textColor = NSColor.systemGreen
			monWeaknesses.stringValue = ""
			monWeaknesses.textColor = NSColor.systemRed
			for (type, scalar) in monWeaknessesDict {
				if scalar > 1 {
					monWeaknesses.stringValue += "\(type)\n"
				} else if scalar < 0 {
					monResistances.stringValue += "\(type)\n"
				} else if scalar == 0 {
					monImmunities.stringValue += "\(type)\n"
				}
			}
			// populate learnset table for selected mon
			let learnset = mon.getPokemonLearnset(pokemon: mon)
			learnsetMoves = [Move]()
			for move in learnset {
				let moveToAdd = MoveDex.searchMovedex(searchParam: move)
				learnsetMoves.append(moveToAdd)
			}
			//show any current moves set and update them in view
			if mon.move1.name != "Struggle" {
				move1Select.selectItem(withTitle: mon.move1.name)
			}
			if mon.move2.name != "Struggle" {
				move2Select.selectItem(withTitle: mon.move2.name)
			}
			if mon.move3.name != "Struggle" {
				move3Select.selectItem(withTitle: mon.move3.name)
			}
			if mon.move4.name != "Struggle" {
				move4Select.selectItem(withTitle: mon.move4.name)
			}
			//add mon's current item to itemList
			itemList.append(mon.item)
			
			//update EVs for evTableBind
			evHPBind = evs["hp"]!
			evATKBind = evs["atk"]!
			evDEFBind = evs["def"]!
			evSPABind = evs["spa"]!
			evSPDBind = evs["spd"]!
			evSPEBind = evs["spe"]!
			
			determineMaxValueForEVSliders()
			
			teamWeaknessTableBind[mon.species] = determineMonInteractionIconTable(pokemon: mon)
			team2test.teamWeaknesses = team2test.determineTeamWeaknesses()
			teamWeaknessTableBind["~~~"] = team2test.determineCumulativeInteractionIconTable()
			teamCoverageTableBind = team2test.determineTeamCoverage()
			teamAttributeTableBind = team2test.determineAttributes()
		}
	}
	
	func getEVAllowedChange() -> Bool {
		let evSliderSum: Int = hpSlider.integerValue + atkSlider.integerValue + defSlider.integerValue + spaSlider.integerValue + spdSlider.integerValue + speSlider.integerValue
		if evSliderSum < 511 { return true }
		else { return false }
	}
	
	func determineMaxSliderValue(currentValue: Int) -> Double {
		var allowedMaxValue: Int
		let evSliderSum: Int = hpSlider.integerValue + atkSlider.integerValue + defSlider.integerValue + spaSlider.integerValue + spdSlider.integerValue + speSlider.integerValue
		allowedMaxValue = 510 - evSliderSum

		if allowedMaxValue > 252 {
			allowedMaxValue = 252
		} else if (allowedMaxValue + currentValue) < 253 {
			allowedMaxValue = allowedMaxValue + currentValue
		} else {
			allowedMaxValue = 252
		}
//		print(allowedMaxValue)
		let returnDouble = Double.init(allowedMaxValue)
		return returnDouble
	}
	
	func determineMaxValueForEVSliders() {
		evHPMaxValueBind = determineMaxSliderValue(currentValue: hpSlider.integerValue)
		evATKMaxValueBind = determineMaxSliderValue(currentValue: atkSlider.integerValue)
		evDEFMaxValueBind = determineMaxSliderValue(currentValue: defSlider.integerValue)
		evSPAMaxValueBind = determineMaxSliderValue(currentValue: spaSlider.integerValue)
		evSPDMaxValueBind = determineMaxSliderValue(currentValue: spdSlider.integerValue)
		evSPEMaxValueBind = determineMaxSliderValue(currentValue: speSlider.integerValue)
	}
	
	@IBAction func hpSliderAction(_ sender: Any) {
		hpSlider.minValue = 0.0
//		hpSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		hpSlider.numberOfTickMarks = 63
		hpSlider.allowsTickMarkValuesOnly = false
		hpSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["hp"] = hpSlider.integerValue
//				print(mon.eVs["hp"]!)
				
				//update pokemon
				updatePokemon()
			}
		} else {
			return
//			let defaultPositon = hpSliderCell.rectOfTickMark(at: 4)
//			hpSliderCell.drawKnob(defaultPositon)
		}
	}

	@IBAction func atkSliderAction(_ sender: Any) {
		atkSlider.minValue = 0.0
//		atkSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = false
		atkSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["atk"] = atkSlider.integerValue
//				print(mon.eVs["atk"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}
	
	@IBAction func defSliderAction(_ sender: Any) {
		defSlider.minValue = 0.0
//		defSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = false
		defSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["def"] = defSlider.integerValue
//				print(mon.eVs["def"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}
	
	@IBAction func spaSliderAction(_ sender: Any) {
		spaSlider.minValue = 0.0
//		spaSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = false
		spaSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spa"] = spaSlider.integerValue
//				print(mon.eVs["spa"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}

	@IBAction func spdSliderAction(_ sender: Any) {
		spdSlider.minValue = 0.0
//		spdSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = false
		spdSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spd"] = spdSlider.integerValue
//				print(mon.eVs["spd"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}

	@IBAction func speSliderAction(_ sender: Any) {
		speSlider.minValue = 0.0
//		speSlider.maxValue = 252.0
		determineMaxValueForEVSliders()
		// possibly able to put a method to determine what max value should be using default value
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = false
		speSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spe"] = speSlider.integerValue
//				print(mon.eVs["spe"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}
	
	
	@IBAction func itemSelectAction(_ sender: Any) {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = team[index]
			mon.virtualStats = Pokemon.calcVirtualStats(pokemon: mon)
			virtualHP.stringValue = "\(mon.virtualStats["hp"] ?? 0)"
			virtualATK.stringValue = "\(mon.virtualStats["atk"] ?? 0)"
			virtualDEF.stringValue = "\(mon.virtualStats["def"] ?? 0)"
			virtualSPA.stringValue = "\(mon.virtualStats["spa"] ?? 0)"
			virtualSPD.stringValue = "\(mon.virtualStats["spd"] ?? 0)"
			virtualSPE.stringValue = "\(mon.virtualStats["spe"] ?? 0)"
		}
		//update pokemon
		updatePokemon()
	}
	
	@IBAction func move1Selected(_ sender: Any) {
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move2Selected(_ sender: Any) {
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move3Selected(_ sender: Any) {
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move4Selected(_ sender: Any) {
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	
	// Nature select action
	@IBAction func abilitySelected(_ sender: Any) {
		updatePokemon()
		updateTeam()
	}
	
	
	@IBAction func natureSelected(_ sender: Any) {
		let index = tableView.selectedRow
		if index > -1 {
			let mon = team[index]
			mon.actualStats = Pokemon.calcStats(pokemon: mon)
			actualHP.stringValue = "\(mon.actualStats["hp"] ?? 0)"
			actualATK.stringValue = "\(mon.actualStats["atk"] ?? 0)"
			actualDEF.stringValue = "\(mon.actualStats["def"] ?? 0)"
			actualSPA.stringValue = "\(mon.actualStats["spa"] ?? 0)"
			actualSPD.stringValue = "\(mon.actualStats["spd"] ?? 0)"
			actualSPE.stringValue = "\(mon.actualStats["spe"] ?? 0)"
			
			mon.virtualStats = Pokemon.calcVirtualStats(pokemon: mon)
			virtualHP.stringValue = "\(mon.virtualStats["hp"] ?? 0)"
			virtualATK.stringValue = "\(mon.virtualStats["atk"] ?? 0)"
			virtualDEF.stringValue = "\(mon.virtualStats["def"] ?? 0)"
			virtualSPA.stringValue = "\(mon.virtualStats["spa"] ?? 0)"
			virtualSPD.stringValue = "\(mon.virtualStats["spd"] ?? 0)"
			virtualSPE.stringValue = "\(mon.virtualStats["spe"] ?? 0)"
		}
		//update pokemon
		updatePokemon()
	}
	
	
	@IBAction func importMonClicked(_ sender: Any) {
		let vc = ImportViewController(nibName: "ImportViewController", bundle: nil)
		vc.teamViewController = self
		vc.delegate = self
	}
	
	
	@IBAction func exportTeam(_ sender: Any) {
		//placeholder function to check whatever needed to console
		let numberOfTeamMembers = tableView.numberOfRows
		var output: String = ""
		
		if numberOfTeamMembers > 0 {
			for mon in team {
				output.append("\(mon.species) @ \(mon.item.name)\n")
				output.append("Ability: \(mon.ability)\n")
				if mon.eVs != ["hp": 0, "atk": 0, "def": 0, "spa": 0, "spd": 0, "spe": 0] {
					var evString: String = "EVs: "
					for (stat, value) in mon.eVs {
						if value != 0 {
							evString.append("\(value) \(stat) - ")
						}
					}
					evString = evString.replacingOccurrences(of: "-", with: "/")
					evString.removeLast(3)
					evString.append("\n")
					output.append(evString)
					
				}
				var natureString: String = "\(mon.nature)"
				natureString = natureString.capitalized
				natureString.append(" Nature\n")
				output.append(natureString)
				
				//come back later and address IV exceptions here
				output.append("- \(mon.move1.name)\n")
				output.append("- \(mon.move2.name)\n")
				output.append("- \(mon.move3.name)\n")
				output.append("- \(mon.move4.name)\n")
				output.append("\n")
			}
			
			let pasteboard = NSPasteboard.general
			pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
			pasteboard.setString(output, forType: NSPasteboard.PasteboardType.string)

		}
	}
	
//	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//		if segue.destinationController is ImportViewController {
//			let vc = segue.destinationController as? ImportViewController
//			vc?.monToImport = Pokemon()
//		}
//	}
//
//	func onUserAction(data: String) {
//		print("Data received: \(data)")
//	}
	
//	 --------- objc functions
//	 for receiving data from import view controller
	@objc func onNotification(notification: Notification) {
		print(notification)
	}

}

extension TeamViewController {
	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if commandSelector == #selector(insertNewline(_:)) {
			addToTeam(searchForTeam)
		}
		return false
	}
}

class CalcViewController: NSViewController {
	
	@objc dynamic var moveDamageTableBind: [String: [String: Any]] = [:]
	
	@objc dynamic var moveDamageTableBind2: [String: [String: Any]] = [:]
	
	@objc dynamic var team: Team = teamMaster
	
	@objc dynamic var attackingMon = Pokemon()
	
	@objc dynamic var defendingMon = Pokemon()
	
	@objc dynamic var currentField = Field()
	
	@objc dynamic var pokedex = [Pokemon]()
	
	@objc dynamic var itemList = [Item]()
	
	@objc dynamic var natureList = [String]()
	
	@objc dynamic var learnsetMoves = [Move]()
	
	@objc dynamic var levelArray = [Int]()
	
	
	@IBOutlet weak var hpSlider: NSSlider!
	@IBOutlet weak var atkSlider: NSSlider!
	@IBOutlet weak var defSlider: NSSlider!
	@IBOutlet weak var spaSlider: NSSlider!
	@IBOutlet weak var spdSlider: NSSlider!
	@IBOutlet weak var speSlider: NSSlider!
	
	@IBOutlet weak var hpLabel: NSTextField!
	@IBOutlet weak var atkLabel: NSTextField!
	@IBOutlet weak var defLabel: NSTextField!
	@IBOutlet weak var spaLabel: NSTextField!
	@IBOutlet weak var spdLabel: NSTextField!
	@IBOutlet weak var speLabel: NSTextField!
	
	@IBOutlet weak var virtualHP: NSTextField!
	@IBOutlet weak var virtualATK: NSTextField!
	@IBOutlet weak var virtualDEF: NSTextField!
	@IBOutlet weak var virtualSPA: NSTextField!
	@IBOutlet weak var virtualSPD: NSTextField!
	@IBOutlet weak var virtualSPE: NSTextField!
	
	@IBOutlet weak var atkStepper2: NSStepper!
	@IBOutlet weak var atkBoostTextField2: NSTextField!
	@IBOutlet weak var defStepper2: NSStepper!
	@IBOutlet weak var defBoostTextField2: NSTextField!
	@IBOutlet weak var spaStepper2: NSStepper!
	@IBOutlet weak var spaBoostTextField2: NSTextField!
	@IBOutlet weak var spdStepper2: NSStepper!
	@IBOutlet weak var spdBoostTextField2: NSTextField!
	@IBOutlet weak var speStepper2: NSStepper!
	@IBOutlet weak var speBoostTextField2: NSTextField!
	
	@IBOutlet weak var atkStepper: NSStepper!
	@IBOutlet weak var atkBoostTextField: NSTextField!
	@IBOutlet weak var defStepper: NSStepper!
	@IBOutlet weak var defBoostTextField: NSTextField!
	@IBOutlet weak var spaStepper: NSStepper!
	@IBOutlet weak var spaBoostTextField: NSTextField!
	@IBOutlet weak var spdStepper: NSStepper!
	@IBOutlet weak var spdBoostTextField: NSTextField!
	@IBOutlet weak var speStepper: NSStepper!
	@IBOutlet weak var speBoostTextField: NSTextField!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Dex.initializeDex()
		MoveDex.initializeMoveDex()
		Dex.defineTypeMatchups()
		pokedex = Dex.dexArray
		ItemDex.initializeItemDex()
		for item in ItemDex.itemDexArray {
			itemList.append(item)
		}
		for (nature, _) in Dex.natureList {
			natureList.append(nature)
		}
		natureList.sort()
		repeat {
			levelArray.append(levelArray.count + 1)
		} while levelArray.count < 100

		updateSliders()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update view if already loaded
		}
	}

	func updateSliders() {
		hpSlider.minValue = 0.0
		hpSlider.maxValue = 252.0
		hpSlider.numberOfTickMarks = 63
		hpSlider.allowsTickMarkValuesOnly = true
		hpSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["hp"] = hpSlider.integerValue

		atkSlider.minValue = 0.0
		atkSlider.maxValue = 252.0
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = true
		atkSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["atk"] = atkSlider.integerValue

		defSlider.minValue = 0.0
		defSlider.maxValue = 252.0
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = true
		defSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["def"] = defSlider.integerValue

		spaSlider.minValue = 0.0
		spaSlider.maxValue = 252.0
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = true
		spaSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["spa"] = spaSlider.integerValue

		spdSlider.minValue = 0.0
		spdSlider.maxValue = 252.0
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = true
		spdSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["spd"] = spdSlider.integerValue

		speSlider.minValue = 0.0
		speSlider.maxValue = 252.0
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = true
		speSlider.trackFillColor = NSColor.systemBlue
		defendingMon.eVs["spe"] = speSlider.integerValue

		
		//update pokemon
//		updateDefendingMon()
	}
	
	func resetSliders() {
		hpSlider.doubleValue = 0.0
		atkSlider.doubleValue = 0.0
		defSlider.doubleValue = 0.0
		spaSlider.doubleValue = 0.0
		spdSlider.doubleValue = 0.0
		speSlider.doubleValue = 0.0
	}
		
	func updateDefendingMon() {
		hpLabel.integerValue = hpSlider.integerValue
		atkLabel.integerValue = atkSlider.integerValue
		defLabel.integerValue = defSlider.integerValue
		spaLabel.integerValue = spaSlider.integerValue
		spdLabel.integerValue = spdSlider.integerValue
		speLabel.integerValue = speSlider.integerValue
		
// stat boosts for defending mon
		if atkStepper.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(atkStepper.integerValue)
			defendingMon.statBoosts["atk"] = divisor/2.0
		} else if atkStepper.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(atkStepper.integerValue))
			defendingMon.statBoosts["atk"] = 2.0/dividend
		} else { defendingMon.statBoosts["atk"] = 1.0 }

		if defStepper.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(defStepper.integerValue)
			defendingMon.statBoosts["def"] = divisor/2.0
		} else if defStepper.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(defStepper.integerValue))
			defendingMon.statBoosts["def"] = 2.0/dividend
		} else { defendingMon.statBoosts["def"] = 1.0 }
		
		if spaStepper.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(spaStepper.integerValue)
			defendingMon.statBoosts["spa"] = divisor/2.0
		} else if atkStepper.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(spaStepper.integerValue))
			defendingMon.statBoosts["spa"] = 2.0/dividend
		} else { defendingMon.statBoosts["spa"] = 1.0 }
		
		if spdStepper.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(spdStepper.integerValue)
			defendingMon.statBoosts["spd"] = divisor/2.0
		} else if spdStepper.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(spdStepper.integerValue))
			defendingMon.statBoosts["spd"] = 2.0/dividend
		} else { defendingMon.statBoosts["spd"] = 1.0 }
		
		if speStepper.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(speStepper.integerValue)
			defendingMon.statBoosts["spe"] = divisor/2.0
		} else if speStepper.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(speStepper.integerValue))
			defendingMon.statBoosts["spe"] = 2.0/dividend
		} else { defendingMon.statBoosts["spe"] = 1.0 }
		
		defendingMon.actualStats = Pokemon.calcStats(pokemon: defendingMon)
		defendingMon.virtualStats = Pokemon.calcVirtualStats(pokemon: defendingMon)
		
		virtualHP.stringValue = "\(defendingMon.virtualStats["hp"] ?? 0)"
		virtualATK.stringValue = "\(defendingMon.virtualStats["atk"] ?? 0)"
		virtualDEF.stringValue = "\(defendingMon.virtualStats["def"] ?? 0)"
		virtualSPA.stringValue = "\(defendingMon.virtualStats["spa"] ?? 0)"
		virtualSPD.stringValue = "\(defendingMon.virtualStats["spd"] ?? 0)"
		virtualSPE.stringValue = "\(defendingMon.virtualStats["spe"] ?? 0)"
	}
	
	func updateAttackingMon() {
		
		if atkStepper2.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(atkStepper2.integerValue)
			attackingMon.statBoosts["atk"] = divisor/2.0
		} else if atkStepper2.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(atkStepper2.integerValue))
			attackingMon.statBoosts["atk"] = 2.0/dividend
		} else { attackingMon.statBoosts["atk"] = 1.0 }
		
		if defStepper2.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(defStepper2.integerValue)
			attackingMon.statBoosts["def"] = divisor/2.0
		} else if defStepper2.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(defStepper2.integerValue))
			attackingMon.statBoosts["def"] = 2.0/dividend
		} else { attackingMon.statBoosts["def"] = 1.0 }
		
		if spaStepper2.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(spaStepper2.integerValue)
			attackingMon.statBoosts["spa"] = divisor/2.0
		} else if atkStepper2.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(spaStepper2.integerValue))
			attackingMon.statBoosts["spa"] = 2.0/dividend
		} else { attackingMon.statBoosts["spa"] = 1.0 }
		
		if spdStepper2.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(spdStepper2.integerValue)
			attackingMon.statBoosts["spd"] = divisor/2.0
		} else if spdStepper2.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(spdStepper2.integerValue))
			attackingMon.statBoosts["spd"] = 2.0/dividend
		} else { attackingMon.statBoosts["spd"] = 1.0 }
		
		if speStepper2.integerValue > 0 {
			let divisor: Double = 2.0 + Double.init(speStepper2.integerValue)
			attackingMon.statBoosts["spe"] = divisor/2.0
		} else if speStepper2.integerValue < 0 {
			let dividend: Double = 2.0 + (-1.0 * Double.init(speStepper2.integerValue))
			attackingMon.statBoosts["spe"] = 2.0/dividend
		} else { attackingMon.statBoosts["spe"] = 1.0 }
		
		attackingMon.actualStats = Pokemon.calcStats(pokemon: attackingMon)
		attackingMon.virtualStats = Pokemon.calcVirtualStats(pokemon: attackingMon)
		
	}
	
	
	func updateCalcs() {
		updateDefendingMon()
		updateAttackingMon()
		let movesOrdered = [attackingMon.move1, attackingMon.move2, attackingMon.move3, attackingMon.move4]
		moveDamageTableBind = [:]
		for orderedMove in movesOrdered {
			let damageResultForMove = getDamageResult(attacker: attackingMon, defender: defendingMon, move: orderedMove, field: currentField)
			moveDamageTableBind[orderedMove.name] = ["intDmg": damageResultForMove.0,
													 "doubleDmg": damageResultForMove.1]
		}
		
		let movesOrdered2 = [defendingMon.move1, defendingMon.move2, defendingMon.move3, defendingMon.move4]
		moveDamageTableBind2 = [:]
		for orderedMove in movesOrdered2 {
			let damageResultForMove = getDamageResult(attacker: defendingMon, defender: attackingMon, move: orderedMove, field: currentField)
			moveDamageTableBind2[orderedMove.name] = ["intDmg": damageResultForMove.0,
													  "doubleDmg": damageResultForMove.1]
		}
	}

	
	@IBAction func attackerSelected(_ sender: Any) {
		updateCalcs()
	}
	
	
	@IBAction func defenderSelected(_ sender: Any) {
		let learnset = defendingMon.getPokemonLearnset(pokemon: defendingMon)
		learnsetMoves = [Move]()
		for move in learnset {
			let moveToAdd = MoveDex.searchMovedex(searchParam: move)
			learnsetMoves.append(moveToAdd)
		}
		resetSliders()
		updateSliders()
//		updateCalcs()
	}
	
	@IBAction func natureSelected(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	
	@IBAction func itemSelected(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	
	@IBAction func levelSelected(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}

	@IBAction func moveSelected(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	
	@IBAction func hpSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func atkSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func defSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func spaSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func spdSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func speSliderChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	
	@IBAction func statBoostChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	@IBAction func fieldChanged(_ sender: Any) {
		if defendingMon.level != 0 {
			updateSliders()
			updateCalcs()
		}
	}
	
}


class ImportViewController: NSViewController {
	
	var teamViewController: TeamViewController?
	
	var delegate: ImportDelegate?

	@IBOutlet weak var importTextField: NSTextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Dex.initializeDex()
		MoveDex.initializeMoveDex()
		Dex.defineTypeMatchups()
		
		//		importTextField?.stringValue = importText
		
	}
	
	override var representedObject: Any? {
		didSet {
			// Update view if already loaded
		}
	}
	
	@IBAction func importClicked(_ sender: Any) {
		let vc = self.presentingViewController as! TeamViewController
		let monToImport: Pokemon = importMonFromShowdown(showdownExportText: importTextField.stringValue)
//		vc.team.append(monToImport)
//		vc.teamController.add(monToImport)
//		vc.team2test = teamMaster
		vc.addToTeam2(pokemon: monToImport)

		dismiss(self)
	}
	
//	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//		if segue.destinationController is TeamViewController {
//			let vc = segue.destinationController as? TeamViewController
//			let monToImport: Pokemon = importMonFromShowdown(showdownExportText: importTextField.stringValue)
//			vc?.team = teamMaster.members
//			vc?.team2test = teamMaster
//			vc?.addToTeam2(pokemon: monToImport)
//			dismiss(self)
//
//
//		}
	}
	

	
	//	@IBAction func importTapped(_ sender: Any) {
	//
	//		monToImport = importMonFromShowdown(showdownExportText: importTextField.stringValue)
	//
	//		NotificationCenter.default.post(name: TeamViewController.notificationName, object: monToImport)
	//	}
	
	





class TestViewController: NSViewController {

	@IBOutlet weak var arrayImage: NSImageView!
	@IBOutlet weak var arrayContent: NSTextField!
	@IBOutlet weak var tableView: NSTableView!
	

	@objc dynamic var pokedex: [Pokemon] = [Pokemon()]
	
//	@objc dynamic var dexImgFile = dexNumToIcon()

	override func viewDidLoad() {
		super.viewDidLoad()
		Dex.initializeDex()
		MoveDex.initializeMoveDex()
		Dex.defineTypeMatchups()
		
	}
	
	override var representedObject: Any? {
		didSet {
			// Update view if already loaded
		}
	}
	
	
	
	
	@IBAction func tableViewAction(_ sender: Any) {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = pokedex[index]
			arrayContent.stringValue = "\(mon.species)\nHP: \(mon.baseStats["hp"] ?? 0)\nATK: \(mon.baseStats["atk"] ?? 0)\nDEF: \(mon.baseStats["def"] ?? 0)\nSPA: \(mon.baseStats["spa"] ?? 0)\nSPD: \(mon.baseStats["spd"] ?? 0)\nSPE: \(mon.baseStats["spe"] ?? 0)\n\nAbilities: \(mon.abilities)\nTypes: \(mon.types)"
			let imgFile = dexNumToIcon(mon)
			//let img = NSImage.init(name: imgFile!)
			//arrayImage.image?.setName(imgFile)
			arrayImage.image = NSImage(imageLiteralResourceName: imgFile!)
			
		}
		else {
			arrayContent.stringValue = ""
		}
	}
	@IBAction func populateDexTable(_ sender: Any) {
		for mon in Dex.dexArray {
			self.pokedex.append(mon)
		}
		super.viewDidLoad()
	}
	

	
}

	
	

