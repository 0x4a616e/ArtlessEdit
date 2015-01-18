//
//  FileData.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class FileData: SearchPopupData {
    lazy var fileManager = NSFileManager()
    lazy var workspace = NSWorkspace.sharedWorkspace()
    
    var currentDirectory = ""
    var currentFiles: [String] = []
    var suggestions: [String] = []
    
    func load() {

    }
    
    func count() -> Int {
        return suggestions.count
    }
    
    func update(value: String) {

    }
    
    func select(data: String, panel: NSWindowController) {
        var isDir: ObjCBool = false
        if !fileManager.fileExistsAtPath(data, isDirectory: &isDir) {
            panel.close()
            return;
        }
        
        if isDir {
            update(data)
            return;
        }
        
        if let url = NSURL(fileURLWithPath: data) {
            NSDocumentController.sharedDocumentController().openDocumentWithContentsOfURL(url, display: true, completionHandler: {(document, display, error) -> Void in
                panel.close()
            })
        }
    }
    
    func labelValue(row: Int) -> String? {
        if (row >= 0 && row < suggestions.count) {
            return suggestions[row]
        }
        return nil
    }
    
    func stringValue(row: Int) -> String? {
        if row >= 0 && row < suggestions.count {
            return currentDirectory.stringByAppendingPathComponent(suggestions[row])
        }
        
        return nil
    }
    
    func image(row: Int) -> NSImage? {
        return workspace.iconForFile(stringValue(row)!)
    }

}