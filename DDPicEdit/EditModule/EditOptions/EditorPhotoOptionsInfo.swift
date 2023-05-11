//
//  EditorPhotoOptionsInfo.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import UIKit

public struct EditorPhotoOptionsInfo {
    
    /// Theme
    public var theme: EditorTheme = .init()
    
    // default is all, included brush, text, crop, mosaic
    public var toolOptions: [EditorPhotoToolOption] = EditorPhotoToolOption.allCases
    
    // default: [white, black, red, yellow, green, blue, purple]
    public var brushColors: [EditorBrushColorOption] = EditorBrushColorOption.allCases
    
    // default: 2
    public var defaultBrushIndex: Int = 2
    
    // default: 5.0
    public var brushWidth: CGFloat = 5.0
    
    // - Default: [default, colorful]
    public var mosaicOptions: [EditorMosaicOption] = EditorMosaicOption.allCases
    
    // default: 2
    public var defaultMosaicIndex: Int = 0
    
    // default: 15.0
    public var mosaicWidth: CGFloat = 15.0
    
    // default: 30, Mosaic blur level, only for default mosaic style.
    public var mosaicLevel: Int = 30
    
    // default: [white, black, red, yellow, green, blue, purple]
    public var textColors: [EditorTextColor] = Palette.textColors
    
    // default: Font is PingFangSemibold, the size is 32
    public var textFont = UIFont.PingFangSemibold(size: 32)
    
    /// Style of input text at the first time.
    ///
    /// false: No background color, and the text color is main color.
    ///
    /// true: The background color is main color, and the text color is sub color.
    ///
    // default: false
    public var isTextSelected: Bool = false
    
    /// Calculate text last line mask width when input text.
    ///
    /// false: The last line mask width equal to text view width.
    ///
    /// true: The last line mask width equal to text length.
    ///
    /// - Default: true
    public var calculateTextLastLineMask: Bool = true
    
    // default: [free, 1:1, 3:4, 4:3, 9:16, 16:9]
    public var cropOptions: [EditorCropOption] = EditorCropOption.allCases
    
    // default: turnLeft
    public var rotationDirection: EditorRotationDirection = .turnLeft
    
    /// Setting the cache identifier will cache the edit records.
    /// The next time you open the editor, it will load the edit records and restore it.
    ///
    /// If you try to edit a photo from the ImagePicker, you will see that the last edited content can be undo, which means that the editor has restored the last edit records.
    ///
    /// Use `ImageEditorCache` to remove cache.
    ///
    /// - Note: The '/' character is not allowed in the cache identifier.
    ///
    /// - Default: "" that means DO NOT cache the edit records.
    public var cacheIdentifier: String = ""
    
    // default is false, Enable debug log
    public var enableDebugLog: Bool = false
    
    // default is none, waterMarkContent
    public var waterMarkContent = "@Londy"
    
    // default is none, without any watermark in pic
    public var defaultWaterMarkSelect: WaterMarkLocation = .none
    
    // default is Pingfang 70
    public var waterMarkContentFont = UIFont.PingFang(size: 70)
    
    // default is all
    public var picParameterChangeOption: [EditorPicParameterOption] = EditorPicParameterOption.allCases
    // default is all, incluing arrow, circle, rectangle
    public var drawShapeOptions: [EditorDrawShapeOption] = EditorDrawShapeOption.allCases
    
    // default shape select is 0
    public var defaultShapeIndex: Int = 0
    
}

