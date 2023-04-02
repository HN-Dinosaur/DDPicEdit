//
//  Permission+micphone.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import AVFoundation

extension Permission {
    
    func checkMicrophone() -> Permission.Status {
        return AVAudioSession.sharedInstance().recordPermission.accessLevel
    }
    
    func requestMicrophoneAccess(completion: @escaping PermissionCompletion) {
        guard Bundle.main.object(forInfoDictionaryKey: ._microphoneUsageDescription) != nil else {
            _print("WARNING: \(String._microphoneUsageDescription) not found in Info.plist")
            return
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { result in
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

extension AVAudioSession.RecordPermission {
    
    var accessLevel: Permission.Status {
        switch self {
        case .granted:
            return .authorized
        case .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
    
}

fileprivate extension String {
    
    static let _microphoneUsageDescription: String = "NSMicrophoneUsageDescription"
}
