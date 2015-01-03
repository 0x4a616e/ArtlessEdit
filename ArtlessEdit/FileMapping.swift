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
    
    // Mappings are loaded as defaults and overwritten by modifications
    private var mappings: [String:String] = [
        "cpp": "c_cpp",
        "h": "c_cpp",
        "html": "html",
        "java":"java",
        "js": "javascript",
        "py": "python",
        "xml": "xml"
    ]
    
    init() {
        if let data = userDefaults.objectForKey(fileModeSettings) as? [String: String] {
            mappings = data
        } else {
            userDefaults.setObject(mappings, forKey: fileModeSettings)
        }
    }
    
    func getMode(forFile: String) -> String? {
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
    
    func setMode(forFile: String, mode: String) {
        var mappingsUpdate = self.mappings
        mappingsUpdate[forFile] = mode
        userDefaults.setObject(mappingsUpdate, forKey: fileModeSettings)
        mappings = mappingsUpdate
    }
    
    func count() -> Int {
        return mappings.count
    }
}