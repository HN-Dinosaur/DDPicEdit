//
//  CropLayerView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/16.
//

import UIKit

final class CropLayerView: DDPicBaseView {

    var path: CGPath? {
        get {
            return self.cropLayer.path
        } set {
            self.cropLayer.path = newValue
        }
    }
    var displayRect: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(self.cropLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cropLayer.frame = bounds
    }
    
    /// 用于裁剪后把其他区域以黑色layer盖住
    private(set) lazy var cropLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.fillRule = .evenOdd
        layer.fillColor = UIColor.black.cgColor
        return layer
    }()
}
