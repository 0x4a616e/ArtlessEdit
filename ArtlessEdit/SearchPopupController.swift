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
    
    var data: SearchPopupData?
    
    func showWindow(sender: AnyObject?, data: SearchPopupData) {
        self.data = data
        super.showWindow(sender)
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
            if let result = data?.select(searchField.stringValue) {
                if (result) {
                    close()
                }
            }
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