//
//  CustomCursorButton.swift
//  BH Bezel Test App
//
//  Created by Ben Leggiero on 2017-11-10.
//  Copyright © 2017 Ben Leggiero. All rights reserved.
//

import Cocoa



public class CustomCursorButton: NSButton {
    
    public var cursor: NSCursor = .arrow {
        didSet {
            discardCursorRects()
        }
    }
    
    override public func resetCursorRects() {
        addCursorRect(bounds, cursor: cursor)
    }
}
