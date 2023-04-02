//
//  Permission.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import Foundation

typealias PermissionCompletion = (Permission.Status) -> Void
typealias PermissCancelBlock = (Permission) -> Void

enum Permission {
    case photo
    case camera
    case micphone
    
    var status: Status {
        switch self {
        case .photo:
            return self.checkPhotos()
        case .camera:
            return self.checkCamera()
        case .micphone:
            return self.checkMicrophone()
        }
    }
    
    var localizedTitleKey: StringConfigKey {
        switch self {
        case .photo:
            return .photo
        case .camera:
            return .camera
        case .micphone:
            return .microphone
        }
    }
    
    var localizedAlertMessageKey: StringConfigKey {
        switch self {
        case .photo:
            return .noPhotosPermissionTips
        case .camera:
            return .noCameraPermissionTips
        case .micphone:
            return .noMicrophonePermissionTips
        }
    }
    
    func requestAccess(completion: @escaping PermissionCompletion) {
        switch self {
        case .photo:
            self.requestPhotosAccess(completion: completion)
        case .camera:
            self.requestCameraAccess(completion: completion)
        case .micphone:
            self.requestMicrophoneAccess(completion: completion)
        }
    }
}

extension Permission {
    enum Status {
        case notDetermined
        case denied
        case authorized
        case limited
    }
}
