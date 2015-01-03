//
//  EditorSettingsHandler.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

protocol EditorSettings {
    func setTheme(name: String)
    func getTheme() -> String
    
    func setKeyBindings(bindings: ACEKeyboardHandler)
    func getKeyBindings() -> ACEKeyboardHandler
    
    func setCodeFolding(enabled: Bool)
    func getCodeFolding() -> Bool
    
    func setSoftWrap(enabled: Bool)
    func getSoftWrap() -> Bool
    
    func setShowInvisibles(enabled: Bool)
    func getShowInvisibles() -> Bool
    
    func setShowPrintMargin(enabled: Bool)
    func getShowPrintMargin() -> Bool
    
    func setHighlightActiveLine(enabled: Bool)
    func getHighlightActiveLine() -> Bool
    
    func setUseSoftTabs(enabled: Bool)
    func getUseSoftTabs() -> Bool
    
    func setTabSize(enabled: Int)
    func getTabSize() -> Int
    
    func setDisplayIndentGuides(enabled: Bool)
    func getDisplayIndentGuides() -> Bool
}