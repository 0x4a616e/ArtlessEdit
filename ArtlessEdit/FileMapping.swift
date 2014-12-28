//
//  FileMapping.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class FileMapping {
    private let fileModeSettings = "fileModeSettings"
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private var mappings: [String:Int] = [:]
    
    init() {
        if let data = userDefaults.objectForKey(fileModeSettings) as? [String: Int] {
            mappings = data
        } else {
            userDefaults.setObject(mappings, forKey: fileModeSettings)
        }
    }
    
    func getMode(forFile: String) -> Int? {
        return mappings[forFile]
    }
    
    func getFiles() -> [String] {
        return mappings.keys.array
    }
    
    func removeFile(file: String) {
        var mappingsUpdate = self.mappings
        mappingsUpdate.removeValueForKey(file)
        userDefaults.setObject(mappingsUpdate, forKey: fileModeSettings)
        mappings = mappingsUpdate
    }
    
    func setMode(forFile: String, mode: Int) {
        var mappingsUpdate = self.mappings
        mappingsUpdate[forFile] = mode
        userDefaults.setObject(mappingsUpdate, forKey: fileModeSettings)
        mappings = mappingsUpdate
    }
    
    func count() -> Int {
        return mappings.count
    }
}