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
    var showGutter = false
    var showPrintMargin = false
    var highlightActiveLine = false
    var useSoftTabs = false
    var displayIndentGuides = false
    
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
        
        showGutter = defaults.getShowGutter()
        setShowGutter(showGutter)
        
        showPrintMargin = defaults.getShowPrintMargin()
        setShowPrintMargin(showPrintMargin)
        
        highlightActiveLine = defaults.getHighlightActiveLine()
        setHighlightActiveLine(highlightActiveLine)
        
        useSoftTabs = defaults.getUseSoftTabs()
        setUseSoftTabs(useSoftTabs)
        
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

    
    func setShowGutter(enabled: Bool) {
        showGutter = enabled
    }
    
    func getShowGutter() -> Bool {
        return showGutter
    }

    
    func setShowPrintMargin(enabled: Bool) {
        showPrintMargin = enabled
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
    }
    
    func getUseSoftTabs() -> Bool {
        return useSoftTabs
    }

    
    func setDisplayIndentGuides(enabled: Bool) {
        displayIndentGuides = enabled
    }
    
    func getDisplayIndentGuides() -> Bool {
        return displayIndentGuides
    }

}