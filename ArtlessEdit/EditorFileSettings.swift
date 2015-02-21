//
//  EditorFileSettings.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorFileSettings {
    private var mode: String? = nil;
    
    private let defaultSettings: EditorDefaultSettings

    private let aceView: ACEView
    
    private let document: NSDocument
        
    init(aceView: ACEView, document: NSDocument, defaultSettings: EditorDefaultSettings) {
        self.defaultSettings = defaultSettings
        self.aceView = aceView
        self.document = document
        
        mode = defaultSettings.mode
        updateView()
    }
    
    func setMode(mode: String?) {
        self.mode = mode
        updateView()
        defaultSettings.setMode(mode)
    }
    
    func setLineEndings(mode: String) {
        aceView.setNewLineMode(mode.lowercaseString)
        document.updateChangeCount(NSDocumentChangeType.ChangeDone)
    }
    
    func getLineEndings() -> String {
        return aceView.getNewLineMode();
    }
    
    func setEncoding(encoding: String) {
    
    }
    
    private func updateView() {
        if mode != nil {
            aceView.setMode(mode!)
        }
    }
    
    func getMode() -> String {
        return mode ?? "text"
    }
    
}