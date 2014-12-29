//
//  ExternalToolsViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class ExternalToolsViewController: NSViewController {
    
    lazy var settings = ExternalToolsSettings.defaultSettings()
    lazy var fileManager = NSFileManager.defaultManager()
    
    @IBOutlet weak var ctagsPathField: NSTextField!
    
    override func viewDidLoad() {
        initCtagsField()
    }
    
    private func initCtagsField() {
        ctagsPathField.stringValue = settings.getCtagsPath() ?? ""
    }
    
    @IBAction func setCtagsPath(sender: NSTextField) {
        setCtagsPathValue(sender.stringValue)
    }
    
    private func setCtagsPathValue(val: String) {
        if (fileManager.isExecutableFileAtPath(val)) {
            settings.setCtagsPath(val)
        } else {
            initCtagsField()
        }
    }
    
    @IBAction func chooseCtagsPath(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.showsHiddenFiles = true
        panel.directoryURL = NSURL(fileURLWithPath: "/usr/")
        
        panel.beginWithCompletionHandler ({(code) -> Void in
            if let url = panel.URL {
                if let path = url.path {
                    self.setCtagsPathValue(path)
                }
            }
        })
    }
}