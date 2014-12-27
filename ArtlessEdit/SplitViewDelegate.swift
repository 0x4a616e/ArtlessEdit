//
//  SplitView.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 26/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class SplitViewDelegate: NSObject, NSSplitViewDelegate {
    
    let sidebarSize:CGFloat = 150
    
    func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        return subview.identifier == "Sidebar"
    }
    
    func splitView(splitView: NSSplitView,
        shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
            return true
    }
    
    func splitView(splitView: NSSplitView,
        shouldCollapseSubview subview: NSView,
        forDoubleClickOnDividerAtIndex dividerIndex: Int) -> Bool {
            
        return subview.identifier == "Sidebar"
    }
}