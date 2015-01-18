//
//  SearchPopupController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class SearchPopupController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchField: NSSearchField!
    
    private var userDefaults = NSUserDefaults.standardUserDefaults()
    private var history:[String] = []
    private var maxHistory = 20
    private var data: SearchPopupData?
    private var userDefaultsPrefix = "SearchPopup"
    private var userDefaultsKey: String = ""
    
    func showWindow(sender: AnyObject?, data: SearchPopupData, title: String) {
        if (self.data != nil) {
            searchField.stringValue = ""
        }
        
        self.data = data
        self.data?.load()
        window?.title = title
        
        userDefaultsKey = userDefaultsPrefix + title
        if let searchHistory = userDefaults.arrayForKey(userDefaultsKey) as? [String] {
            history = searchHistory
        }
        
        tableView.reloadData()
        tableView.selectRowIndexes(NSIndexSet(), byExtendingSelection: false)
        
        super.showWindow(sender)
    }
    
    func addHistoryItem(item: String) {
        history.insert(item, atIndex: 0)
        if history.count > maxHistory {
            history.removeLast()
        }
        userDefaults.setObject(history, forKey: userDefaultsKey)
    }
    
    func control(control: NSControl, textView: NSTextView, completions words: [AnyObject], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [AnyObject] {
        
        return history
    }
    
    @IBAction func clickRow(sender: AnyObject) {
        upadteSearchField(tableView.selectedRow)
        data?.select(searchField.stringValue, panel: self)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return data?.count() ?? 0;
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        let field: NSSearchField = obj.object as NSSearchField;
        
        data?.update(field.stringValue)
        tableView.selectRowIndexes(NSIndexSet(), byExtendingSelection: false)
        tableView.reloadData()
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
            if data?.count() == 1 {
                upadteSearchField(0)
            }
            return true;
        }
        if (commandSelector == Selector("insertNewline:")) {
            if data?.count() == 1 && tableView.selectedRow == -1 {
                upadteSearchField(0)
            }
            addHistoryItem(searchField.stringValue.stringByDeletingLastPathComponent)
            data?.select(searchField.stringValue, panel: self)
            return true;
        }
        
        return false;
    }
    
    func upadteSearchField(row: Int) {
        if let value = data?.stringValue(row) {
            searchField.stringValue = value
        }
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView?
    {
        var view = tableView.makeViewWithIdentifier("SearchPopupCell", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = data?.labelValue(row) ?? ""
        view?.imageView?.image = data?.image(row)
        
        return view
    }

    func selectNextRow() {
        if data == nil || tableView.selectedRow >= data!.count() - 1 {
            return
        }
        tableView.selectRowIndexes(NSIndexSet(index: tableView.selectedRow + 1), byExtendingSelection: false)
        tableView.scrollRowToVisible(tableView.selectedRow)
    }
    
    func selectPrevRow() {
        if data == nil || tableView.selectedRow <= -1 {
            return
        }
        tableView.selectRowIndexes(NSIndexSet(index: tableView.selectedRow - 1), byExtendingSelection: false)
        tableView.scrollRowToVisible(tableView.selectedRow)
    }
}