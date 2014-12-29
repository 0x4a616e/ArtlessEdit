//
//  AppDelegate.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 21/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var settingsWindow: NSWindow!
    
    lazy var quickOpenController = SearchPopupController(windowNibName: "SearchPopup")
    
    lazy var defaultSettingsController = DefaultSettingsViewController(nibName: "DefaultSettings", bundle: nil)
    lazy var externalToolsController = ExternalToolsViewController(nibName: "ExternalTools", bundle: nil)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        showDefaultSettings(self)
    }
    
    @IBAction func showDefaultSettings(sender: AnyObject) {
        if let view = defaultSettingsController?.view {
            settingsWindow.contentView = view
        }
    }
    
    @IBAction func showExternalTools(sender: AnyObject) {
        if let view = externalToolsController?.view {
            settingsWindow.contentView = view
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showQuickOpen(sender: AnyObject) {
        quickOpenController.showWindow(sender, data: OpenFileData(), title: "Quick Open")
    }
    
    @IBAction func recentFileOpen(sender: AnyObject) {
        quickOpenController.showWindow(sender, data: RecentFileData(), title: "Open Recent")
    }
    
    func createSubMenu(items: NSArray, targetMenu: NSMenuItem, selector: Selector) {
        var subMenu = NSMenu()
        for item in items {
            var menuItem = NSMenuItem(title: item as String, action: selector, keyEquivalent: "")
            menuItem.target = nil
            subMenu.addItem(menuItem)
        }
        
        targetMenu.submenu = subMenu
    }
    
}


