//
//  SearchHistory.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 10/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchHistory: NSObject {
    
    let needle = "needle"
    let options = "options"
    let replacement = "replacement"
    
    let userDefaultsKey = "searchHistory"
    let maxItems = 20
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var history:[[String:AnyObject]] = [];
    
    override init() {
        super.init()
        
        if let data = userDefaults.arrayForKey(userDefaultsKey) as? [[String:AnyObject]] {
            history = data
        }
    }
    
    func addItem(addNeedle: String, addReplacement:String?, addOptions: [String:Bool]) {
        var entry:[String:AnyObject] = [needle: addNeedle, options : addOptions]
        if (addReplacement != nil) {
            entry[replacement] = addReplacement
        }
        
        history.insert(entry, atIndex: 0)
        if (history.count > maxItems) {
            history.removeLast()
        }
        
        userDefaults.setObject(history, forKey: userDefaultsKey)
    }
    
    func getItem(index: Int) -> [String:AnyObject]? {
        if (index < 0 || index >= history.count) {
            return nil
        }
        return history[index]
    }
    
    func count() -> Int {
        return history.count
    }
}