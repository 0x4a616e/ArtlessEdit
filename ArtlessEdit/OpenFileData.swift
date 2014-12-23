//
//  OpenFileData.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OpenFileData: FileData {

    override func load() {
        suggestions = []
    }
    
    override func update(value: String) {
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
    
}