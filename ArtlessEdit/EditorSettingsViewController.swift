//
//  EditorSettingsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorSettingsViewController: NSViewController {
    
    @IBOutlet weak var themeBox: NSComboBox!
    @IBOutlet weak var bindingsBox: NSComboBox!
    @IBOutlet weak var softWrapsButton: NSButton!
    @IBOutlet weak var codeFoldingButton: NSButton!
    @IBOutlet weak var invisibleCharactersButton: NSButton!
    @IBOutlet weak var lineNumbersButton: NSButton!
    @IBOutlet weak var printMarginButton: NSButton!
    @IBOutlet weak var highlightActiveLineButton: NSButton!
    @IBOutlet weak var softTabsButton: NSButton!
    @IBOutlet weak var indentationGuidesButton: NSButton!
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    let handler: EditorSettings
    
    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, handler: EditorSettings) {
        self.handler = handler
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeBox.addItemsWithObjectValues(ACEThemeNames.humanThemeNames())
        themeBox.selectItemAtIndex(handler.getTheme())
        
        bindingsBox.addItemsWithObjectValues(ACEKeyboardHandlerNames.humanKeyboardHandlerNames())
        bindingsBox.selectItemAtIndex(Int(handler.getKeyBindings().rawValue))
        
        softWrapsButton.state = toState(handler.getSoftWrap())
        codeFoldingButton.state = toState(handler.getCodeFolding())
        invisibleCharactersButton.state = toState(handler.getShowInvisibles())
        lineNumbersButton.state = toState(handler.getShowGutter())
        printMarginButton.state = toState(handler.getShowPrintMargin())
        highlightActiveLineButton.state = toState(handler.getHighlightActiveLine())
        softTabsButton.state = toState(handler.getUseSoftTabs())
        indentationGuidesButton.state = toState(handler.getDisplayIndentGuides())
    }

    func toState(val: Bool) -> Int {
        return (val) ? NSOnState : NSOffState
    }
    
    @IBAction func setTheme(sender: NSComboBox) {
        handler.setTheme(sender.indexOfSelectedItem)
    }
    
    @IBAction func setKeyBindings(sender: NSComboBox) {
        if let keyBindings = ACEKeyboardHandler(rawValue: UInt(sender.indexOfSelectedItem)) {
            handler.setKeyBindings(keyBindings)
        } else {
            handler.setKeyBindings(ACEKeyboardHandler.Ace)
        }
    }
    
    @IBAction func setCodeFolding(sender: NSButton) {
        handler.setCodeFolding(sender.state != NSOffState)
    }
    
    @IBAction func setSoftWrap(sender: NSButton) {
        handler.setSoftWrap(sender.state != NSOffState)
    }
    
    @IBAction func setShowInvisibles(sender: NSButton) {
        handler.setShowInvisibles(sender.state != NSOffState)
    }
    
    @IBAction func setShowGutter(sender: NSButton) {
        handler.setShowGutter(sender.state != NSOffState)
    }
    
    @IBAction func setShowPrintMargin(sender: NSButton) {
        handler.setShowPrintMargin(sender.state != NSOffState)
    }
    
    @IBAction func setHighlightActiveLine(sender: NSButton) {
        handler.setHighlightActiveLine(sender.state != NSOffState)
    }
    
    @IBAction func setUseSoftTabs(sender: NSButton) {
        handler.setUseSoftTabs(sender.state != NSOffState)
    }
    
    @IBAction func setDisplayIndentGuides(sender: NSButton) {
        handler.setDisplayIndentGuides(sender.state != NSOffState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}