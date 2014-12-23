//
//  SearchPopupData.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 23/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

protocol SearchPopupData {
    func load()
    func count() -> Int
    func update(value: String)
    func labelValue(row: Int) -> String?
    func stringValue(row: Int) -> String?
    func image(row: Int) -> NSImage?
    func select(data: String, panel: NSWindowController)
}