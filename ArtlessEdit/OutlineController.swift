//
//  Outline.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OutlineController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!
    
    var tags: [OutlineInfo] = []
    var searchResult: [OutlineInfo] = []
    var aceView: ACEView? = nil
    
    func showWindow(sender: AnyObject?, aceView: ACEView, mode: String, file: NSURL) {
        super.showWindow(sender)
        self.aceView = aceView
        
        tags = []
        if window != nil {
            asyncLoadData(aceView, mode: mode, file: file)
        }
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        let field: NSSearchField = obj.object as NSSearchField;
        
        updateSearchResult(searchString: field.stringValue)
        tableView.reloadData()
    }
    
    func asyncLoadData(aceView: ACEView, mode: String, file: NSURL) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let outliner = OutlinerFactory.create(aceView, file: file, mode: mode)
            outliner.getOutline(self.addData)
        }
    }
    
    func addData(data: [OutlineInfo]) {
        self.tags += data
        self.updateSearchResult()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.noteNumberOfRowsChanged()
        }
    }
    
    func updateSearchResult(searchString: String? = nil) {
        if searchString == nil || searchString!.isEmpty {
            searchResult = tags
        } else {
            searchResult = tags.filter{$0.name.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil}
        }
    }
    
    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        if (commandSelector == Selector("moveUp:") ) {
            selectPrevRow()
            upadteSearchField(tableView.selectedRow)
            return true;
        }
        if (commandSelector == Selector("moveDown:")) {
            selectNextRow()
            upadteSearchField(tableView.selectedRow)
            return true;
        }
        if (commandSelector == Selector("insertTab:")) {
            if searchResult.count == 1 {
                upadteSearchField(0)
                selectRow(0)
            }
            return true;
        }
        if (commandSelector == Selector("insertNewline:")) {
            if searchResult.count > 0 && tableView.selectedRow > -1 {
                aceView?.gotoLine(searchResult[tableView.selectedRow].line, column: 0, animated: false)
                close()
            }
            return true;
        }
        
        return false;
    }
    
    func upadteSearchField(row: Int) {
        searchField.stringValue = searchResult[row].name
    }
    
    func selectNextRow() {
        if searchResult.count == 0  || tableView.selectedRow >= searchResult.count - 1 {
            return
        }
        selectRow(tableView.selectedRow + 1)
    }
    
    func selectPrevRow() {
        if searchResult.count == 0 || tableView.selectedRow <= -1 {
            return
        }
        selectRow(tableView.selectedRow - 1)
    }
    
    func selectRow(row: Int) {
        tableView.selectRowIndexes(NSIndexSet(index: row), byExtendingSelection: false)
        tableView.scrollRowToVisible(tableView.selectedRow)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return searchResult.count;
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView? {
        var view = tableView.makeViewWithIdentifier("OutlineCell", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = searchResult[row].name
        view?.imageView?.image = getIconFor(searchResult[row].type)
        
        return view
    }
    
    func getIconFor(type: String) -> NSImage? {
        switch (type) {
        case "class": return NSImage(named: "icon_class")
        case "method": return NSImage(named: "icon_method")
        default: return NSImage(named: "icon_unknown")
        }
    }

}