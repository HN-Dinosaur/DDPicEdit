//
//  AxialGradientView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/11.
//

import UIKit

public enum GradientAnchor: Int {
    case left
    case right
    case top
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
}

public class AxialGradientView: DDPicBaseView {
    
    public override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public override var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    public init(startAnchor: GradientAnchor, endAnchor: GradientAnchor, startColor: UIColor, endColor: UIColor) {
        super.init(frame: .zero)
        self.set(startAnchor: startAnchor, endAnchor: endAnchor, startColor: startColor, endColor: endColor)
    }
    
    public func set(startAnchor: GradientAnchor, endAnchor: GradientAnchor, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = self.layer

        let anchorToCGPoint: [GradientAnchor: CGPoint] = [.left: CGPoint(x: 0, y: 0.5),
                                                          .right: CGPoint(x: 1, y: 0.5),
                                                          .top: CGPoint(x: 0.5, y: 0),
                                                          .bottom: CGPoint(x: 0.5, y: 1),
                                                          .topLeft: CGPoint(x: 0, y: 0),
                                                          .topRight: CGPoint(x: 1, y: 0),
                                                          .bottomLeft: CGPoint(x: 0, y: 1),
                                                          .bottomRight: CGPoint(x: 1, y: 1),
                                                          .center: CGPoint(x: 0.5, y: 0.5)]

        gradientLayer.colors = [startColor.cgColor,
                                endColor.cgColor]
        gradientLayer.startPoint = anchorToCGPoint[startAnchor]!
        gradientLayer.endPoint = anchorToCGPoint[endAnchor]!
    }
    
}
