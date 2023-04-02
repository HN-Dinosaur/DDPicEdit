//
//  Permission+Photos.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import Photos

extension Permission {
    
    func checkPhotos() -> Permission.Status {
        if #available(iOS 14.0, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite).accessLevel
        } else {
            return PHPhotoLibrary.authorizationStatus().accessLevel
        }
    }
    
    func requestPhotosAccess(completion: @escaping PermissionCompletion) {
        guard Bundle.main.object(forInfoDictionaryKey: ._photoLibraryUsageDescription) != nil else {
            _print("WARNING: \(String._photoLibraryUsageDescription) not found in Info.plist")
            return
        }
        
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                Thread.runOnMain {
                    completion(status.accessLevel)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                Thread.runOnMain {
                    completion(status.accessLevel)
                }
            }
        }
    }
}

extension PHAuthorizationStatus {
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
    
    static let _photoLibraryUsageDescription: String = "NSPhotoLibraryUsageDescription"
    
}
