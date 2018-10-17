//
//  AppDelegate.swift
//  Pokemon Team Builder
//
//  Created by Hugh Broome on 7/20/18.
//  Copyright © 2018 Hugh Broome. All rights reserved.
//

import Cocoa

var userDefaultSettings: UserDefaults = UserDefaults.init()
var defaultsDict: [String: Any]? = ["savedTeams": "name"]

var userDefaultTemp = NSUserDefaultsController.init(defaults: userDefaultSettings, initialValues: defaultsDict)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {
	

	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
	}

	func applicationWillFinishLaunching(_ sender: NSApplication) {
		
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}
