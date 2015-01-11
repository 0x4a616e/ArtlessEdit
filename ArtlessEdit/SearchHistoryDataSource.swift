//
//  SearchHistoryDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 10/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchHistoryDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchView: SearchViewController!
    
    let history = SearchHistory()
    
    func addItem(needle:String, replacement: String?, options:[String:Bool]) {
        history.addItem(needle, addReplacement: replacement, addOptions:options)
        tableView.reloadData()
    }
    
    @IBAction func selectItem(sender: AnyObject) {
        if let data = history.getItem(tableView.selectedRow) {
            if let options = data[history.options] as? [String:Bool] {
                searchView.setSearchOptions(options)
            }
            if let needle = data[history.needle] as? String {
                searchView.setSearchString(needle)
            }
            if let replacement = data[history.replacement] as? String {
                searchView.setReplaceString(replacement)
            }
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let data = history.getItem(row) {
            
            if (tableColumn?.identifier == "HistorySearchColumn") {
                var view = tableView.makeViewWithIdentifier("HistorySearchCell", owner: self) as NSTableCellView?;
                view?.textField?.stringValue = data[history.needle] as String
                return view
            }
            
            var view = tableView.makeViewWithIdentifier("HistoryReplacementCell", owner: self) as NSTableCellView?;
            if let replacement = data[history.replacement] as? String {
                view?.textField?.stringValue = replacement
            } else {
                view?.textField?.stringValue = ""
            }
            
            
            return view
        }
        
        return nil
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return history.count()
    }
}