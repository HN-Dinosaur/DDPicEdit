//
//  EditorCropOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/7.
//

import UIKit

public enum EditorCropOption: Equatable {
    
    case free
    
    /// Limit crop size, limit the cropping width and height ratio. Eg. w:3 h:4
    case custom(w: UInt, h: UInt)
}

extension EditorCropOption: CaseIterable {
    public static var allCases: [EditorCropOption] {
        return [.free, .custom(w: 1, h: 1), .custom(w: 3, h: 4), .custom(w: 4, h: 3), .custom(w: 9, h: 16), .custom(w: 16, h: 9)]
    }
}

extension EditorCropOption {
    
    var ratioOfWidth: CGFloat {
        switch self {
        case .free:
            return 1
        case .custom(let w, let h):
            return CGFloat(w)/CGFloat(h)
        }
    }
    
    var ratioOfHeight: CGFloat {
        switch self {
        case .free:
            return 1
        case .custom(let w, let h):
            return CGFloat(h)/CGFloat(w)
        }
    }
}

