//
//  CustomCursorButton.swift
//  BH Bezel Test App
//
//  Created by Ky Leggiero on 2017-11-10.
//  Copyright © 2017 Ky Leggiero. All rights reserved.
//

import AppKit



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
