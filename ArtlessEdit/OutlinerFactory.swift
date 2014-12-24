//
//  OutlinerFactory.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 24/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class OutlinerFactory {
    class func create(mode: ACEMode) -> Outliner {
        switch (mode) {
        default: return CtagsOutliner()
        }
    }
}