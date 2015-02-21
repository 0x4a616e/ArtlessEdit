//
//  FileSettingsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class FileSettingsViewController: NSViewController {
    
    @IBOutlet weak var modeBox: NSComboBox!
    @IBOutlet weak var encodingBox: NSComboBox!
    @IBOutlet weak var lineEndingBox: NSComboBox!
    
    let settings: EditorFileSettings
    
    init?(nibName nibNameOrNil: String?, settings: EditorFileSettings) {
        self.settings = settings
        
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        modeBox.selectItemAtIndex(ACEModeNames.getIndexByName(settings.getMode()))
        
        encodingBox.selectItemAtIndex(0)
        
        let lineEndings = settings.getLineEndings()
        let selectedIndex = lineEndingBox.indexOfItemWithObjectValue(lineEndings.capitalizedString)
        lineEndingBox.selectItemAtIndex((selectedIndex == NSNotFound) ? 0 : selectedIndex)
    }
    
    @IBAction func changeLineEndings(sender: NSComboBox) {
        settings.setLineEndings(sender.stringValue)
    }
    
    @IBAction func changeEncoding(sender: NSComboBox) {
    }
    
    @IBAction func changeMode(sender: NSComboBox) {
        settings.setMode(ACEModeNames.getNameByIndex(sender.indexOfSelectedItem))
    }
}