//
//  SearchViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 11/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchViewController: NSViewController {
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var replaceField: NSTextField!
    
    @IBOutlet weak var regexCheckbox: NSButton!
    @IBOutlet weak var caseCheckbox: NSButton!
    @IBOutlet weak var wordCheckbox: NSButton!
    
    @IBOutlet weak var searchResults: SearchResultsDataSource!
    
    private let regExp = "regExp"
    private let caseSensitive = "caseSensitive"
    private let wholeWord = "wholeWord"
    
    func setSearchOptions(options:[String:Bool]) {
        if let regExpState = options[regExp] as Bool? {
            regexCheckbox.state = (regExpState) ? NSOnState : NSOffState
        }
        
        if let caseSensitiveState = options[caseSensitive] as Bool? {
            caseCheckbox.state = (caseSensitiveState) ? NSOnState : NSOffState
        }
        
        if let wholeWordState = options[wholeWord] as Bool? {
            wordCheckbox.state = (wholeWordState) ? NSOnState : NSOffState
        }
    }
    
    func setSearchString(needle:String) {
        searchField.stringValue = needle
    }
    
    func setReplaceString(replacement:String) {
        replaceField.stringValue = replacement
    }
    
    func getSearchOptions() -> [String:Bool] {
        var options: [String:Bool] = [:]
        
        if regexCheckbox.state == NSOnState {
            options[regExp] = true
        }
        
        if caseCheckbox.state == NSOnState {
            options[caseSensitive] = true
        }
        
        if wordCheckbox.state == NSOnState {
            options[wholeWord] = true
        }
        
        return options
    }
    
    @IBAction func search(sender: AnyObject) {
        searchResults.search(searchField.stringValue, options: getSearchOptions())
    }
    
    @IBAction func replace(sender: AnyObject) {
        searchResults.replace(searchField.stringValue, replacement: replaceField.stringValue, options: getSearchOptions())
    }

}