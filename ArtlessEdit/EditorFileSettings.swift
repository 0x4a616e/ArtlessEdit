//
//  EditorFileSettings.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorFileSettings {
    private var mode: Int? = nil;
    
    private let defaultSettings: EditorDefaultSettings

    private let aceView: ACEView
        
    init(aceView: ACEView, defaultSettings: EditorDefaultSettings) {
        self.defaultSettings = defaultSettings
        self.aceView = aceView
    }
    
    func setMode(mode: ACEMode?) {
        self.mode = mode
        
        if let modeIndex = mode {
            aceView.setMode(UInt(modeIndex))
        }
        
        defaultSettings.setMode(mode)
    }
    
    func getMode() -> Int {
        return mode ?? 0
    }
    
}