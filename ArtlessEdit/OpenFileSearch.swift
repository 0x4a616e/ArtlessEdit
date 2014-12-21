//
//  OpenSearchDataProvider.swift
//  MyEdit
//
//  Created by Jan Gassen on 08/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Cocoa

class OpenFileSearch: NSObject, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
    
    @IBOutlet weak var panel: NSPanel!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!
    
    lazy var fileManager = NSFileManager()
    lazy var workspace = NSWorkspace.sharedWorkspace()
    
    var currentDirectory: String = ""
    var currentFiles: [String] = []
    var suggestions: [String] = []
    var selectedIndex = -1
    
    @IBAction func selectRow(sender: AnyObject) {
        searchField.stringValue = getSelectedFile(tableView.selectedRow)
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        let field: NSSearchField = obj.object as NSSearchField;
        
        updateCurrentPathSegment(field.stringValue)
    }
    
    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        
        if (commandSelector == Selector("moveUp:") ) {
            searchField.stringValue = selectPrevRow();
            return true;
        }
        if (commandSelector == Selector("moveDown:")) {
            searchField.stringValue = selectNextRow();
            return true;
        }
        if (commandSelector == Selector("insertTab:")) {
            if suggestions.count == 1 {
                searchField.stringValue = getSelectedFile(0)
            }
            return true;
        }
        if (commandSelector == Selector("insertNewline:")) {
            let url = NSURL(fileURLWithPath: searchField.stringValue)!
            
            NSDocumentController.sharedDocumentController().openDocumentWithContentsOfURL(url, display: true, completionHandler: {(document, display, error) -> Void in
                if (error == nil) {
                    self.panel.close()
                }
            })

            return true;
        }
        
        return false;
    }

    
    func updateCurrentPathSegment(segment: NSString) {
        let path = segment.stringByStandardizingPath
        
        var isDir: ObjCBool = false
        fileManager.fileExistsAtPath(path, isDirectory: &isDir)
        
        if (isDir) {
            currentDirectory = path
            currentFiles = fileManager.contentsOfDirectoryAtPath(currentDirectory, error: nil) as [String]
            suggestions = currentFiles
        } else {
            let lastComponent = path.lastPathComponent
            suggestions = currentFiles.filter({(e : String) -> Bool in e.hasPrefix(lastComponent)})
        }
        
        selectedIndex = -1
        tableView.selectRowIndexes(NSIndexSet(), byExtendingSelection: false)
        tableView.reloadData()
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView?
    {
        let filePath = getSelectedFile(row)
        
        var view = tableView.makeViewWithIdentifier("FileCell", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = filePath.lastPathComponent
        view?.imageView?.image = workspace.iconForFile(filePath)
        
        return view
    }
    
    func selectNextRow() -> String {
        if (selectedIndex >= suggestions.count - 1 || suggestions.count == 0) {
            return ""
        }

        selectedIndex += 1
        tableView.selectRowIndexes(NSIndexSet(index: selectedIndex), byExtendingSelection: false)
        tableView.scrollRowToVisible(selectedIndex)
        
        return getSelectedFile(selectedIndex)
    }
    
    func selectPrevRow() -> String {
        if (selectedIndex <= 0 || suggestions.count == 0) {
            return ""
        }
    
        selectedIndex -= 1
        tableView.selectRowIndexes(NSIndexSet(index: selectedIndex), byExtendingSelection: false)
        tableView.scrollRowToVisible(selectedIndex)
        
        return getSelectedFile(selectedIndex)
    }
    
    func getSelectedFile(index: Int) -> String {
        return currentDirectory.stringByAppendingPathComponent(suggestions[index])
    }
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return suggestions.count;
    }
}