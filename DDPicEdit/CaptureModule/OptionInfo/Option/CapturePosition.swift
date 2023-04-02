//
//  CapturePosition.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import AVFoundation

public enum CapturePosition: RawRepresentable, Equatable {

    case front
    case back

    public init?(rawValue: AVCaptureDevice.Position) {
        switch rawValue {
        case .front:
            self = .front
        case .back:
            self = .back
        default:
            self = .back
        }
    }
    
    public var rawValue: AVCaptureDevice.Position {
        switch self {
        case .front:
            return .front
        case .back:
            return .back
        }
    }
    
    public mutating func toggle() {
        switch self {
        case .back:
            self = .front
        case .front:
            self = .back
        }
    }
    
    public var localizedTipsKey: StringConfigKey {
        switch self {
        case .front:
            return .captureSwitchToFrontCamera
        case .back:
            return .captureSwitchToBackCamera
        }
    }
    
    
    
    
}
