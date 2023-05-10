//
//  EditorTheme.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import UIKit

public final class EditorTheme: ThemeConfigurable {
    
    private var colors: [ColorConfigKey: UIColor] = [:]
    
    private var icons: [IconConfigKey: UIImage] = [:]
    
    private var strings: [StringConfigKey: String] = [:]
    
    public subscript(color key: ColorConfigKey) -> UIColor {
        get { colors[key] ?? key.defaultValue() }
        set { colors[key] = newValue }
    }
    
    public subscript(icon key: IconConfigKey) -> UIImage? {
        get { icons[key] ?? key.defaultValue() }
        set { icons[key] = newValue }
    }
    
    public subscript(string key: StringConfigKey) -> String {
        get { strings[key] ?? key.rawValue }
        set { strings[key] = newValue }
    }
}

// MARK: - Colors
extension EditorTheme {
    
    public enum ColorConfigKey: Hashable {
        
        /// Main Color
        case primary
        
        func defaultValue() -> UIColor {
            switch self {
            case .primary:
                return Palette.primary
            }
        }
    }
}

// MARK: - Icon
extension EditorTheme {
    
    public enum IconConfigKey: String, Hashable {
        
        /// 25*25
        case checkMark = "CheckMark"
        /// 25*25
        case xMark = "XMark"
        /// 30*30
        case returnBackButton = "ReturnBackButton"
        
        /// 25*25
        case photoToolBrush = "PhotoToolBrush"
        /// 25*25
        case photoToolText = "PhotoToolText"
        /// 25*25
        case photoToolCrop = "PhotoToolCrop"
        /// 25*25
        case photoToolMosaic = "PhotoToolMosaic"
        /// 水印
        case photoToolWaterMark = "drop"
        /// pic参数
        case photoToolPicParameter = "circlebadge.2"
        /// paster
        case photoToolPaster = "photo.on.rectangle.angled"
        /// painter shape
        case photoToolDrawShape = "pencil.and.outline"
        
        /// 25*25
        case photoToolUndo = "PhotoToolUndo"
        /// 25*25
        case photoToolCropTrunLeft = "PhotoToolCropTrunLeft"
        /// 25*25
        case photoToolCropTrunRight = "PhotoToolCropTrunRight"
        /// 25*25
        case photoToolMosaicDefault = "PhotoToolMosaicDefault"
        
        case photoToolDrawShapeRectangle = "rectangle"
        
        case photoToolDrawShapeCircle = "circle"

        case photoToolDrawShapeOval = "oval"
        
        case photoToolDrawShapeArrow = "line.diagonal.arrow"
        
        /// 25*25
        case textNormalIcon = "TextNormalIcon"
        /// 25*25
        case trash = "Trash"
        
        /// 20*50
        case videoCropLeft = "VideoCropLeft"
        /// 20*50
        case videoCropRight = "VideoCropRight"
        /// 30*30
        case videoPauseFill = "VideoPauseFill"
        /// 30*30
        case videoPlayFill = "VideoPlayFill"
        /// 30*30
        case videoToolVideo = "VideoToolVideo"
        
        func defaultValue() -> UIImage? {
            return UIImage(named: rawValue) ?? getSFSymbolPic(named: rawValue)
        }
        
        func getSFSymbolPic(named: String) -> UIImage? {
            if #available(iOS 13.0, *) {
                let config = UIImage.SymbolConfiguration(weight: .regular)
                let img =  UIImage(systemName: named, withConfiguration: config)
                return img
            }
            return nil
        }
    }
}
