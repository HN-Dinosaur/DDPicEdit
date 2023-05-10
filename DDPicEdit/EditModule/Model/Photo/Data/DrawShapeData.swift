//
//  DrawShapeData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/9.
//

import UIKit

class DrawShapeData: NSObject, Codable {

    let style: EditorDrawShapeOption
    var lineWidth: CGFloat
    var startPoint: CGPoint
    @objc dynamic var endPoint: CGPoint

    init(style: EditorDrawShapeOption, lineWidth: CGFloat = 4, startPoint: CGPoint, endPoint: CGPoint) {
        self.style = style
        self.lineWidth = lineWidth
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    static func == (lhs: DrawShapeData, rhs: DrawShapeData) -> Bool {
        lhs.style == rhs.style &&
        lhs.lineWidth == rhs.lineWidth &&
        lhs.startPoint == rhs.startPoint &&
        lhs.endPoint == rhs.endPoint
    }

    var frame: CGRect {
        var frame = CGRect(x: min(startPoint.x, endPoint.x),
                           y: min(startPoint.y, endPoint.y),
                           width: abs(startPoint.x - endPoint.x),
                           height: abs(startPoint.y - endPoint.y))
        if case .arrow = style {
            let point1 = endPoint - (endPoint - startPoint) / endPoint.distance(to: startPoint) * 18
            let angle = startPoint.angle(to: endPoint)
            let point2 = point1.move(angle: angle + .pi * 0.5, distance: 9)
            let point3 = point1.move(angle: angle - .pi * 0.5, distance: 9)
            let allPoints = [startPoint, endPoint, point1, point2, point3]
            frame.origin.x = allPoints.map { $0.x }.min()!
            frame.origin.y = allPoints.map { $0.y }.min()!
            frame.size.width = allPoints.map { $0.x }.max()! - allPoints.map { $0.x }.min()!
            frame.size.height = allPoints.map { $0.y }.max()! - allPoints.map { $0.y }.min()!
        }
        return frame
    }

    var path: UIBezierPath { path(inSelf: true) }

    func path(inSelf: Bool, arrowScale: CGFloat = 1) -> UIBezierPath {
        let path: UIBezierPath
        switch style {
        case .rectangle:
            path = UIBezierPath(roundedRect: CGRect(origin: inSelf ? .zero : frame.origin, size: frame.size), cornerRadius: 1)
        case .circle:
            path = UIBezierPath(ovalIn: CGRect(origin: inSelf ? .zero : frame.origin, size: frame.size))
        case .arrow:
            path = UIBezierPath()
            let startPoint = startPoint - (inSelf ? frame.origin : .zero)
            let endPoint = endPoint - (inSelf ? frame.origin : .zero)

            path.move(to: startPoint)
            let point1 = endPoint - (endPoint - startPoint) / endPoint.distance(to: startPoint) * 18 * arrowScale
            path.addLine(to:point1)
            let angle = startPoint.angle(to: endPoint)
            let point2 = point1.move(angle: angle + .pi * 0.5, distance: 9 * arrowScale)
            path.addLine(to: point2)
            path.addLine(to: endPoint)
            let point4 = point1.move(angle: angle - .pi * 0.5, distance: 9 * arrowScale)
            path.addLine(to: point4)
            path.addLine(to: point1)
            path.close()
        }
        return path
    }
}
