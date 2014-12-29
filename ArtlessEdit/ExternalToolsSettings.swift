//
//  ExternalToolsSettings.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 29/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class ExternalToolsSettings {
    var ctagsPath: String? = nil
    
    let CTAGS_PATH = "CtagsPath"
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()

    init() {
        userDefaults.registerDefaults([getKey("CtagsPath"): "/usr/local/bin/ctags"])
    }
    
    func setCtagsPath(val: String) {
        userDefaults.setObject(val, forKey: getKey("CtagsPath"))
    }
    
    func getCtagsPath() -> String? {
        return userDefaults.stringForKey(getKey("CtagsPath"))
    }
    
    private func getKey(val: String) -> String {
        return "externalTools_" + val
    }
    
    class func defaultSettings() -> ExternalToolsSettings {
        struct Holder {
            static var externalTools = ExternalToolsSettings()
        }
        return Holder.externalTools
    }
}