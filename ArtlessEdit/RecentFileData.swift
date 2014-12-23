//
//  RecentFileData.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class RecentFileData: FileData {
    override func load() {
        update("")
    }
    
    override func update(value: String) {
        let matcher = createEclipseLikeMatcher(value)
        
        if let files = NSDocumentController.sharedDocumentController().recentDocumentURLs as [NSURL]? {
            suggestions = files.filter({(e: NSURL) -> Bool in e.path != nil && e.lastPathComponent != nil && self.matches(e, search: value, matcher: matcher)}).map({(e: NSURL) -> String in e.path!})
        }
    }
    
    func matches(val: NSURL, search: String, matcher: NSRegularExpression?) -> Bool {
        if (search.isEmpty) {
            return true
        }
        
        if let fileName = val.lastPathComponent?.lowercaseString {
            if (fileName.rangeOfString(search.lowercaseString) != nil) {
                return true
            }
        }
        
        if matcher?.matchesInString(val.lastPathComponent!, options: NSMatchingOptions(), range: NSMakeRange(0, countElements(val.lastPathComponent!))).count > 0 {
            return true
        }
        
        return false
    }
    
    func createEclipseLikeMatcher(search: String) -> NSRegularExpression? {
        if (search.isEmpty) {
            return nil
        }
        
        if let expr = NSRegularExpression(pattern: "([A-Z])", options: NSRegularExpressionOptions(), error: nil) {
            let searchExpr = expr.stringByReplacingMatchesInString(search, options: NSMatchingOptions(), range: NSMakeRange(1, countElements(search) - 1), withTemplate: ".*$1") + ".*"
            
            return NSRegularExpression(pattern: searchExpr, options: NSRegularExpressionOptions(), error: nil)
        }
        
        return nil
    }
    
    override func labelValue(row: Int) -> String? {
        if (row >= 0) {
            return suggestions[row].lastPathComponent
        }
        return nil
    }
}