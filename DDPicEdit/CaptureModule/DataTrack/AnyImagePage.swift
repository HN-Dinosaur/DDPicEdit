//
//  AnyImagePage.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public struct AnyImagePage: Equatable, RawRepresentable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AnyImagePage: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension AnyImagePage {
    
    public static let undefined: AnyImagePage = "DDPIC_PAGE_CORE_UNDEFINED"
    public static let capture: AnyImagePage = "DDPIC_PAGE_CAPTURE_PHOTO"
    public static let editor: AnyImagePage = "DDPIC_PAGE_EDITOR_PHOTO"
}
