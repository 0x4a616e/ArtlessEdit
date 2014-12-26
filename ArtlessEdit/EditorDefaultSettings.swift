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
    let SHOW_GUTTER = "ShowGutter"
    let PRINT_MARGIN = "PrintMargin"
    let ACTIVE_LINE = "ActiveLine"
    let SOFT_TABS = "SoftTabs"
    let INDENT_GUIDES = "IndentGuides"
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()

    func setTheme(index: Int) {
        userDefaults.setInteger(index, forKey: THEME)
    }
    
    func getTheme() -> ACETheme {
        return userDefaults.integerForKey(THEME)
    }

    func setKeyBindings(bindings: ACEKeyboardHandler) {
        userDefaults.setInteger(Int(bindings.rawValue), forKey: KEY_BINDINGS)
    }
    
    func getKeyBindings() -> ACEKeyboardHandler {
        if let keyBindings = ACEKeyboardHandler(rawValue: UInt(userDefaults.integerForKey(KEY_BINDINGS))) {
            return keyBindings
        }
        
        return ACEKeyboardHandler.Ace
    }

    func setCodeFolding(enabled: Bool){
        userDefaults.setBool(enabled, forKey: CODE_FOLDING)
    }
    
    func getCodeFolding() -> Bool {
        return userDefaults.boolForKey(CODE_FOLDING)
    }

    func setSoftWrap(enabled: Bool){
        userDefaults.setBool(enabled, forKey: SOFT_WRAP)
    }
    
    func getSoftWrap() -> Bool {
        return userDefaults.boolForKey(SOFT_WRAP)
    }

    func setShowInvisibles(enabled: Bool){
        userDefaults.setBool(enabled, forKey: SHOW_INVISIBLES)
    }
    
    func getShowInvisibles() -> Bool {
        return userDefaults.boolForKey(SHOW_INVISIBLES)
    }

    func setShowGutter(enabled: Bool){
        userDefaults.setBool(enabled, forKey: SHOW_GUTTER)
    }
    
    func getShowGutter() -> Bool {
        return userDefaults.boolForKey(SHOW_GUTTER)
    }

    func setShowPrintMargin(enabled: Bool){
        userDefaults.setBool(enabled, forKey: PRINT_MARGIN)
    }
    
    func getShowPrintMargin() -> Bool {
        return userDefaults.boolForKey(PRINT_MARGIN)
    }

    func setHighlightActiveLine(enabled: Bool){
        userDefaults.setBool(enabled, forKey: ACTIVE_LINE)
    }
    
    func getHighlightActiveLine() -> Bool {
        return userDefaults.boolForKey(ACTIVE_LINE)
    }

    func setUseSoftTabs(enabled: Bool){
        userDefaults.setBool(enabled, forKey: SOFT_TABS)
    }
    
    func getUseSoftTabs() -> Bool {
        return userDefaults.boolForKey(SOFT_TABS)
    }

    func setDisplayIndentGuides(enabled: Bool){
        userDefaults.setBool(enabled, forKey: INDENT_GUIDES)
    }
    
    func getDisplayIndentGuides() -> Bool {
        return userDefaults.boolForKey(INDENT_GUIDES)
    }

}