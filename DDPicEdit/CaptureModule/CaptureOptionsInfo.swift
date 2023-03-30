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
    public var mediaOption: CaptionMediaOption = [.photo]
    // default is 4x3
    public var photoAspectRatio: CaptureAspectRatio = .ratio4x3
    // default is back and front, comform RawRepresentable and Equatable protocol
    public var preferredPositions: [CapturePosition] = [.back, .front]
    // defalut is off, comform RawRepresentable and Equatable protocol
    public var flashMode: CaptureFlashMode = .off
    // default is enableHighResolution: false, enableHighFrameRate: true
    public var preferredPresets: [CapturePreset] = CapturePreset.createPresets(enableHighResolution: false, enableHighFrameRate: true)
    /// Editor photo options info, used for editor after take photo.
    /// 后续完成编辑模块
    
}
