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
	
	@IBOutlet var teamMembersController: NSArrayController!
	
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
	@IBAction func addToTeamClicked(_ sender: Any) {
		let teamMemberToAdd = searchResultsController!.selectedObjects
	
		teamMembersController.add(teamMemberToAdd!)
		print(teamMembersController.content!)
	}
	
	
}


extension TeamBuilderController {
	func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
		if commandSelector == #selector(insertNewline(_:)) {
			searchClicked(searchTextField)
		}
		return false
	}
}
