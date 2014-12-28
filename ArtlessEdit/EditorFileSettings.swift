//
//  EditorFileSettings.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class EditorFileSettings {
    private let aceView: ACEView;
    private var mode: Int = 0;
    
    init(aceView: ACEView) {
        self.aceView = aceView
    }
    
    func setMode(mode: ACEMode) {
        self.aceView.setMode(UInt(mode))
        self.mode = mode
    }
    
    func getMode() -> Int {
        return mode
    }
    
}