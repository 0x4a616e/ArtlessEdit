//
//  EditorSettingsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorSettingsViewController: NSViewController, EditorSettingsObserver {
    
    @IBOutlet weak var themeBox: NSComboBox!
    @IBOutlet weak var bindingsBox: NSComboBox!
    @IBOutlet weak var softWrapsButton: NSButton!
    @IBOutlet weak var codeFoldingButton: NSButton!
    @IBOutlet weak var invisibleCharactersButton: NSButton!
    @IBOutlet weak var printMarginButton: NSButton!
    @IBOutlet weak var highlightActiveLineButton: NSButton!
    @IBOutlet weak var softTabsButton: NSButton!
    @IBOutlet weak var indentationGuidesButton: NSButton!
    @IBOutlet weak var tabSizeField: NSTextField!
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    let handler: protocol<ObservableSettings, EditorSettings>
    
    init?(nibName nibNameOrNil: String?, handler: protocol<ObservableSettings, EditorSettings>) {
        self.handler = handler
        
        super.init(nibName: nibNameOrNil, bundle: nil)
        
        handler.addSubscriber(self)
    }
    
    deinit {
        handler.removeSubscriber(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        updateSettings(handler)
    }
    
    func updateSettings(settings: EditorSettings) {
        themeBox.removeAllItems()
        themeBox.addItemsWithObjectValues(ACEThemeNames.humanThemeNames())
        let index = ACEThemeNames.getIndexByName(settings.getTheme())
        if (index > 0) {
            themeBox.selectItemAtIndex(index)
        }
        
        bindingsBox.removeAllItems()
        bindingsBox.addItemsWithObjectValues(ACEKeyboardHandlerNames.humanKeyboardHandlerNames())
        bindingsBox.selectItemAtIndex(Int(settings.getKeyBindings().rawValue))
        
        tabSizeField.integerValue = settings.getTabSize()
        softWrapsButton.state = toState(settings.getSoftWrap())
        codeFoldingButton.state = toState(settings.getCodeFolding())
        invisibleCharactersButton.state = toState(settings.getShowInvisibles())
        printMarginButton.state = toState(settings.getShowPrintMargin())
        highlightActiveLineButton.state = toState(settings.getHighlightActiveLine())
        softTabsButton.state = toState(settings.getUseSoftTabs())
        indentationGuidesButton.state = toState(settings.getDisplayIndentGuides())
    }
    
    func toState(val: Bool) -> Int {
        return (val) ? NSOnState : NSOffState
    }
    
    @IBAction func setTheme(sender: NSComboBox) {
        handler.setTheme(ACEThemeNames.getNameByIndex(sender.indexOfSelectedItem))
    }
    
    @IBAction func setKeyBindings(sender: NSComboBox) {
        if let keyBindings = ACEKeyboardHandler(rawValue: UInt(sender.indexOfSelectedItem)) {
            handler.setKeyBindings(keyBindings)
        } else {
            handler.setKeyBindings(ACEKeyboardHandler.Ace)
        }
    }
    
    @IBAction func setTabSize(sender: NSTextField) {
        let size = sender.integerValue
        if size > 0 {
            handler.setTabSize(size)
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
    
    @IBAction func setShowPrintMargin(sender: NSButton) {
        handler.setShowPrintMargin(sender.state != NSOffState)
    }
    
    @IBAction func setHighlightActiveLine(sender: NSButton) {
        handler.setHighlightActiveLine(sender.state != NSOffState)
    }
    
    @IBAction func setUseSoftTabs(sender: NSButton) {
        let state = sender.state != NSOffState
        handler.setUseSoftTabs(state)
        tabSizeField.enabled = state
        if (state) {
            tabSizeField.integerValue = handler.getTabSize()
        }
    }
    
    @IBAction func setDisplayIndentGuides(sender: NSButton) {
        handler.setDisplayIndentGuides(sender.state != NSOffState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}