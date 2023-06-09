//
//  DryDrawingView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/17.
//

import UIKit

class DryDrawingView: DDPicBaseView {
    
    private var bezierPath: UIBezierPath = UIBezierPath()
    private var step = 0
    private var points: [CGPoint] = []
    private var didCallBegin = false
    
    internal var originBounds: CGRect = .zero
    internal var scale: CGFloat {
        return self.originBounds.width / self.bounds.width
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.originBounds == .zero && bounds != .zero {
            self.originBounds = bounds
        }
    }
    
    // MARK: - Override
    func willBeginDraw(path: UIBezierPath) { }
    func panning(path: UIBezierPath) { }
    func didFinishDraw(path: UIBezierPath) { }
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.preciseLocation(in: self)
        self.bezierPath = UIBezierPath()
        self.step = 0
        self.didCallBegin = false
        self.points.removeAll()
        self.points.append(touchPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.step > 3 && !self.didCallBegin {
            didCallBegin = true
            willBeginDraw(path: bezierPath)
        }
        draw(touches, finish: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        draw(touches, finish: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        draw(touches, finish: true)
    }
}

// MARK: - Private
extension DryDrawingView {
    
    private func draw(_ touches: Set<UITouch>, finish: Bool) {
        defer {
            if finish {
                if self.step >= 3 {
                    self.didFinishDraw(path: self.bezierPath)
                }
                self.step = 0
                self.points.removeAll()
            } else {
                self.panning(path: bezierPath)
            }
        }
        
        guard let touch = touches.first else { return }
        let touchPoint = touch.preciseLocation(in: self)
        let pathPoints = self.pushPoints(touchPoint)
        if pathPoints.count >= 3 {
            self.bezierPath.move(to: pathPoints.first!)
            for i in 1..<pathPoints.count {
                bezierPath.addLine(to: pathPoints[i])
            }
        }
    }
    
    private func pushPoints(_ point: CGPoint) -> [CGPoint] {
        if point == points.last {
            return []
        }
        points.append(point)
        if points.count < 3 {
            return []
        }
        step += 1
        return genericPathPoints()
    }
    
    private func genericPathPoints() -> [CGPoint] {
        var begin: CGPoint
        var control: CGPoint
        let end = CGPoint.middle(p1: points[step], p2: points[step + 1])

        var vertices: [CGPoint] = []
        if step == 1 {
            begin = points[0]
            let middle1 = CGPoint.middle(p1: points[0], p2: points[1])
            control = CGPoint.middle(p1: middle1, p2: points[1])
        } else {
            begin = CGPoint.middle(p1: points[step - 1], p2: points[step])
            control = points[step]
        }
        
        /// segements are based on distance about start and end point
        let dis = begin.distance(to: end)
        let segements = max(Int(dis / 5), 2)

        for i in 0 ..< segements {
            let t = CGFloat(i) / CGFloat(segements)
            let x = pow(1 - t, 2) * begin.x + 2.0 * (1 - t) * t * control.x + t * t * end.x
            let y = pow(1 - t, 2) * begin.y + 2.0 * (1 - t) * t * control.y + t * t * end.y
            vertices.append(CGPoint(x: x, y: y))
        }
        vertices.append(end)
        return vertices
    }
}
