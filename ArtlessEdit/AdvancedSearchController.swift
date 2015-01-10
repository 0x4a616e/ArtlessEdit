//
//  AdvancedSearchViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 04/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class AdvancedSearchController: NSWindowController {
    
    @IBOutlet weak var openFiles: NSTableView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        
        openFiles.reloadData()
    }
}