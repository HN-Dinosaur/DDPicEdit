//
//  Extension+CGPoint.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit

extension CGPoint {
    
    static func middle(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        let p = pow(x - other.x, 2) + pow(y - other.y, 2)
        return sqrt(p)
    }
    
    func multipliedBy(_ amount: CGFloat) -> CGPoint {
        guard amount != 1.0 else { return self }
        return CGPoint(x: x * amount, y: y * amount)
    }
    
    func reversed(_ flag: Bool = true) -> CGPoint {
        return flag ? CGPoint(x: y, y: x) : self
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    /// 向指定角度移动指定距离
    /// - Parameters:
    ///   - angle: 角度
    ///   - distance: 距离
    /// - Returns: 移动后的点
    func move(angle: CGFloat, distance: CGFloat) -> CGPoint {
        self + CGPoint(x: cos(angle) * distance, y: sin(angle) * distance)
    }
    
    // 判断自己和otherPoint在X负方向上的夹角
    func angle(to otherPoint: CGPoint) -> CGFloat {
        let pointDelta = self - otherPoint
        return atan2(pointDelta.y, pointDelta.x)
    }
}
