//
//  CropCornerView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

final class CropCornerView: DDPicBaseView {
    
    private let color: UIColor
    internal let position: CropCornerPosition
    
    init(frame: CGRect, color: UIColor, position: CropCornerPosition) {
        self.color = color
        self.position = position
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        let path = UIBezierPath()
        let lineWidth: CGFloat = 3.0
        switch position {
        case .topLeft:
            let centerP = CGPoint(x: center.x - lineWidth * 0.3, y: center.y - lineWidth * 0.3)
            path.move(to: CGPoint(x: centerP.x - lineWidth * 0.5, y: centerP.y))
            path.addLine(to: CGPoint(x: bounds.width, y: centerP.y))
            path.move(to: centerP)
            path.addLine(to: CGPoint(x: centerP.x, y: bounds.height))
        case .topRight:
            let centerP = CGPoint(x: center.x + lineWidth * 0.3, y: center.y - lineWidth * 0.3)
            path.move(to: CGPoint(x: centerP.x + lineWidth * 0.5, y: centerP.y))
            path.addLine(to: CGPoint(x: 0, y: centerP.y))
            path.move(to: centerP)
            path.addLine(to: CGPoint(x: centerP.x, y: bounds.height))
        case .bottomLeft:
            let centerP = CGPoint(x: center.x - lineWidth * 0.3, y: center.y + lineWidth * 0.3)
            path.move(to: CGPoint(x: centerP.x - lineWidth * 0.5, y: centerP.y))
            path.addLine(to: CGPoint(x: bounds.width, y: centerP.y))
            path.move(to: centerP)
            path.addLine(to: CGPoint(x: centerP.x, y: 0))
        case .bottomRight:
            let centerP = CGPoint(x: center.x + lineWidth * 0.3, y: center.y + lineWidth * 0.3)
            path.move(to: CGPoint(x: centerP.x + lineWidth * 0.5, y: centerP.y))
            path.addLine(to: CGPoint(x: 0, y: centerP.y))
            path.move(to: centerP)
            path.addLine(to: CGPoint(x: centerP.x, y: 0))
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
    
}

enum CropCornerPosition: Int {
    case topLeft = 1
    case topRight
    case bottomLeft
    case bottomRight
}
