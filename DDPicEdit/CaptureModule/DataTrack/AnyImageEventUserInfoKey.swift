//
//  AnyImageEventUserInfoKey.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public struct AnyImageEventUserInfoKey: Hashable, RawRepresentable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AnyImageEventUserInfoKey: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension AnyImageEventUserInfoKey {
    
    /// Value: Bool
    public static let isOn: AnyImageEventUserInfoKey = "DDPICEDIT_USERINFO_IS_ON"
    
    /// Value: AnyImagePage
    public static let page: AnyImageEventUserInfoKey = "DDPICEDIT_USERINFO_PAGE"
}
