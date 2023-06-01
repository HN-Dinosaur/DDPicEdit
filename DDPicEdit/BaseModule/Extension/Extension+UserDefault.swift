//
//  Extension+UserDefault.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/29.
//

import UIKit

public extension UserDefaults {
    @UserDefaultValue(key: "brushColorIdx")
    @objc static var brushColorIdx = 2
    
    @UserDefaultValue(key: "mosaicIdx")
    @objc static var mosaicIdx = 0
}
