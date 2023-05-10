//
//  ShapeMask.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/9.
//

import UIKit

struct ShapeMask: GraphicsDrawing {
    let model: DrawShapeData
    let imageScale: CGFloat

    func draw(in context: CGContext, size: CGSize) {
        UIGraphicsPushContext(context)
        context.saveGState()

        let model = model
        model.startPoint = model.startPoint * imageScale
        model.endPoint = model.endPoint * imageScale
        model.lineWidth *= imageScale

        let path = model.path(inSelf: false, arrowScale: imageScale).cgPath
        context.setLineWidth(model.lineWidth)
        context.setStrokeColor(UIColor.red.cgColor)
        context.addPath(path)
        context.strokePath()
        context.addPath(path)
        context.setFillColor(model.style == .arrow ? UIColor.red.cgColor : UIColor.clear.cgColor)
        context.fillPath()

        context.restoreGState()
        UIGraphicsPopContext()
    }
}
