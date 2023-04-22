//
//  Extension+CABasicAnimation.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/16.
//

import UIKit

extension CABasicAnimation {
    
    static func create(keyPath: String = "path", duration: CFTimeInterval, fromValue: Any?, toValue: Any?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}
