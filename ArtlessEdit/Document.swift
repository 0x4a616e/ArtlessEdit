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
    
    let encoding = NSUTF8StringEncoding
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    let THEME_KEY = "THEME"
    var fileContent: String = ""
    
    override init() {
        super.init()
    }
    
    func setModeName(menuItem: NSMenuItem) {
        var modeNames:NSArray = ACEModeNames.humanModeNames()
        var index = modeNames.indexOfObject(menuItem.title)
        aceView.setMode(UInt(index))
    }
    
    func setThemeName(menuItem: NSMenuItem) {
        var themeNames:NSArray = ACEThemeNames.humanThemeNames()
        var index = themeNames.indexOfObject(menuItem.title)
        
        userDefaults.setInteger(index, forKey: THEME_KEY)
        aceView.setTheme(UInt(index))
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
        if (fileURL?.path != nil) {
            let fileType = NSWorkspace.sharedWorkspace().typeOfFile(fileURL!.path!, error: nil)
            
            if let components = fileType?.componentsSeparatedByString(".") {
                if (components.count > 1) {
                    return getModeIndexForType(components[1])
                }
            }
        }
        
        return nil
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        let modeIndex = getModeIndex()
        if (modeIndex != nil) {
            aceView.setMode(modeIndex!)
        }
        
        aceView.borderType = NSBorderType.NoBorder
        aceView.setTheme(UInt(userDefaults.integerForKey(THEME_KEY)))
        aceView.setString(fileContent)
        fileContent = ""
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
        fileContent = NSString(data: data, encoding: encoding)!
        
        return true
    }
    
    
}

