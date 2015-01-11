//
//  OutlinerFactory.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OutlinerFactory {
    class func create(view: ACEView, file: NSURL, mode: String) -> Outliner {
        switch (mode) {
        default: return CtagsOutliner(view: view, file: file, mode: mode)
        }
    }
}