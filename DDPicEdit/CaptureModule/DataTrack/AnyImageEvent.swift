//
//  AnyImageEvent.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import Foundation

public struct AnyImageEvent: Equatable, RawRepresentable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AnyImageEvent: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension AnyImageEvent {
    
    public static let capturePhoto: AnyImageEvent = "ANYIMAGEKIT_EVENT_CAPTURE_PHOTO"
    public static let captureVideo: AnyImageEvent = "ANYIMAGEKIT_EVENT_CAPTURE_VIDEO"
    public static let captureCancel: AnyImageEvent = "ANYIMAGEKIT_EVENT_CAPTURE_CANCEL"
    public static let captureSwitchCamera: AnyImageEvent = "ANYIMAGEKIT_EVENT_CAPTURE_SWITCH_CAMERA"
    
}
