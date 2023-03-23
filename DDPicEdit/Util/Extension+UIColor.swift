//
//  Extension+UIColor.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/20.
//

import UIKit

extension UIColor {

    private static func colorWithRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func textMainColor1() -> UIColor { colorWithRGB(20, 25, 30) }
    
    static func textSubColor1() -> UIColor { colorWithRGB(140, 145, 150) }
    
    static func subTitleBackGroudColor() -> UIColor { colorWithRGB(242, 242, 242) }

}
