//
//  CropData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

struct CropData: Codable, Equatable {
    
    var cropOptionIdx: Int = 0
    var didCrop: Bool = false
    var rect: CGRect = .zero
    var zoomScale: CGFloat = 1.0
    var contentSize: CGSize = .zero
    var contentOffset: CGPoint = .zero
    var imageViewFrame: CGRect = .zero
    var rotateState: RotateState = .portrait
    
    /// 图片已经裁剪或者旋转
    var didCropOrRotate: Bool {
        return didCrop || rotateState != .portrait
    }
}
