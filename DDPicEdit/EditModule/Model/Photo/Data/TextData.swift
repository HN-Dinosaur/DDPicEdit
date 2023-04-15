//
//  TextData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

final class TextData: Codable {
    
    var frame: CGRect = .zero
    var finalFrame: CGRect = .zero
    
    var text: String = ""
    var colorIdx: Int = 0
    var isTextSelected: Bool = true
    var imageData: Data = Data()
    
    var point: CGPoint = .zero
    var scale: CGFloat = 1.0
    var rotation: CGFloat = 0.0
    
    var pointBeforePan: CGPoint = .zero
}

extension TextData {
    
    var image: UIImage {
        return UIImage(data: imageData, scale: UIScreen.main.scale) ?? UIImage()
    }
}

extension TextData: Equatable {
    
    static func == (lhs: TextData, rhs: TextData) -> Bool {
        return lhs.frame == rhs.frame
            && lhs.text == rhs.text
            && lhs.colorIdx == rhs.colorIdx
            && lhs.point == rhs.point
            && lhs.scale == rhs.scale
            && lhs.rotation == rhs.rotation
    }
}
