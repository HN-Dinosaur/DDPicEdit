//
//  Extension+UIEdgeInset.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/21.
//

import UIKit

extension UIEdgeInsets {
    
    init (horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(edge: CGFloat) {
        self.init(top: edge, left: edge, bottom: edge, right: edge)
    }
    
    var horizontal: CGFloat { left + right }
    var vertical: CGFloat { top + bottom }
    
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
    
    static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top - rhs.top, left: lhs.left - rhs.left, bottom: lhs.bottom - rhs.bottom, right: lhs.right - rhs.right)
    }
    
    static func += (left: inout UIEdgeInsets, right: UIEdgeInsets) {
        left = left + right
    }
    
    static func -= (left: inout UIEdgeInsets, right: UIEdgeInsets) {
        left = left - right
    }
    
}
