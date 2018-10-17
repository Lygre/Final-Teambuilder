//
//  UserData.swift
//  Pokemon Team Builder
//
//  Created by Hugh Broome on 10/15/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//
import Cocoa



class PreferencesView: NSViewController {
	
//	var userDefaults: UserDefaults
	
	@IBOutlet weak var label2: NSTextField!
	
	@objc dynamic var preferencesList = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		preferencesList = UserDefaults.standard
		
//		preferencesList.setValue("test", forKeyPath: "savedTeams")
//		print(preferencesList.dictionaryRepresentation())
		label2.stringValue = (userDefaultTemp.defaults.string(forKey: "savedTeams") ?? "hi")
	}
	
	override var representedObject: Any? {
		didSet {
			// Update view if already loaded
		}
	}
	
	
}


