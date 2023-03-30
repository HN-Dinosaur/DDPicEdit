//
//  CaptionMediaOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public struct CaptionMediaOption: OptionSet {
    
    public static let photo = CaptionMediaOption(rawValue: 1 << 0)
    /// 暂时不支持，没完成
    public static let video = CaptionMediaOption(rawValue: 1 << 1)
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension CaptionMediaOption {
    
    var localizedTipsKey: StringConfigKey {
        return .captureTapForPhoto
    }
    
}
