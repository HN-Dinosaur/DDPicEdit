//
//  CaptureFlashMode.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import UIKit
import AVFoundation

public enum CaptureFlashMode: RawRepresentable, Equatable {
    
    case auto
    case off
    case on
    
    public init?(rawValue: AVCaptureDevice.FlashMode) {
        switch rawValue {
        case .auto:
            self = .auto
        case .off:
            self = .off
        case .on:
            self = .on
        default:
            self = .off
        }
    }
    
    public var rawValue: AVCaptureDevice.FlashMode {
        switch self {
        case .auto:
            return .auto
        case .off:
            return .off
        case .on:
            return .on
        }
    }
    
    public var cameraFlashMode: UIImagePickerController.CameraFlashMode {
        switch self {
        case .auto:
            return .auto
        case .off:
            return .off
        case .on:
            return .on
        }
    }
    
}
