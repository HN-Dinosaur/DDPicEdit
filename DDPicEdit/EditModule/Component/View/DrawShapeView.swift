//
//  DrawShapeView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/9.
//

import UIKit

class DrawShapeView: DDPicBaseView {

    var model: DrawShapeData
    
    var kvoToken: NSKeyValueObservation?

    init(model: DrawShapeData) {
        self.model = model
        super.init(frame: model.frame)
        kvoToken = model.observe(\.endPoint, options: .new) { (model, change) in
            self.frame = self.model.frame
            self.update()
        }
        self.isUserInteractionEnabled = false
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }

    private func update() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.path = model.path.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = model.style == .arrow ? UIColor.red.cgColor : UIColor.clear.cgColor
        layer.lineWidth = model.lineWidth
    }
    
    deinit {
        kvoToken?.invalidate()
    }
}
