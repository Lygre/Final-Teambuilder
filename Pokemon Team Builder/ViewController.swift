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

class TeamViewController: NSViewController {
	
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
	
	
	//remains to be done with programming the rest of the sliders
	//on the backend, everything works, but not sure how to have sliders
	//re-draw if the desired set value for EVs is not possible in context
	

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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		hpSlider.allowsTickMarkValuesOnly = true
		hpSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["hp"] = hpSlider.integerValue
		
		atkSlider.minValue = 0.0
		atkSlider.maxValue = 252.0
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = true
		atkSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["atk"] = atkSlider.integerValue
		
		defSlider.minValue = 0.0
		defSlider.maxValue = 252.0
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = true
		defSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["def"] = defSlider.integerValue
		
		spaSlider.minValue = 0.0
		spaSlider.maxValue = 252.0
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = true
		spaSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spa"] = spaSlider.integerValue
		
		spdSlider.minValue = 0.0
		spdSlider.maxValue = 252.0
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = true
		spdSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spd"] = spdSlider.integerValue
		
		speSlider.minValue = 0.0
		speSlider.maxValue = 252.0
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = true
		speSlider.trackFillColor = NSColor.systemBlue
//		defendingMon.eVs["spe"] = speSlider.integerValue
		
		
		//update pokemon
		
	}
	
	func updateTeam() {
		teamMaster = Team(members: team)
		teamMaster.teamWeaknesses = teamMaster.determineTeamWeaknesses()
		teamMaster.teamCoverage = teamMaster.determineTeamCoverage()
		teamMaster.additionalAttributes = teamMaster.determineAttributes()
		print(teamMaster)
	}
	
	func updatePokemon() {
		let index: Int = tableView.selectedRow
		
		if index > -1 {
			let mon: Pokemon = team[index]
			//get actual stat values for selected mon
			mon.actualStats = Pokemon.calcStats(pokemon: mon)
			actualHP.stringValue = "\(mon.actualStats["hp"] ?? 0)"
			actualATK.stringValue = "\(mon.actualStats["atk"] ?? 0)"
			actualDEF.stringValue = "\(mon.actualStats["def"] ?? 0)"
			actualSPA.stringValue = "\(mon.actualStats["spa"] ?? 0)"
			actualSPD.stringValue = "\(mon.actualStats["spd"] ?? 0)"
			actualSPE.stringValue = "\(mon.actualStats["spe"] ?? 0)"
			
			
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
			//add mon's current item to itemList
			itemList.append(mon.item)
		}
	}
	
	func getEVAllowedChange() -> Bool {
		let evSliderSum: Int = hpSlider.integerValue + atkSlider.integerValue + defSlider.integerValue + spaSlider.integerValue + spdSlider.integerValue + speSlider.integerValue
		if evSliderSum < 510 { return true }
		else { return false }
	}
	
	@IBAction func hpSliderAction(_ sender: Any) {
		hpSlider.minValue = 0.0
		hpSlider.maxValue = 252.0
		hpSlider.numberOfTickMarks = 63
		hpSlider.allowsTickMarkValuesOnly = true
		hpSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["hp"] = hpSlider.integerValue
				print(mon.eVs["hp"]!)
				
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
		atkSlider.maxValue = 252.0
		atkSlider.numberOfTickMarks = 63
		atkSlider.allowsTickMarkValuesOnly = true
		atkSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["atk"] = atkSlider.integerValue
				print(mon.eVs["atk"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}
	
	@IBAction func defSliderAction(_ sender: Any) {
		defSlider.minValue = 0.0
		defSlider.maxValue = 252.0
		defSlider.numberOfTickMarks = 63
		defSlider.allowsTickMarkValuesOnly = true
		defSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["def"] = defSlider.integerValue
				print(mon.eVs["def"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}
	
	@IBAction func spaSliderAction(_ sender: Any) {
		spaSlider.minValue = 0.0
		spaSlider.maxValue = 252.0
		spaSlider.numberOfTickMarks = 63
		spaSlider.allowsTickMarkValuesOnly = true
		spaSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spa"] = spaSlider.integerValue
				print(mon.eVs["spa"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}

	@IBAction func spdSliderAction(_ sender: Any) {
		spdSlider.minValue = 0.0
		spdSlider.maxValue = 252.0
		spdSlider.numberOfTickMarks = 63
		spdSlider.allowsTickMarkValuesOnly = true
		spdSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spd"] = spdSlider.integerValue
				print(mon.eVs["spd"]!)
				//update pokemon
				updatePokemon()
			}
		} else { return }
	}

	@IBAction func speSliderAction(_ sender: Any) {
		speSlider.minValue = 0.0
		speSlider.maxValue = 252.0
		// possibly able to put a method to determine what max value should be using default value
		speSlider.numberOfTickMarks = 63
		speSlider.allowsTickMarkValuesOnly = true
		speSlider.trackFillColor = NSColor.systemBlue
		let allowedToChange: Bool = getEVAllowedChange()
		if allowedToChange {
			let index = tableView.selectedRow
			if index > -1 {
				let mon: Pokemon = team[index]
				mon.eVs["spe"] = speSlider.integerValue
				print(mon.eVs["spe"]!)
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
//		movesToSet["move1"] = MoveDex.searchMovedex(searchParam: (move1Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move2Selected(_ sender: Any) {
//		movesToSet["move2"] = MoveDex.searchMovedex(searchParam: (move2Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move3Selected(_ sender: Any) {
//		movesToSet["move3"] = MoveDex.searchMovedex(searchParam: (move3Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	@IBAction func move4Selected(_ sender: Any) {
//		movesToSet["move4"] = MoveDex.searchMovedex(searchParam: (move4Select.selectedItem?.title)!)
//		var movesArray = [Move]()
//		for (_, move) in movesToSet {
//			movesArray.append(move)
//		}
//		let index = tableView.selectedRow
//		if index > -1 {
//			let mon = team[index]
//			mon.moves = movesArray
//		}
		teamCoverageTableBind = team2test.determineTeamCoverage()
		teamAttributeTableBind = team2test.determineAttributes()
	}
	
	// Nature select action
	
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
		updateDefendingMon()
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
		defendingMon.actualStats = Pokemon.calcStats(pokemon: defendingMon)
		defendingMon.virtualStats = Pokemon.calcVirtualStats(pokemon: defendingMon)
	}
	
	func updateCalcs() {
		updateDefendingMon()
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
	}
	
	@IBAction func natureSelected(_ sender: Any) {
//		updateDefendingMon()
	}
	
	@IBAction func itemSelected(_ sender: Any) {
//		updateDefendingMon()
	}
	
	@IBAction func levelSelected(_ sender: Any) {
//		updateDefendingMon()
	}

	@IBAction func hpSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	@IBAction func atkSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	@IBAction func defSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	@IBAction func spaSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	@IBAction func spdSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	@IBAction func speSliderChanged(_ sender: Any) {
		updateSliders()
		updateCalcs()
	}
	
	
	
}



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

	
	
	

