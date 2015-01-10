//
//  SearchHistory.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 10/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchHistory: NSObject {
    
    let key = "searchHistory"
    let maxItems = 20
    
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var history:[[String]] = [];
    
    override init() {
        super.init()
        
        if let data = userDefaults.arrayForKey(key) as? [[String]] {
            history = data
        }
    }
    
    func addItem(needle: String, replacement:String?) {
        var entry = [needle]
        if (replacement != nil) {
            entry.append(replacement!)
        }
        
        history.insert(entry, atIndex: 0)
        if (history.count > maxItems) {
            history.removeLast()
        }
        
        userDefaults.setObject(history, forKey: key)
    }
    
    func getItem(index: Int) -> [String] {
        return history[index]
    }
    
    func count() -> Int {
        return history.count
    }
}