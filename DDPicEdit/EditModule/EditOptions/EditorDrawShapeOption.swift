//
//  EditorDrawShapeOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/7.
//

import Foundation

public enum EditorDrawShapeOption: Int, Equatable, Hashable, CaseIterable, Codable {
    
    case rectangle = 0
    case circle
    case oval
    case arrow
    
    var iconKey: EditorTheme.IconConfigKey {
        switch self {
        case .rectangle:
            return .photoToolDrawShapeRectangle
        case .circle:
            return .photoToolDrawShapeCircle
        case .oval:
            return .photoToolDrawShapeOval
        case .arrow:
            return .photoToolDrawShapeArrow
        }
    }

}
