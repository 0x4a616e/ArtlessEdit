//
//  Document.swift
//  MyDoc
//
//  Created by Jan Gassen on 21/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    @IBOutlet var documentWindow: NSWindow!
    @IBOutlet weak var aceView: ACEView!
    @IBOutlet var goToPanel: NSWindow!
    @IBOutlet weak var editorSettings: NSScrollView!
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    @IBOutlet weak var splitView: NSSplitView!
    
    lazy var outlineController = OutlineController(windowNibName: "Outline")
    
    var editorSettingsController: EditorSettingsViewController? = nil
    var fileSettingsController: FileSettingsViewController? = nil
    
    var mode: String? = nil
    let encoding = NSUTF8StringEncoding
    lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    var fileContent: String = ""
    
    override init() {
        super.init()
    }
    
    func outline(sender: AnyObject) {
        if (fileURL != nil) {
            outlineController.showWindow(sender, aceView: aceView, mode: mode ?? "text", file: fileURL!)
        }
    }
    
    func showGotoSheet(sender: AnyObject) {
        windowForSheet?.beginSheet(goToPanel, completionHandler: nil)
    }
    
    func toggleSideBar(sender: AnyObject) {
        setSidebarVisibility(splitView.isSubviewCollapsed(visualEffectView))
    }
    
    func setSidebarVisibility(visible: Bool) {
        visualEffectView.hidden = !visible
        splitView.adjustSubviews()
    }
    
    @IBAction func goToLine(sender: AnyObject) {
        if let textField = sender as? NSTextField {
            aceView.gotoLine(textField.integerValue, column: 0, animated: false)
        }
        
        closeSheet(sender)
    }
    
    @IBAction func closeSheet(sender: AnyObject) {
        windowForSheet?.endSheet(goToPanel)
    }
    
    func getMode() -> String? {
        if let path = fileURL?.path {
            println(path.pathExtension)
            if let mapping = FileMapping().getMode(path.pathExtension.lowercaseString) {
                return mapping
            }
            
            return aceView.getModeForPath(path)
        }
        
        return nil;
    }
    
    func showInFinder(sender: AnyObject) {
        if (fileURL != nil) {
            if let url = fileURL!.URLByDeletingLastPathComponent {
                NSWorkspace.sharedWorkspace().openURL(url)
            }
        }
    }
    
    func copyPathToClipboard(sender: AnyObject) {
        if let path = fileURL?.path {
            NSPasteboard.generalPasteboard().setString(path, forType: NSStringPboardType)
        }
    }
    
    func webViewFinishedLoading(notification: NSNotification) {
        if (mode == nil) {
            setMode(getMode())
        }

        aceView.focus()
    }
    
    func setMode(mode: String?) {
        self.mode = mode
        
        let defaultSettings = EditorDefaultSettings.getEditorDefaultSettings(mode)
        let sessionSettings = EditorSessionSettings(aceView: aceView, defaults: defaultSettings)
        
        let fileSettings = EditorFileSettings(aceView: aceView, defaultSettings: defaultSettings)
        fileSettings.setMode(defaultSettings.getMode())
        
        editorSettingsController = EditorSettingsViewController(nibName: "EditorSettings", handler: sessionSettings)
        fileSettingsController = FileSettingsViewController(nibName: "FileSettings", settings: fileSettings)
        
        loadSettingsSideBar(fileSettings, sessionSettings: sessionSettings)
        setSidebarVisibility(defaultSettings.getShowSidebar())
        
        // TODO: Move to view controller
        if (ACEThemeNames.isDarkTheme(defaultSettings.getTheme())) {
            visualEffectView.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        }
    }
    
    
    override func presentedItemDidChange() {
        // Todo: Notify user
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("webViewFinishedLoading:"), name: WebViewProgressFinishedNotification, object: aceView.webView)
        
        aceView.borderType = NSBorderType.NoBorder
        aceView.setString(fileContent)
        aceView.setFontSize(11)
        fileContent = ""
        
        if let url = fileURL {
            addGitAccessory(url)
        }
    }
    
    func addGitAccessory(url: NSURL) {
        let repoFinder = GitRepositoryFinder()
        if let repo = repoFinder.getRepository(url, error: NSErrorPointer()) {
            if let viewController = GitTitleBarAccessoryController(nibName: "GitTitlebarView", url: url, repo: repo){
                dispatch_async(dispatch_get_main_queue()) {
                    self.documentWindow.addTitlebarAccessoryViewController(viewController)
                }
            }
        }
    }
    
    func loadSettingsSideBar(fileSettings: EditorFileSettings, sessionSettings: EditorSessionSettings) {
        let stackView = SideBarStackView()
        if let view = fileSettingsController?.view {
            stackView.addView(view, inGravity: NSStackViewGravity.Top)
        }
        
        if let view = editorSettingsController?.view {
            stackView.addView(view, inGravity: NSStackViewGravity.Center)
        }
        
        editorSettings.documentView = stackView
    }
    
    func findAll(needle: String, options: [String:AnyObject]) -> [ACESearchItem] {
        var fullOptions = options
        fullOptions["needle"] = needle
        
        if let results = aceView.findAll(fullOptions) as? [ACESearchItem] {
            return results
        }
        
        return []
    }
    
    func replaceAll(needle: String, replacement:String, options: [String:AnyObject]) {
        var fullOptions = options
        fullOptions["needle"] = needle
        
        aceView.replaceAll(replacement, options: fullOptions)
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }
    
    override func revertToContentsOfURL(absoluteURL: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        
        aceView.setString(NSString(contentsOfURL: absoluteURL, encoding: encoding, error: nil))
        
        return true
    }
    
    override var windowNibName: String? {
        return "Document"
    }
    
    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
        return aceView.string().dataUsingEncoding(encoding, allowLossyConversion: false)
    }
    
    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        if let content = NSString(data: data, encoding: encoding) {
            fileContent = content
            return true
        }
        
        outError.memory = NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownStringEncodingError, userInfo: nil)
        return false
    }
}

