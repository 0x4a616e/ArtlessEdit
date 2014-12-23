//
//  OpenFileData.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OpenFileData: SearchPopupData {

    lazy var fileManager = NSFileManager()
    lazy var workspace = NSWorkspace.sharedWorkspace()
    
    var currentDirectory = ""
    var currentFiles: [String] = []
    var suggestions: [String] = []
    
    func count() -> Int {
        return suggestions.count
    }
    
    func update(value: String) {
        let path = value.stringByStandardizingPath
        
        var isDir: ObjCBool = false
        fileManager.fileExistsAtPath(path, isDirectory: &isDir)
        
        if (isDir) {
            currentDirectory = path
            currentFiles = fileManager.contentsOfDirectoryAtPath(currentDirectory, error: nil) as [String]? ?? []
            suggestions = currentFiles
        } else {
            let lastComponent = path.lastPathComponent
            suggestions = currentFiles.filter({(e : String) -> Bool in e.hasPrefix(lastComponent)})
        }
    }
    
    func select(data: String) -> Bool {
        var success = false
        
        var isDir: ObjCBool = false
        if !fileManager.fileExistsAtPath(data, isDirectory: &isDir) || isDir {
            return false
        }
        
        if let url = NSURL(fileURLWithPath: data) {
            NSDocumentController.sharedDocumentController().openDocumentWithContentsOfURL(url, display: true, completionHandler: {(document, display, error) -> Void in
                success = true
            })
        }
        
        return success
    }
    
    func labelValue(row: Int) -> String? {
        if (row >= 0) {
            return suggestions[row]
        }
        return nil
    }
    
    func stringValue(row: Int) -> String? {
        if row >= 0 {
            return currentDirectory.stringByAppendingPathComponent(suggestions[row])
        }
        
        return nil
    }
    
    func image(row: Int) -> NSImage? {
        return workspace.iconForFile(stringValue(row)!)
    }
}