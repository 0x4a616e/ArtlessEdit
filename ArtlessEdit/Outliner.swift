//
//  Outliner.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OutlineInfo {
    let name: String
    let type: String
    let line: Int
    
    init(name: String, type: String, line: Int) {
        self.name = name
        self.type = type
        self.line = line
    }
}

protocol Outliner {
    func getOutline(tokens: ACEView, file: NSURL) -> [OutlineInfo]
}