//
//  CaptureTheme.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/29.
//

import UIKit

public final class CaptureTheme: ThemeConfigurable {
    
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

extension CaptureTheme {
    
    public enum ColorConfigKey: Hashable {
        
        case primary
        
        case focus
        
        func defaultValue() -> UIColor {
            switch self {
            case .primary:
                return UIColor.color(hex: 0x57BE6A)
            case .focus:
                return UIColor.color(hex: 0xFFD60A)
            }
        }

    }

}

extension CaptureTheme {
    
    public enum IconConfigKey: String, Hashable {
        
        /// 48*48
        case cameraSwitch = "CameraSwitch"
        /// 27*27
        case captureSunlight = "CaptureSunlight"
        
        func defaultValue() -> UIImage {
            UIImage(named: rawValue)!
        }
    }
    
}
