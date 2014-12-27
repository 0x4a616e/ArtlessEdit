//
//  DocumentViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorSessionSettings: EditorSettings {
    
    let aceView: ACEView
    
    var theme = 0
    var bindings = ACEKeyboardHandler.Ace
    
    var codeFolding = false
    var softWraps = false
    var showInvisibles = false
    var showPrintMargin = false
    var highlightActiveLine = false
    var useSoftTabs = false
    var displayIndentGuides = false
    var tabSize = 0
    
    init(aceView: ACEView) {
        self.aceView = aceView
    }
    
    func loadDefaults(defaults: EditorDefaultSettings) {
        theme = defaults.getTheme()
        setTheme(theme)
        
        bindings = defaults.getKeyBindings()
        setKeyBindings(bindings)
        
        codeFolding = defaults.getCodeFolding()
        setCodeFolding(codeFolding)
        
        softWraps = defaults.getSoftWrap()
        setSoftWrap(softWraps)
        
        showInvisibles = defaults.getShowInvisibles()
        setShowInvisibles(showInvisibles)
        
        showPrintMargin = defaults.getShowPrintMargin()
        setShowPrintMargin(showPrintMargin)
        
        highlightActiveLine = defaults.getHighlightActiveLine()
        setHighlightActiveLine(highlightActiveLine)
        
        useSoftTabs = defaults.getUseSoftTabs()
        setUseSoftTabs(useSoftTabs)
        
        tabSize = defaults.getTabSize()
        if (useSoftTabs) {
            setTabSize(tabSize)
        }
        
        displayIndentGuides = defaults.getDisplayIndentGuides()
        setDisplayIndentGuides(displayIndentGuides)
    }
    
    func setTheme(index: Int) {
        theme = index
        aceView.setTheme(UInt(index))
    }
    
    func getTheme() -> ACETheme {
        return theme
    }
    
    func setKeyBindings(bindings: ACEKeyboardHandler) {
        self.bindings = bindings
        aceView.setKeyboardHandler(bindings)
    }
    
    func getKeyBindings() -> ACEKeyboardHandler {
        return bindings
    }
    
    func setCodeFolding(enabled: Bool) {
        codeFolding = enabled
        aceView.setShowFoldWidgets(enabled)
    }
    
    func getCodeFolding() -> Bool {
        return codeFolding
    }
    
    func setSoftWrap(enabled: Bool) {
        softWraps = enabled
        aceView.setUseSoftWrap(softWraps)
    }
    
    func getSoftWrap() -> Bool {
        return softWraps
    }

    func setShowInvisibles(enabled: Bool) {
        showInvisibles = enabled
        aceView.setShowInvisibles(enabled)
    }
    
    func getShowInvisibles() -> Bool {
        return showInvisibles
    }
    
    func setShowPrintMargin(enabled: Bool) {
        showPrintMargin = enabled
        aceView.setShowPrintMargin(showPrintMargin)
    }
    
    func getShowPrintMargin() -> Bool {
        return showPrintMargin
    }
    
    func setHighlightActiveLine(enabled: Bool) {
        highlightActiveLine = enabled
        aceView.setHighlightActiveLine(enabled)
    }
    
    func getHighlightActiveLine() -> Bool {
        return highlightActiveLine
    }
    
    func setUseSoftTabs(enabled: Bool) {
        useSoftTabs = enabled
        aceView.setUseSoftTabs(useSoftTabs)
    }
    
    func getUseSoftTabs() -> Bool {
        return useSoftTabs
    }
    
    func setTabSize(enabled: Int){
        tabSize = enabled
        aceView.setTabSize(enabled)
    }
    
    func getTabSize() -> Int {
        return tabSize
    }

    func setDisplayIndentGuides(enabled: Bool) {
        displayIndentGuides = enabled
        aceView.setDisplayIndentGuides(displayIndentGuides)
    }
    
    func getDisplayIndentGuides() -> Bool {
        return displayIndentGuides
    }

}