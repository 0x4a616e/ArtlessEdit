//
//  DefaultSettingsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 27/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class SettingsModeViewController: NSViewController {

    let settings: EditorDefaultSettings
    let controller: EditorSettingsViewController?;
    
    @IBOutlet weak var syntaxBox: NSComboBox!
    @IBOutlet weak var deleteButton: NSButton!
    
    init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, settings: EditorDefaultSettings, controller: EditorSettingsViewController?) {
        self.settings = settings
        self.controller = controller
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBAction func resetToDefaults(sender: AnyObject) {
        settings.resetToDefaults()
        controller?.loadSettings(settings)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        syntaxBox.addItemWithObjectValue("Default")
        syntaxBox.addItemsWithObjectValues(ACEModeNames.humanModeNames())
        syntaxBox.selectItemAtIndex(0)
        
        deleteButton.enabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func setSyntax(sender: NSComboBox) {
        if sender.indexOfSelectedItem > 0 {
            let mode = sender.indexOfSelectedItem - 1
            settings.setMode(mode)
            deleteButton.enabled = true
        } else {
            settings.setMode(nil)
            deleteButton.enabled = false
        }
        
        controller?.loadSettings(settings)
    }
}