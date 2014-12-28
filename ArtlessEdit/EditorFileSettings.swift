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
    private let sessionSettings: EditorSessionSettings

    private let aceView: ACEView
    
    private var update: ((EditorSettings) -> Void)? = nil
    
    init(aceView: ACEView, defaultSettings: EditorDefaultSettings, sessionSettings: EditorSessionSettings) {
        self.defaultSettings = defaultSettings
        self.sessionSettings = sessionSettings
        self.aceView = aceView
    }
    
    func setMode(mode: ACEMode?) {
        self.mode = mode
        
        if let modeIndex = mode {
            aceView.setMode(UInt(modeIndex))
        }
        
        defaultSettings.setMode(mode)
        sessionSettings.loadDefaults(defaultSettings)

        update?(sessionSettings)
    }
    
    func setUpdateMethod(update: ((EditorSettings) -> Void)?) {
        self.update = update
    }
    
    func getMode() -> Int {
        return mode ?? 0
    }
    
}