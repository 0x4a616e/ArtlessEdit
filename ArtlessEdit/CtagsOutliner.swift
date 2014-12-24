//
//  DefaultOutliner.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class CtagsOutliner: Outliner {
    let EMPTY_DETAILS: [OutlineInfo] = []
    
    func getOutline(tokens: ACEView, file: NSURL) -> [OutlineInfo] {
        if let path = file.path {
            let ctagsPath = "/usr/local/bin/ctags"
            
            if !NSFileManager.defaultManager().isExecutableFileAtPath(ctagsPath) {
                println("Cannot find ctags at " + ctagsPath)
                return EMPTY_DETAILS
            }
            
            let pipe = NSPipe()
            if runCtags(ctagsPath, filePath: path, pipe: pipe) > 0 {
                return EMPTY_DETAILS
            }
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)!
            
            return parseOutput(output)
        }
        
        return EMPTY_DETAILS
    }
    
    func runCtags(ctagsPath: String, filePath: String, pipe: NSPipe) -> Int32 {
        let task = NSTask()
        task.launchPath = ctagsPath
        task.arguments = ["-x", filePath]
        
        
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        return task.terminationStatus
    }
    
    func parseOutput(output: String) -> [OutlineInfo] {
        var result: [OutlineInfo] = []
        
        for line in output.componentsSeparatedByString("\n") {
            let components = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter{!$0.isEmpty}
            
            if components.count > 2 {
                if let number = components[2].toInt() {
                    result.append(OutlineInfo(name: components[0], type: components[1], line: number))
                }
            }
        }
        
        return result.filter{$0.type == "method" || $0.type == "class"}
    }
}