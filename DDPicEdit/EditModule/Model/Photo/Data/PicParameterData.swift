//
//  PicParameterData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/4.
//

import Foundation

public struct PicParameterData: Equatable, Codable {
//    // 曝光
//    var sensitometry: CGFloat = 0
//    // 鲜明度
//    var boldness: CGFloat = 0
//    // 高光
//    var highlight: CGFloat = 0
//    // 阴影
//    var shadow: CGFloat = 0
    /// 对比度
    /// default is 1, score is 0 ~ 4
    var contrast: CGFloat = 1
    /// 亮度
    /// default is 0, score is -1 ~ 1
    var brightness: CGFloat = 0
//    // 黑点
//    var darkness: CGFloat = 0
    /// 饱和度
    /// default is 1, score is 0 ~ 2
    var saturation: CGFloat = 1
//    // 自然饱和度
//    var naturalSaturation: CGFloat = 0
//    // 色温
//    var colorTemperature: CGFloat = 0
//    // 色调
//    var tonality: CGFloat = 0
//    // 锐度
//    var acutance: CGFloat = 0
//    // 清晰度
//    var definition: CGFloat = 0
//    // 噪点消除
//    var noiseElimination: CGFloat = 0
//    // 晕影
//    var halation: CGFloat = 0
    
    public static func == (lhs: PicParameterData, rhs: PicParameterData) -> Bool {
        return lhs.contrast == rhs.contrast
            && lhs.brightness == rhs.brightness
            && lhs.saturation == rhs.saturation
    }
}
