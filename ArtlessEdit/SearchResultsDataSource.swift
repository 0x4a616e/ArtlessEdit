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
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var replaceField: NSTextField!
    
    @IBOutlet weak var caseSensitiveCheckbox: NSButton!
    @IBOutlet weak var regexCheckbox: NSButton!
    @IBOutlet weak var wholeWordCheckbox: NSButton!
    
    var results: [SearchResult] = []
    
    func getSearchOptions() -> [String:Bool] {
        var options: [String:Bool] = [:]
        
        if regexCheckbox.state == NSOnState {
            options["regExp"] = true
        }
        
        if caseSensitiveCheckbox.state == NSOnState {
            options["caseSensitive"] = true
        }
        
        if wholeWordCheckbox.state == NSOnState {
            options["wholeWord"] = true
        }

        return options
    }
    
    @IBAction func search(sender: AnyObject) {
        results.removeAll(keepCapacity: false)
        
        for document in getSelectedDocuments() {
            println(document.displayName)
            
            let documentResults = document.findAll(searchField.stringValue, options: getSearchOptions())
            for documentResult in documentResults {
                var result = SearchResult()
                result.document = document
                result.match = document.aceView.getLine(documentResult.start_row);
                result.line = documentResult.start_row + 1
                results.append(result)
            }
        }
        
        searchHistory.addItem(searchField.stringValue, replacement: nil)
        resultsTable.reloadData()
    }
    
    @IBAction func replace(sender: AnyObject) {
        for document in getSelectedDocuments() {
            println(document.displayName)
            document.replaceAll(searchField.stringValue, replacement: replaceField.stringValue, options: getSearchOptions())
        }
        
        searchHistory.addItem(searchField.stringValue, replacement: replaceField.stringValue)
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
            documents.append(self.documentController.documents[index] as Document)
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