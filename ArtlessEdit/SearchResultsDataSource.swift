//
//  SearchResultsDataSource.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 04/01/15.
//  Copyright (c) 2015 Jan Gassen. All rights reserved.
//

import Foundation

class SearchResultsDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {

    lazy var documentController:NSDocumentController = NSDocumentController.sharedDocumentController() as NSDocumentController
    
    @IBOutlet weak var searchHistory: SearchHistoryDataSource!
    
    @IBOutlet weak var resultsTable: NSTableView!
    @IBOutlet weak var tableView: NSTableView!
    
    var results: [SearchResult] = []
    
    func search(needle: String, options:[String: Bool]) {
        results.removeAll(keepCapacity: false)
        
        for document in getSelectedDocuments() {
            let documentResults = document.findAll(needle, options: options)
            for documentResult in documentResults {
                var result = SearchResult()
                result.document = document
                result.match = document.aceView.getLine(documentResult.start_row);
                result.line = documentResult.start_row + 1
                results.append(result)
            }
        }
        
        searchHistory.addItem(needle, replacement: nil, options: options)
        resultsTable.reloadData()
    }
    
    func replace(needle: String, replacement: String, options:[String:Bool]) {
        for document in getSelectedDocuments() {
            document.replaceAll(needle, replacement: replacement, options: options)
        }
        
        searchHistory.addItem(needle, replacement: replacement, options:options)
        results.removeAll(keepCapacity: false)
        resultsTable.reloadData()
    }
    
    @IBAction func selectMatch(sender: AnyObject) {
        if (resultsTable.selectedRow < results.count && resultsTable.selectedRow >= 0) {
            let match = results[resultsTable.selectedRow]
            match.document?.aceView.gotoLine(match.line, column: 0, animated: false);
        }
    }
    
    func getSelectedDocuments() -> [Document] {
        var documents:[Document] = []
        tableView.selectedRowIndexes.enumerateIndexesUsingBlock { (index, selected) -> Void in
            if (index < self.documentController.documents.count && index >= 0) {
                documents.append(self.documentController.documents[index] as Document)
            }
        }
        
        return documents
    }
    
    func tableView(tableView: NSTableView!, viewForTableColumn tableColumn: NSTableColumn!, row: Int)-> NSTableCellView?{
        if tableColumn.identifier == "SearchResultMatchColumn" {
            var view = tableView.makeViewWithIdentifier("SearchResultMatchCell", owner: self) as NSTableCellView?;
            view?.textField?.stringValue = results[row].match
            return view
        }
        
        var view = tableView.makeViewWithIdentifier("SearchResultFileCell", owner: self) as NSTableCellView?;
        
        var fileName = results[row].document?.displayName ?? ""
        
        var label = NSString(format: "%@:%lu", fileName, results[row].line)
        view?.textField?.stringValue = label
        return view
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return results.count
    }
    
}