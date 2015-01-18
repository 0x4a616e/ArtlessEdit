//
//  GitRepository.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 13/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class GitRepositoryFinder {
    let fileManager = NSFileManager.defaultManager()
    
    func isPossibleRepository(url: NSURL) -> Bool {
        if let lastComponent = url.lastPathComponent {
            if (lastComponent.hasSuffix(".git")) {
                return true
            }
        }
        
        var isDir: ObjCBool = false
        if let gitPath = url.URLByAppendingPathComponent(".git").path {
            if fileManager.fileExistsAtPath(gitPath, isDirectory: &isDir) {
                if (isDir) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getRepository(url: NSURL, error: NSErrorPointer) -> GTRepository? {
        var baseUrl = url.URLByDeletingLastPathComponent
        while baseUrl != nil && !isRoot(baseUrl) && !isPossibleRepository(baseUrl!) {
            baseUrl = baseUrl?.URLByDeletingLastPathComponent
        }
        
        if baseUrl != nil {
            return GTRepository(URL: baseUrl, error: error)
        }
        
        return nil;
    }
    
    func isRoot(url: NSURL?) -> Bool {
        return url?.path?.stringByStandardizingPath == "/"
    }

}