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
    
    let history = SearchHistory()
    
    func addItem(needle:String, replacement: String?) {
        history.addItem(needle, replacement: replacement)
        tableView.reloadData()
    }
    
    @IBAction func selectItem(sender: AnyObject) {
        
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let data = history.getItem(row)
        
        if (tableColumn?.identifier == "HistorySearchColumn") {
            var view = tableView.makeViewWithIdentifier("HistorySearchCell", owner: self) as NSTableCellView?;
            view?.textField?.stringValue = data[0]
            return view
        }
        
        var view = tableView.makeViewWithIdentifier("HistoryReplacementCell", owner: self) as NSTableCellView?;
        if (data.count > 1) {
            view?.textField?.stringValue = data[1]
        } else {
            view?.textField?.stringValue = ""
        }
        
        return view
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return history.count()
    }
}