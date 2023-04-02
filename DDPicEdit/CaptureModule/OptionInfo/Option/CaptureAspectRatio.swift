//
//  CaptureAspectRatio.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import UIKit

public enum CaptureAspectRatio: Equatable {
    
    case ratio1x1
    case ratio4x3
    case ratio16x9
    
    var value: Double {
        switch self {
        case .ratio1x1:
            return 1.0 / 1.0
        case .ratio4x3:
            return 3.0 / 4.0
        case .ratio16x9:
            return 9.0 / 16.0
        }
    }
    
    var cropValue: CGFloat {
        switch self {
        case .ratio1x1:
            return 9.0 / 16.0
        case .ratio4x3:
            return 3.0 / 4.0
        case .ratio16x9:
            return 1.0 / 1.0
        }
    }
}
