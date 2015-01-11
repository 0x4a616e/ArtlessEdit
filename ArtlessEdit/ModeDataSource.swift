//
//  ModeDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 07/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class ModeDataSource: NSObject, NSComboBoxDataSource, NSComboBoxCellDataSource {
    func numberOfItemsInComboBoxCell(aComboBox: NSComboBox) -> Int {
        return ACEModeNames.humanModeNames().count
    }
    
    func comboBoxCell(aComboBoxCell: NSComboBoxCell, objectValueForItemAtIndex index: Int) -> AnyObject {
        return ACEModeNames.humanModeNames()[index]
    }
    
    func comboBoxCell(aComboBoxCell: NSComboBoxCell, indexOfItemWithStringValue string: String) -> Int {
        if let index = find(ACEModeNames.humanModeNames() as [String], string) {
            return index
        }
        return aComboBoxCell.indexOfSelectedItem
    }
    
    func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
        return ACEModeNames.humanModeNames().count
    }
    
    func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
        if (index < 0 || index > ACEModeNames.humanModeNames().count) {
            return ACEModeNames.humanModeNames()[0]
        }
        return ACEModeNames.humanModeNames()[index]
    }
    
    func comboBox(aComboBox: NSComboBox, indexOfItemWithStringValue aString: String) -> Int {
        if let index = find(ACEModeNames.humanModeNames() as [String], aString) {
            return index
        }
        return aComboBox.indexOfSelectedItem
    }
}