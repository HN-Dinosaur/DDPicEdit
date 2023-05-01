//
//  UIKitConstant.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/30.
//

import UIKit

public struct UIKitConstant {
    public static let UINavigationBarHeight: CGFloat = 44
    public static let UITabBarHeight: CGFloat = 49 + bottomSafeAraeHeight
    public static let UIStatusBarNormalStateHeightBeforeiPhoneX: CGFloat = 20
    public static let UIStatusBarHeight: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0

    public static let UIAppHeaderBarHeight = UIStatusBarHeight + UINavigationBarHeight
    public static let UIScreenHeight = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width) // 避免初始化时为横屏状态
    public static let UIScreenWidth = min(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)
    public static let bottomSafeAraeHeight: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0

    private static func isFullScreenDevice() -> Bool {
        if let window = UIApplication.shared.delegate?.window {
            if let bottom = window?.safeAreaInsets.bottom {
                return bottom > 0
            }
        }
        return false
    }
}
