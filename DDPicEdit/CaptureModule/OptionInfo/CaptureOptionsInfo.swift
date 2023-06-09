//
//  CaptureOptionsInfo.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/29.
//

import UIKit

public struct CaptureOptionsInfo {

    public var theme: CaptureTheme = .init()
    // default is photo, conform OptionSet protocol
    public var mediaOptions: CaptionMediaOption = [.photo]
    // default is 4x3
    public var photoAspectRatio: CaptureAspectRatio = .ratio4x3
    // default is back and front, comform RawRepresentable and Equatable protocol
    public var preferredPositions: [CapturePosition] = [.back, .front]
    // defalut is off, comform RawRepresentable and Equatable protocol
    public var flashMode: CaptureFlashMode = .off
    // default is enableHighResolution: false, enableHighFrameRate: true
    public var preferredPresets: [CapturePreset] = CapturePreset.createPresets(enableHighResolution: false, enableHighFrameRate: true)
    // default is false, Enable debug log
    public var enableDebugLog: Bool = false
    /// Editor photo options info, used for editor after take photo.
    /// - Note: Invalid on iPad.
    public var editorPhotoOptions: EditorPhotoOptionsInfo = .init()
}
