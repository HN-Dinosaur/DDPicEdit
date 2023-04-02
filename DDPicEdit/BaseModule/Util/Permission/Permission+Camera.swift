//
//  Permission+Camera.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import AVFoundation

extension Permission {
    
    func checkCamera() -> Permission.Status {
        return AVCaptureDevice.authorizationStatus(for: .video).accessLevel
    }
    
    func requestCameraAccess(completion: @escaping PermissionCompletion) {
        guard Bundle.main.object(forInfoDictionaryKey: ._cameraUsageDescription) != nil else {
            _print("WARNING: \(String._cameraUsageDescription) not found in Info.plist")
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { result in
            Thread.runOnMain {
                if result {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        }
    }
    
}

extension AVAuthorizationStatus {
    var accessLevel: Permission.Status {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }
}

fileprivate extension String {
    
    static let _cameraUsageDescription: String = "NSCameraUsageDescription"
    
}
