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
    
    lazy var outlineController = OutlineController(windowNibName: "Outline")
    
    var editorSettingsController: EditorSettingsViewController? = nil
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
    
    func getModeIndexForType(type: String) -> UInt? {
        var index: UInt = 0
        
        for modeName in ACEModeNames.modeNames() as [String] {
            if modeName.lowercaseString == type.lowercaseString {
                return index
            }
            index += 1
        }
        
        return nil
    }
    
    func getModeIndex() -> UInt? {
        if let path = fileURL?.path {
            //TODO Allow user to map files by extension

            switch(path.pathExtension.lowercaseString) {
            case "java": return UInt(ACEModeJava);
            default: println(path.pathExtension)
            }
            
            if let fileType = NSWorkspace.sharedWorkspace().typeOfFile(path, error: nil) {
                let components = fileType.componentsSeparatedByString(".")
                if (components.count > 1) {
                    return getModeIndexForType(components[1])
                }
            }
        }
        
        return nil
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        let defaultSettings = EditorDefaultSettings()
        if let modeIndex = getModeIndex() {
            mode = ACEMode(modeIndex)
            aceView.setMode(modeIndex)
            defaultSettings.setMode(mode)
        }
        
        aceView.borderType = NSBorderType.NoBorder
        aceView.setString(fileContent)
        fileContent = ""
        
        let settings = EditorSessionSettings(aceView: aceView)
        settings.loadDefaults(defaultSettings)
        editorSettingsController = EditorSettingsViewController(nibName: "EditorSettingsView", bundle: nil, handler: settings)
        editorSettings.documentView = editorSettingsController?.view
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

