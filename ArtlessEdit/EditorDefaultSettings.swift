//
//  UserDefaultsSettingsBridge.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorDefaultSettings: EditorSettings {
    
    let THEME = "Theme"
    let KEY_BINDINGS = "KeyBindings"
    let CODE_FOLDING = "CodeFolding"
    let SOFT_WRAP = "SoftWrap"
    let SHOW_INVISIBLES = "ShowInvisibles"
    let PRINT_MARGIN = "PrintMargin"
    let ACTIVE_LINE = "ActiveLine"
    let SOFT_TABS = "SoftTabs"
    let INDENT_GUIDES = "IndentGuides"
    let TAB_SIZE = "TabSize"
    
    var mode: ACEMode? = nil
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()

    init(mode: ACEMode? = nil) {
        setMode(mode)
    }
    
    func setTheme(index: Int) {
        userDefaults.setInteger(index, forKey: getKey(THEME))
    }
    
    func getTheme() -> ACETheme {
        return userDefaults.integerForKey(getKey(THEME))
    }

    func setKeyBindings(bindings: ACEKeyboardHandler) {
        userDefaults.setInteger(Int(bindings.rawValue), forKey: getKey(KEY_BINDINGS))
    }
    
    func getKeyBindings() -> ACEKeyboardHandler {
        if let keyBindings = ACEKeyboardHandler(rawValue: UInt(userDefaults.integerForKey(getKey(KEY_BINDINGS)))) {
            return keyBindings
        }
        
        return ACEKeyboardHandler.Ace
    }

    func setCodeFolding(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(CODE_FOLDING))
    }
    
    func getCodeFolding() -> Bool {
        return userDefaults.boolForKey(getKey(CODE_FOLDING))
    }

    func setSoftWrap(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(SOFT_WRAP))
    }
    
    func getSoftWrap() -> Bool {
        return userDefaults.boolForKey(getKey(SOFT_WRAP))
    }

    func setShowInvisibles(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(SHOW_INVISIBLES))
    }
    
    func getShowInvisibles() -> Bool {
        return userDefaults.boolForKey(getKey(SHOW_INVISIBLES))
    }

    func setShowPrintMargin(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(PRINT_MARGIN))
    }
    
    func getShowPrintMargin() -> Bool {
        return userDefaults.boolForKey(getKey(PRINT_MARGIN))
    }

    func setHighlightActiveLine(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(ACTIVE_LINE))
    }
    
    func getHighlightActiveLine() -> Bool {
        return userDefaults.boolForKey(getKey(ACTIVE_LINE))
    }

    func setUseSoftTabs(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(SOFT_TABS))
    }
    
    func getUseSoftTabs() -> Bool {
        return userDefaults.boolForKey(getKey(SOFT_TABS))
    }
    
    func setTabSize(enabled: Int){
        userDefaults.setInteger(enabled, forKey: getKey(TAB_SIZE))
    }
    
    func getTabSize() -> Int {
        return userDefaults.integerForKey(getKey(TAB_SIZE))
    }

    func setDisplayIndentGuides(enabled: Bool){
        userDefaults.setBool(enabled, forKey: getKey(INDENT_GUIDES))
    }
    
    func getDisplayIndentGuides() -> Bool {
        return userDefaults.boolForKey(getKey(INDENT_GUIDES))
    }
    
    func getKey(key: String) -> String {
        if (mode != nil) {
            return ACEModeNames.humanNameForMode(UInt(mode!)) + "_" + key
        }
        
        return key
    }
    
    func setMode(mode: ACEMode?) {
        self.mode = mode
        if (mode != nil) {
            loadDefaultSettings()
        }
    }
    
    func loadDefaultSettings() {
        if self.mode == nil {
            return
        }
        
        let defaults = EditorDefaultSettings()
        userDefaults.registerDefaults([
            getKey(THEME) : defaults.getTheme(),
            getKey(CODE_FOLDING): defaults.getCodeFolding(),
            getKey(SOFT_WRAP): defaults.getSoftWrap(),
            getKey(SHOW_INVISIBLES): defaults.getShowInvisibles(),
            getKey(PRINT_MARGIN): defaults.getShowPrintMargin(),
            getKey(ACTIVE_LINE): defaults.getHighlightActiveLine(),
            getKey(SOFT_TABS): defaults.getUseSoftTabs(),
            getKey(TAB_SIZE): defaults.getTabSize(),
            getKey(INDENT_GUIDES): defaults.getDisplayIndentGuides()
        ])
    }
    
    func resetToDefaults() {
        if (self.mode == nil) {
            return
        }
        
        userDefaults.removeObjectForKey(getKey(THEME))
        userDefaults.removeObjectForKey(getKey(CODE_FOLDING))
        userDefaults.removeObjectForKey(getKey(SOFT_WRAP))
        userDefaults.removeObjectForKey(getKey(SHOW_INVISIBLES))
        userDefaults.removeObjectForKey(getKey(PRINT_MARGIN))
        userDefaults.removeObjectForKey(getKey(ACTIVE_LINE))
        userDefaults.removeObjectForKey(getKey(SOFT_TABS))
        userDefaults.removeObjectForKey(getKey(TAB_SIZE))
        userDefaults.removeObjectForKey(getKey(INDENT_GUIDES))
    }
    
    class func hasModeSettings(forMode: ACEMode) -> Bool {
        let userDetails = NSUserDefaults.standardUserDefaults()
        return userDetails.boolForKey(getModeSettingsKey(forMode)) == true
    }
    
    class func getModeSettingsKey(forMode: ACEMode?) -> String {
        return ACEModeNames.humanNameForMode(UInt(forMode!)) + "_settings"
    }
    
    class func getEditorDefaultSettings(forMode: ACEMode?) -> EditorDefaultSettings {
        if (forMode != nil && hasModeSettings(forMode!)) {
            return EditorDefaultSettings(mode: forMode)
        } else {
            return EditorDefaultSettings()
        }
    }
}