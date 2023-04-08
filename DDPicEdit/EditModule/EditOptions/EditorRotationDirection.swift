//
//  EditorRotationDirection.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/8.
//

import Foundation

public enum EditorRotationDirection: Equatable {
    
    case turnOff
    
    case turnLeft
    
    case turnRight
}

extension EditorRotationDirection {
    
    var iconKey: EditorTheme.IconConfigKey {
        switch self {
        case .turnOff:
            return .photoToolCropTrunLeft
        case .turnLeft:
            return .photoToolCropTrunLeft
        case .turnRight:
            return .photoToolCropTrunRight
        }
    }
}
