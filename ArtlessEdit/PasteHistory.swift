//
//  PasteHistory.swift
//  MyDoc
//
//  Created by Jan Gassen on 21/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Cocoa

class PasteHistory: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var panel: NSPanel!
    @IBOutlet weak var tableView: NSTableView!
    
    let pasteboard = NSPasteboard.generalPasteboard()
    let maxSize = 20
    var lastChangeCount = 0
    var items: [String] = []
    
    override init() {
        super.init()
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    @IBAction func pasteSelection(sender: AnyObject) {
        panel.close()
        pasteboard.setString(items[tableView.selectedRow], forType: NSStringPboardType)
        NSApplication.sharedApplication().sendAction("paste:", to: nil, from: self)
    }
    
    func update(sender: AnyObject) {
        if pasteboard.changeCount != lastChangeCount {
            
            if let value = pasteboard.stringForType(NSStringPboardType) {
                addValue(value)
            }
            
            lastChangeCount = pasteboard.changeCount
        }
    }
    
    func addValue(value: String) {
        items.insert(value, atIndex: 0)
        if items.count > maxSize {
            items.removeAtIndex(maxSize)
        }
        
        tableView.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return items.count;
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView?
    {
        var view = tableView.makeViewWithIdentifier("PasteCell", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = items[row]
        
        return view

    }
}
