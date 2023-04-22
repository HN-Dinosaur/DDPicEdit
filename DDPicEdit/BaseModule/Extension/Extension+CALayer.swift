//
//  Extension+CALayer.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/19.
//

import UIKit

extension CALayer {
    
    func removeSketchShadow() {
        shadowColor = nil
        shadowOpacity = 0
        shadowOffset = CGSize.zero
        shadowRadius = 0
        shadowPath = nil
    }
    
    func applySketchShadow(with shadow: Shadow) {
        applySketchShadow(color: shadow.color, alpha: shadow.alpha, x: shadow.x, y: shadow.y, blur: shadow.blur, spread: shadow.spread)
    }
    
    func applySketchShadow(color: UIColor,
                           alpha: Float,
                           x: CGFloat,
                           y: CGFloat,
                           blur: CGFloat,
                           spread: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
