//
//  Extension+UIColor.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/20.
//

import UIKit

extension UIColor {

    private static func colorWithRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    public static func color(hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16)
        let g = CGFloat((hex & 0x00FF00) >> 8)
        let b = CGFloat(hex & 0x0000FF)
        return colorWithRGB(r, g, b, alpha)
    }
    
    static func textMainColor1() -> UIColor { colorWithRGB(20, 25, 30) }
    
    static func textSubColor1() -> UIColor { colorWithRGB(140, 145, 150) }
    
    static func subTitleBackGroudColor() -> UIColor { colorWithRGB(242, 242, 242) }

}
