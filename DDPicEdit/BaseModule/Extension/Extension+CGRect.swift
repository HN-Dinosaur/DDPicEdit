//
//  Extension+CGRect.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit

extension CGRect {
    
    func bigger(_ edge: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x - edge.left, y: origin.y - edge.top, width: width + edge.left + edge.right, height: height + edge.top + edge.bottom)
    }
    
    func multipliedBy(_ amount: CGFloat) -> CGRect {
        guard amount != 1.0 else { return self }
        return CGRect(origin: origin.multipliedBy(amount), size: size.multipliedBy(amount))
    }
    
    func reversed(_ flag: Bool = true) -> CGRect {
        return flag ? CGRect(origin: origin.reversed(), size: size.reversed()) : self
    }
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
