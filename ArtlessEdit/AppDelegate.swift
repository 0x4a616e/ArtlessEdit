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
    
    @IBOutlet weak var mode: NSMenuItem!
    @IBOutlet weak var editorSettings: NSScrollView!
    
    var editorSettingsController: EditorSettingsViewController? = nil
    lazy var quickOpenController: SearchPopupController = SearchPopupController(windowNibName: "SearchPopup")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        createSubMenu(ACEModeNames.humanModeNames(), targetMenu: mode, selector: Selector("setModeName:"))
        
        editorSettingsController = EditorSettingsViewController(nibName: "EditorSettingsView", bundle: nil, handler: EditorDefaultSettings())
        editorSettings.documentView = editorSettingsController?.view
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


