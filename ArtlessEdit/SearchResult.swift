//
//  SearchResult.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 04/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchResult: NSObject {
    var match: String = ""
    var line: Int = 0
    var document: Document?
}