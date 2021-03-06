//
//  File.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

protocol EditorSettingsObserver: class {
    func updateSettings(settings: EditorSettings)
}