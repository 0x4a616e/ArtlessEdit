//
//  Outline.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OutlineController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var tags: [OutlineInfo] = []
    
    func showWindow(sender: AnyObject?, aceView: ACEView, mode: ACEMode, file: NSURL) {
        super.showWindow(sender)
        
        tags = []
        if window != nil {
            asyncLoadData(aceView, mode: mode, file: file)
        }
    }
    
    func asyncLoadData(aceView: ACEView, mode: ACEMode, file: NSURL) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let outliner = OutlinerFactory.create(mode)
            self.tags += outliner.getOutline(aceView, file: file)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.noteNumberOfRowsChanged()
            }
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tags.count;
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        let field: NSSearchField = obj.object as NSSearchField;
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView? {
        var view = tableView.makeViewWithIdentifier("OutlineCell", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = tags[row].name
        view?.imageView = nil
        
        return view
    }

}