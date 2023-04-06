//
//  CaptureCircleView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import UIKit

final class CaptureCircleView: DDPicBaseView {
    
    enum Style {
        case small
        case large
    }
    
    private var color: UIColor = .white
    private var style: Style = .small
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        let start: CGFloat = -.pi / 2
        let end: CGFloat = .pi / 2 * 3
        let radius: CGFloat
        let lineWidth: CGFloat
        switch style {
        case .small:
            radius = 28 + 2 + 2
            lineWidth = 2 * 2
        case .large:
            radius = 28 + 2 + 6
            lineWidth = 6 * 2
        }
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        context.setLineWidth(lineWidth)
        color.setStroke()
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
    func setStyle(_ style: Style, animated: Bool) {
        self.style = style
        let duration = animated ? 0.25 : 0
        let timingParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingParameters)
        animator.addAnimations {
            self.setNeedsDisplay()
        }
        animator.startAnimation()
    }
}
