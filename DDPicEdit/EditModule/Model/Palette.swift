//
//  Palette.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/8.
//

import UIKit

public struct Palette {
    
    public static var primary: UIColor {
        return UIColor.color(hex: 0x56BF6A)
    }
    
    public static var white: UIColor {
        return UIColor.color(hex: 0xF2F2F2)
    }
    
    public static var black: UIColor {
        return UIColor.color(hex: 0x2B2B2B)
    }

    public static var red: UIColor {
        return UIColor.color(hex: 0xFA5151)
    }

    public static var yellow: UIColor {
        return UIColor.color(hex: 0xFFC300)
    }

    public static var green: UIColor {
        return UIColor.color(hex: 0x07C160)
    }

    public static var blue: UIColor {
        return UIColor.color(hex: 0x10AEFF)
    }

    public static var purple: UIColor {
        return UIColor.color(hex: 0x6467EF)
    }
    
    public static var brushColors: [UIColor] {
        return [Palette.white,
                Palette.black,
                Palette.red,
                Palette.yellow,
                Palette.green,
                Palette.blue,
                Palette.purple]
    }
    
    public static var textColors: [EditorTextColor] {
        return [.init(color: Palette.white,  subColor: Palette.black, shadow: Shadow(color: .black, alpha: 0.25, x: 0, y: 1, blur: 0.5, spread: 0)),
                .init(color: Palette.black,  subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8)),
                .init(color: Palette.red,    subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8)),
                .init(color: Palette.yellow, subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8)),
                .init(color: Palette.green,  subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8)),
                .init(color: Palette.blue,   subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8)),
                .init(color: Palette.purple, subColor: UIColor.white, shadow: Shadow(color: .black, alpha: 0.25, x: 5, y: 5, blur: 0.5, spread: 8))]
    }
}
