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
    let url: NSURL
    let repoRelativePath: String
    
    init?(nibName nibNameOrNil: String?, url: NSURL, repo: GTRepository) {
        self.repo = repo
        self.url = url
        self.repoRelativePath = GitTitleBarAccessoryController.pathRelativeTo(url.path!, to:repo.fileURL.path!)

        super.init(nibName: nibNameOrNil, bundle: nil)
        
        layoutAttribute = NSLayoutAttribute.Right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func showDiff(sender: AnyObject) {
        var error = NSErrorPointer()
        let options:[NSObject: AnyObject] = [GTDiffOptionsPathSpecArrayKey:[repoRelativePath]]
        
        let diff = GTDiff(indexToWorkingDirectoryInRepository: repo, options: options, error: error)
        
        if (error == nil && diff.deltaCount == 1){
            let delta = GTDiffDelta(diff: diff, deltaIndex: 0)
            let patch = delta.generatePatch(error)
            if (error == nil) {
                let buffer = patch.toBuffer()
                let diff = NSString(data: buffer, encoding: NSUTF8StringEncoding)
                
                if let document:Document = NSDocumentController.sharedDocumentController().openUntitledDocumentAndDisplay(true, error: NSErrorPointer()) as? Document {
                    
                    document.aceView.setString(diff)
                    document.setMode("diff")
                }
            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let branch = repo.currentBranchWithError(NSErrorPointer()) {
            var label = branch.shortName as String

            branchItem.title = label + getStatusLabel() + getAheadBehindLabel(branch)
            branchItem.toolTip = branch.name
        }
    }
    
    func getStatusLabel() -> String {
        var success: ObjCBool = false;
        var error = NSErrorPointer();
        
        let status = repo.statusForFile(repoRelativePath, success: &success, error: error)
        if (success && error == nil) {
            if ((UInt32(status.rawValue) & GIT_STATUS_WT_MODIFIED.value) != 0) {
                return "*"
            }
        }
        
        return ""
    }
    
    func getAheadBehindLabel(branch: GTBranch) -> String {
        var success: ObjCBool = false
        if let trackingBranch = branch.trackingBranchWithError(NSErrorPointer(), success: &success) {
            var error = NSErrorPointer()
            var ahead: UInt = 0
            var behind: UInt = 0
            
            branch.calculateAhead(&ahead, behind: &behind, relativeTo: trackingBranch, error: error)
            
            if (error == nil) {
                return String(format: " [+%ld, -%ld]", ahead, behind)
            }
        }
        
        return ""
    }
    
    private class func pathRelativeTo(path: String, to: String) -> String {
        return path.stringByStandardizingPath.stringByReplacingOccurrencesOfString(to.stringByStandardizingPath + "/", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
    }
}