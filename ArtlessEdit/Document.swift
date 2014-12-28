//
//  Document.swift
//  MyDoc
//
//  Created by Jan Gassen on 21/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    @IBOutlet weak var aceView: ACEView!
    @IBOutlet var goToPanel: NSWindow!
    @IBOutlet weak var editorSettings: NSScrollView!
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    
    lazy var outlineController = OutlineController(windowNibName: "Outline")
    
    var editorSettingsController: EditorSettingsViewController? = nil
    var fileSettingsController: FileSettingsViewController? = nil
    
    var mode: ACEMode = ACEModeASCIIDoc
    let encoding = NSUTF8StringEncoding
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    var fileContent: String = ""
    
    override init() {
        super.init()
    }
    
    func outline(sender: AnyObject) {
        if (fileURL != nil) {
            outlineController.showWindow(sender, aceView: aceView, mode: mode, file: fileURL!)
        }
    }
    
    func showGotoSheet(sender: AnyObject) {
        windowForSheet?.beginSheet(goToPanel, completionHandler: nil)
    }

    @IBAction func goToLine(sender: AnyObject) {
        if let textField = sender as? NSTextField {
            aceView.gotoLine(textField.integerValue, column: 0, animated: false)
        }
        
        closeSheet(sender)
    }
    
    @IBAction func closeSheet(sender: AnyObject) {
        windowForSheet?.endSheet(goToPanel)
    }
    
    func setModeName(menuItem: NSMenuItem) {
        var modeNames:NSArray = ACEModeNames.humanModeNames()
        var index = modeNames.indexOfObject(menuItem.title)
        aceView.setMode(UInt(index))
    }
    
    func getModeForType(type: String) -> ACEMode? {
        var index: UInt = 0
        
        for modeName in ACEModeNames.modeNames() as [String] {
            if modeName.lowercaseString == type.lowercaseString {
                return ACEMode(index)
            }
            index += 1
        }
        
        return nil
    }
    
    func getMode() -> ACEMode? {
        if let path = fileURL?.path {
            
            if let mapping = FileMapping().getMode(path.pathExtension.lowercaseString) {
                return mapping
            }
            
            if let fileType = NSWorkspace.sharedWorkspace().typeOfFile(path, error: nil) {
                let components = fileType.componentsSeparatedByString(".")
                if (components.count > 1) {
                    return getModeForType(components[1])
                }
            }
        }
        
        return nil
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        aceView.borderType = NSBorderType.NoBorder
        
        let defaultSettings = EditorDefaultSettings()
        let sessionSettings = EditorSessionSettings(aceView: aceView)
        
        let fileSettings = EditorFileSettings(aceView: aceView, defaultSettings: defaultSettings, sessionSettings: sessionSettings)
        fileSettings.setMode(getMode())
        
        editorSettingsController = EditorSettingsViewController(nibName: "EditorSettingsView", handler: sessionSettings)
        fileSettingsController = FileSettingsViewController(nibName: "FileSettings", settings: fileSettings)
        
        loadSettingsSideBar(fileSettings, sessionSettings: sessionSettings)
        
        // TODO: Move to view controller
        if (ACEThemeNames.isDarkTheme(UInt(defaultSettings.getTheme()))) {
            visualEffectView.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        }
        
        // TODO: Find something more elegant...
        fileSettings.setUpdateMethod(editorSettingsController?.loadSettings)
        
        aceView.setString(fileContent)
        fileContent = ""
    }
    
    func loadSettingsSideBar(fileSettings: EditorFileSettings, sessionSettings: EditorSessionSettings) {
        let stackView = SideBarStackView()
        if let view = fileSettingsController?.view {
            stackView.addView(view, inGravity: NSStackViewGravity.Top)
        }
        
        if let view = editorSettingsController?.view {
            stackView.addView(view, inGravity: NSStackViewGravity.Center)
        }
        
        editorSettings.documentView = stackView
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func revertToContentsOfURL(absoluteURL: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        
        aceView.setString(NSString(contentsOfURL: absoluteURL, encoding: encoding, error: nil))
        
        return true
    }
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        return aceView.string().dataUsingEncoding(encoding, allowLossyConversion: false)
    }
    
    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        if let content = NSString(data: data, encoding: encoding) {
            fileContent = content
        } else {
            println("Invalid encoding")
        }
        
        return true
    }
    
    override func printOperationWithSettings(printSettings: [NSObject : AnyObject], error outError: NSErrorPointer) -> NSPrintOperation? {
        return NSPrintOperation(view: aceView.webView.mainFrame.frameView)
    }
    
    
}

