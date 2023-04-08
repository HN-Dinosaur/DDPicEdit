//
//  EditorMosaicOption.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/8.
//

import UIKit

public enum EditorMosaicOption: Equatable, Hashable {
    
    /// Blurring the original image.
    case `default`
    
    /// icon: Image on mosaic tool bar, it will use mosaic image as icon image if icon image is nil.
    case custom(icon: UIImage?, mosaic: UIImage)
    
    public static var colorful: EditorMosaicOption {
        return .custom(icon: nil, mosaic: UIImage(named: "CustomMosaic")!)
    }
}

extension EditorMosaicOption: CaseIterable {
    
    public static var allCases: [EditorMosaicOption] {
        return [.default, .colorful]
    }
}
