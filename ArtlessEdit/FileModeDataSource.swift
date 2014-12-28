//
//  FileModeDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class FileModeDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxCellDataSource {

    private let defaultString = ""
    private let defaultFileMode = 0
    private let mappings = FileMapping()
    
    @IBOutlet weak var tableView: NSTableView!
    
    func getFileEnding(row: Int) -> String {
        if row >= mappings.count() {
            return defaultString
        }
        
        return mappings.getFiles()[row]
    }
    
    func getModeSelectorBox(row: Int) -> String {
        if row < mappings.count() {
            if let modeIndex = mappings.getMode(mappings.getFiles()[row]) {
                return ACEModeNames.humanModeNames()[modeIndex] as String
            }
        }
        
        return ACEModeNames.humanModeNames()[defaultFileMode] as String
    }
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        
        let fileEnding = getFileEnding(row)
        let fileMode = mappings.getMode(fileEnding) ?? defaultFileMode
        
        if (tableColumn?.identifier == "FileEndingColumn") {
            if let newFileEnding = object as? String {
                mappings.removeFile(fileEnding)
                if (newFileEnding != defaultString) {
                    mappings.setMode(newFileEnding, mode: fileMode)
                }
            }
        } else if (tableColumn?.identifier == "FileModeColumn") {
            if let newFileMode = object as? String {
                if let index = find(ACEModeNames.humanModeNames() as [String], newFileMode) {
                     mappings.setMode(fileEnding, mode: index)
                }
            }
        }

        tableView.reloadData()
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        var view: AnyObject? = nil
        
        if let identifier = tableColumn?.identifier {
            switch (identifier) {
            case "FileEndingColumn": view = getFileEnding(row); break
            case "FileModeColumn": view = getModeSelectorBox(row); break
            default: break
            }
        }
        
        return view
    }
    
    func numberOfItemsInComboBoxCell(aComboBox: NSComboBox) -> Int {
        return ACEModeNames.humanModeNames().count
    }
    
    func comboBoxCell(aComboBoxCell: NSComboBoxCell, objectValueForItemAtIndex index: Int) -> AnyObject {
        return ACEModeNames.humanModeNames()[index]
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return mappings.count() + 1
    }

}