//
//  DefaultSettingsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class DefaultSettingsViewController: NSViewController {
    var editorSettingsController: EditorSettingsViewController? = nil
    var settingsModeController: ModeSettingsViewController? = nil
    
    @IBOutlet weak var editorSettings: NSScrollView!
    
    override func viewDidLoad() {
        let stackView = SideBarStackView()
        
        let settings = EditorDefaultSettings()
        editorSettingsController = EditorSettingsViewController(nibName: "EditorSettings", handler: settings)
        if let settingsView = editorSettingsController?.view {
            stackView.addView(settingsView, inGravity: NSStackViewGravity.Center)
        }
        
        settingsModeController = ModeSettingsViewController(nibName: "ModeSettings", bundle: nil, settings: settings, controller: editorSettingsController)
        if let settingsView = settingsModeController?.view {
            stackView.addView(settingsView, inGravity: NSStackViewGravity.Top)
        }
        
        editorSettings?.documentView = stackView
    }
}