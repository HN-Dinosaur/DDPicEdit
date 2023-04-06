//
//  FileType.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import Foundation
import MobileCoreServices

enum FileType: Equatable {
    
    case jpeg
    case png
    case mp4
    
    var fileExtension: String {
        switch self {
        case .jpeg:
            return ".jpeg"
        case .png:
            return ".png"
        case .mp4:
            return ".mp4"
        }
    }
    
    var utType: CFString {
        switch self {
        case .jpeg:
            return kUTTypeJPEG
        case .png:
            return kUTTypePNG
        case .mp4:
            return kUTTypeMPEG4
        }
    }
}
