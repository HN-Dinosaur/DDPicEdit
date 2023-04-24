//
//  EditorPhotoToolOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import Foundation

public enum EditorPhotoToolOption: Equatable, CaseIterable {
    case brush
    case text
    case crop
    case mosaic
    case waterMark
}

extension EditorPhotoToolOption {
    
    var iconKey: EditorTheme.IconConfigKey {
        switch self {
        case .brush:
            return .photoToolBrush
        case .text:
            return .photoToolText
        case .crop:
            return .photoToolCrop
        case .mosaic:
            return .photoToolMosaic
        case .waterMark:
            return .photoToolWaterMark
        }
    }
}

extension EditorPhotoToolOption: CustomStringConvertible {
    public var description: String {
        switch self {
        case .brush:
            return "BRUSH"
        case .text:
            return "INPUT_TEXT"
        case .crop:
            return "CROP"
        case .mosaic:
            return "MOSAIC"
        case .waterMark:
            return "WATERMARK"
        }
    }
    
    public var stringKey: StringConfigKey {
        switch self {
        case .brush:
            return .editorBrush
        case .text:
            return .editorInputText
        case .crop:
            return .editorCrop
        case .mosaic:
            return .editorMosaic
        case .waterMark:
            return .editorWaterMark
        }
    }
}

extension StringConfigKey {
    
    public static let editorBrush = StringConfigKey(rawValue: "BRUSH")
    public static let editorCrop = StringConfigKey(rawValue: "CROP")
    public static let editorMosaic = StringConfigKey(rawValue: "MOSAIC")
    public static let editorWaterMark = StringConfigKey(rawValue: "WATERMARK")
    public static let editorInputText = StringConfigKey(rawValue: "INPUT_TEXT")
    public static let editorFree = StringConfigKey(rawValue: "FREE")
    
    public static let editorDragHereToRemove = StringConfigKey(rawValue: "DRAG_HERE_TO_REMOVE")
    public static let editorReleaseToRemove = StringConfigKey(rawValue: "RELEASE_TO_REMOVE")
}
