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
    @IBOutlet weak var diffItem: NSMenuItem!
    @IBOutlet weak var revertItem: NSMenuItem!
    
    let repo: GTRepository
    let document: Document
    var branch: GTBranch? = nil
    
    let url: NSURL
    let repoRelativePath: String
    
    init?(nibName nibNameOrNil: String?, document: Document, repo: GTRepository) {
        self.repo = repo
        self.document = document
        self.url = document.fileURL!
        
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
                let buffer = patch.patchData()
                if let diff = NSString(data: buffer, encoding: NSUTF8StringEncoding) {
                    if let document:Document = NSDocumentController.sharedDocumentController().openUntitledDocumentAndDisplay(true, error: NSErrorPointer()) as? Document {
                        
                        document.setString(diff)
                        document.setMode("diff")
                    }
                }
            }
        }
    }
    
    @IBAction func revertToIndex(sender: AnyObject) {
        if let content = getContentFromIndex() {
            document.setString(content)
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.setBranchLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.branch = self.repo.currentBranchWithError(NSErrorPointer())
        }
    }
    
    func getContentFromIndex() -> String? {
        if let index = repo.indexWithError(NSErrorPointer()) {
            if let tree = index.writeTree(NSErrorPointer()) {
                if let entry = tree.entryWithPath(repoRelativePath, error: NSErrorPointer()) {
                    if let object = entry.GTObject(NSErrorPointer()) {
                        if let odbObject = object.odbObjectWithError(NSErrorPointer()) {
                            if let data = odbObject.data() {
                                return NSString(data: data, encoding: NSUTF8StringEncoding)
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    func setBranchLabel() {
        if let branchValue = self.branch {
            var label = branchValue.shortName + getStatusLabel() + getAheadBehindLabel(branchValue)
            
            // TODO: Build history from commits
            //let commit = branchValue.targetCommitAndReturnError(error)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.branchItem.title = label
                self.branchItem.toolTip = branchValue.name
            }
        }
    }
    
    func getStatusLabel() -> String {
        var success: ObjCBool = false;
        var error = NSErrorPointer();
        
        let status = repo.statusForFile(repoRelativePath, success: &success, error: error)
        if (success && error == nil) {
            let flags = UInt32(status.rawValue)
            if ((flags & GIT_STATUS_WT_MODIFIED.value) != 0) {
                return "*"
            } else if ((flags & GIT_STATUS_WT_NEW.value) != 0) {
                return "?"
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