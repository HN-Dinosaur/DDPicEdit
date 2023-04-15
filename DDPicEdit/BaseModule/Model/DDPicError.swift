//
//  DDPicError.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/11.
//

import Foundation

public enum AnyImageError: Error {
    
    case invalidMediaType
    case invalidInfo
    case invalidURL
    case invalidData
    case invalidDataUTI
    case invalidImage
    case invalidVideo
    case invalidLivePhoto
    case invalidExportPreset
    case invalidExportSession
    case unsupportedFileType
    case fileWriteFailed
    case exportFailed
    case exportCanceled
    
    case cannotFindInLocal
    
    case savePhotoFailed
    case saveVideoFailed
}
