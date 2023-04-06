//
//  CaptureRecordView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit

final class CaptureRecordView: DDPicBaseView {
    
    private var color: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.addSublayer(self.buttonLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.buttonLayer.frame = bounds
        self.setStyle(animated: false)
    }
    
    private lazy var buttonLayer = CAShapeLayer()
}

// MARK: - Animation
extension CaptureRecordView {
    
    public func setStyle(animated: Bool) {
        
        let duration = animated ? 0.25 : 0
        let width: CGFloat = 54
        let cornerRadius: CGFloat = width / 2
        let color = self.color.cgColor
        let rect = CGRect(origin: CGPoint(x: (bounds.width - width) / 2, y: (bounds.height - width) / 2), size: CGSize(width: width, height: width))
        let newPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.fromValue = buttonLayer.path
        animation.toValue = newPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.buttonLayer.add(animation, forKey: "animation")
        self.buttonLayer.fillColor = color
        self.buttonLayer.path = newPath.cgPath
    }
}
