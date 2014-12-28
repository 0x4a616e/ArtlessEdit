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
        modeBox.addItemsWithObjectValues(ACEModeNames.humanModeNames())
        modeBox.selectItemAtIndex(settings.getMode())
        
        encodingBox.selectItemAtIndex(0)
        lineEndingBox.selectItemAtIndex(0)
    }
    
    @IBAction func changeMode(sender: NSComboBox) {
        settings.setMode(sender.indexOfSelectedItem)
    }
}