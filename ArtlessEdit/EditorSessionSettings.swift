//
//  DocumentViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorSessionSettings: EditorSettingsObservable, EditorSettings, EditorSettingsObserver {
    
    let aceView: ACEView
    
    var theme = ""
    var bindings = ACEKeyboardHandler.Ace
    
    var codeFolding = false
    var softWraps = false
    var showInvisibles = false
    var showPrintMargin = false
    var highlightActiveLine = false
    var useSoftTabs = false
    var displayIndentGuides = false
    var tabSize = 0
    
    let defaults: EditorDefaultSettings
    
    init(aceView: ACEView, defaults: EditorDefaultSettings) {
        self.aceView = aceView
        self.defaults = defaults
        
        super.init()
        
        updateSettings(defaults)
        defaults.addSubscriber(self)
    }
    
    deinit {
        defaults.removeSubscriber(self)
    }
    
    func updateSettings(settings: EditorSettings) {
        theme = settings.getTheme()
        setTheme(theme)
        
        bindings = settings.getKeyBindings()
        setKeyBindings(bindings)
        
        codeFolding = settings.getCodeFolding()
        setCodeFolding(codeFolding)
        
        softWraps = settings.getSoftWrap()
        setSoftWrap(softWraps)
        
        showInvisibles = settings.getShowInvisibles()
        setShowInvisibles(showInvisibles)
        
        showPrintMargin = settings.getShowPrintMargin()
        setShowPrintMargin(showPrintMargin)
        
        highlightActiveLine = settings.getHighlightActiveLine()
        setHighlightActiveLine(highlightActiveLine)
        
        useSoftTabs = settings.getUseSoftTabs()
        setUseSoftTabs(useSoftTabs)
        
        tabSize = settings.getTabSize()
        if (useSoftTabs) {
            setTabSize(tabSize)
        }
        
        displayIndentGuides = settings.getDisplayIndentGuides()
        setDisplayIndentGuides(displayIndentGuides)
        
        notifySubscribers(self)
    }
    
    func setTheme(name: String) {
        theme = name
        aceView.setTheme(name)
    }
    
    func getTheme() -> String {
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