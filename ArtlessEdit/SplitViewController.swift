//
//  SplitViewController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class SplitViewController: NSSplitViewController {
        
    @IBOutlet weak var sideBar: SideBar!
    
    func toggleSideBar(sender: AnyObject) {
        sideBar.hidden = !splitView.isSubviewCollapsed(sideBar)
        splitView.adjustSubviews()
    }
}