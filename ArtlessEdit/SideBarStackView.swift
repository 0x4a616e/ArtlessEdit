//
//  SideBarStackPane.swift
//  ArtlessEdit
//
//  Created by Jan Gassen on 28/12/14.
//  Copyright (c) 2014 Jan Gassen. All rights reserved.
//

import Foundation

class SideBarStackView: NSStackView {
    
    override init() {
        super.init()
        
        setVariables()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setVariables()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVariables() {
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 0
        orientation = NSUserInterfaceLayoutOrientation.Vertical;
    }
    
    override var flipped:Bool {
        get {
            return true
        }
    }
}