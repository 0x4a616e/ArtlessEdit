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
        
    init(aceView: ACEView, defaultSettings: EditorDefaultSettings) {
        self.defaultSettings = defaultSettings
        self.aceView = aceView
    }
    
    func setMode(mode: String?) {
        self.mode = mode
        
        if mode != nil {
            aceView.setMode(mode!)
        }
        
        defaultSettings.setMode(mode)
    }
    
    func getMode() -> String {
        return mode ?? "asciidoc"
    }
    
}