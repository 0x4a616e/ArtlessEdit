//
//  OpenFilesDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 04/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class OpenFilesDataSource: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    lazy var workspace = NSWorkspace.sharedWorkspace()
    lazy var documentController:NSDocumentController = NSDocumentController.sharedDocumentController() as NSDocumentController
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView? {
        var doc: Document = documentController.documents[row] as Document
        
        var view = tableView.makeViewWithIdentifier("OpenFileView", owner: self) as NSTableCellView?;
        
        view?.textField?.stringValue = doc.displayName
        if let path = doc.fileURL?.path {
            view?.imageView?.image = workspace.iconForFile(path)
        } else {
            view?.imageView?.image = workspace.iconForFileType(NSFileTypeUnknown)
        }
        
        return view
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return documentController.documents.count
    }
}