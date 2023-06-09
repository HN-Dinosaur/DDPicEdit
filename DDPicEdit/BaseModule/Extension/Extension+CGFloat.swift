//
//  Extension+CGFloat.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit

extension CGFloat {
    
    // 保留places位进位
    func roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
