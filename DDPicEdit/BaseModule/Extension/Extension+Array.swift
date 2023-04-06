//
//  Extension+Array.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/2.
//

import Foundation
import Anchorage

public extension Array where Element: NSLayoutConstraint {
    mutating func rebatch(_ block: Block) {
        deactive()
        removeAll()
        appendBatch(block)
    }
    
    mutating func appendBatch(_ closure: Block) {
        append(contentsOf: batch(closure).compactMap { $0 as? Element })
    }
}

public extension Array where Element: NSLayoutConstraint {
    
    func deactive() {
        NSLayoutConstraint.deactivate(self)
    }
    
    func active() {
        NSLayoutConstraint.activate(self)
    }
    
}
