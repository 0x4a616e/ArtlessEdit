//
//  GitTitlebarAccessoryController.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 12/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class GitTitleBarAccessoryController: NSTitlebarAccessoryViewController {
    
    @IBOutlet weak var gitMenu: NSMenu!
    @IBOutlet weak var branchItem: NSMenuItem!
    
    let repo: GTRepository
    
    init?(nibName nibNameOrNil: String?, repo: GTRepository) {
        self.repo = repo
        super.init(nibName: nibNameOrNil, bundle: nil)
        
        layoutAttribute = NSLayoutAttribute.Right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let branch = repo.currentBranchWithError(NSErrorPointer()) {
            var label = branch.shortName as String
            var success: ObjCBool = false
            if let trackingBranch = branch.trackingBranchWithError(NSErrorPointer(), success: &success) {
                var error = NSErrorPointer()
                var ahead: UInt = 0
                var behind: UInt = 0
                
                branch.calculateAhead(&ahead, behind: &behind, relativeTo: trackingBranch, error: error)
                
                if (error == nil || error.memory == nil) {
                    label += String(format: " [+%ld, -%ld]", ahead, behind)
                }
            }
            
            branchItem.title = label
            branchItem.toolTip = branch.name
        }
    }
}