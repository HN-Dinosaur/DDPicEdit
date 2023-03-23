//
//  Extension+UIFont.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/20.
//

import UIKit

extension UIFont {

    static func PingFang(size: CGFloat) -> UIFont {
        return .init(name: "PingFangSC-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func PingFangMedium(size: CGFloat) -> UIFont {
        return .init(name: "PingFangSC-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    static func PingFangSemibold(size: CGFloat) -> UIFont {
        return .init(name: "PingFangSC-Semibold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }

}
