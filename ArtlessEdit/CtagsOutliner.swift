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
    
    let view: ACEView
    let file: NSURL
    
    required init(view: ACEView, file: NSURL, mode: ACEMode) {
        self.view = view
        self.file = file
    }
    
    func getOutline(fn: ([OutlineInfo]) -> Void) {
        if let path = file.path {
            let ctagsPath = "/usr/local/bin/ctags"
            
            if !NSFileManager.defaultManager().isExecutableFileAtPath(ctagsPath) {
                println("Cannot find ctags at " + ctagsPath)
                return
            }
            
            let pipe = NSPipe()
            let task = startCtags(ctagsPath, filePath: path, pipe: pipe)
        
            let handle = pipe.fileHandleForReading
            let bufferSize = 4096
            
            if let delimiter = "\n".dataUsingEncoding(NSUTF8StringEncoding) {
                if let buffer = NSMutableData(capacity: bufferSize) {
                    var newData = handle.availableData
                    
                    while newData.length > 0 {
                        buffer.appendData(newData.subdataWithRange(NSMakeRange(0, min(newData.length, bufferSize))))
                        
                        var outlines: [OutlineInfo] = []
                        var lastLocation = 0
                        var range = buffer.rangeOfData(delimiter, options: nil, range: NSMakeRange(0, buffer.length))
                        
                        while range.location != NSNotFound {
                            if let line = NSString(data: buffer.subdataWithRange(NSMakeRange(lastLocation, range.location - lastLocation)), encoding: NSUTF8StringEncoding) {
                                
                                if let info = parseLine(line) {
                                    outlines.append(info)
                                }
                            }
                            
                            lastLocation = range.location + 1
                            range = buffer.rangeOfData(delimiter, options: nil, range: NSMakeRange(lastLocation, buffer.length - lastLocation))
                        }
                        
                        if (outlines.count > 0) {
                            fn(outlines)
                        }
                        
                        buffer.replaceBytesInRange(NSMakeRange(0, lastLocation), withBytes: nil, length: 0)
                        newData = handle.availableData
                    }
                }
            }
        }
    }
    
    func startCtags(ctagsPath: String, filePath: String, pipe: NSPipe) -> NSTask {
        let task = NSTask()
        task.launchPath = ctagsPath
        task.arguments = ["-x", filePath]
        
        
        task.standardOutput = pipe
        task.launch()
        
        return task
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
    
    func parseLine(line: String) -> OutlineInfo? {
        let components = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter{!$0.isEmpty}
        
        if components.count > 2 {
            if let number = components[2].toInt() {
                return OutlineInfo(name: components[0], type: components[1], line: number)
            }
        }
        
        return nil
    }
}