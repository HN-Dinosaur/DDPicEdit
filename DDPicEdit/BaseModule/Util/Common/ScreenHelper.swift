//
//  ScreenHelper.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import UIKit

struct ScreenHelper {
    static var keyWindows: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    static var statusBarFrame: CGRect {
        return UIApplication.shared.statusBarFrame
    }
    
    static var mainBounds: CGRect {
        return UIApplication.shared.windows[0].bounds
    }
}

