//
//  ModeDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 07/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class ModeDataSource: NSObject, NSComboBoxDataSource {
    func numberOfItemsInComboBoxCell(aComboBox: NSComboBox) -> Int {
        return ACEModeNames.humanModeNames().count
    }
    
    func comboBoxCell(aComboBoxCell: NSComboBoxCell, objectValueForItemAtIndex index: Int) -> AnyObject {
        return ACEModeNames.humanModeNames()[index]
    }
}