//
//  EditorPicParameterOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/4.
//

import UIKit

public enum EditorPicParameterOption: Int, Equatable, CaseIterable {
//    // 曝光
//    case sensitometry = "曝光"
//    // 鲜明度
//    case boldness = "鲜明度"
//    // 高光
//    case highlight = "高光"
//    // 阴影
//    case shadow = "阴影"
    // 对比度
    case contrast = 0
    // 亮度
    case brightness
//    // 黑点
//    case darkness = "黑点"
    // 饱和度
    case saturation
//    // 自然饱和度
//    case naturalSaturation = "自然饱和度"
//    // 色温
//    case colorTemperature = "色温"
//    // 色调
//    case tonality = "色调"
//    // 锐度
//    case acutance = "锐度"
//    // 清晰度
//    case definition = "清晰度"
//    // 噪点消除
//    case noiseElimination = "噪点消除"
//    // 晕影
//    case halation = "晕影"
    
    var limit: Int {
        switch self {
        case .contrast:
            return 100
        case .brightness:
            return 100
        case .saturation:
            return 100
        }
    }
    
    var icon: CGImage? {
        switch self {
        case .contrast:
            return nil
        case .brightness:
            return nil
        case .saturation:
            return nil
        }
    }
    
    var str: String {
        switch self {
        case .contrast:
            return "对比度"
        case .brightness:
            return "亮度"
        case .saturation:
            return "饱和度"
        }
    }
}
