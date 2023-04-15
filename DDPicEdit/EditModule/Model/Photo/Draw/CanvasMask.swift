//
//  CanvasMask.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit

struct CanvasMask {
    
    let paths: [DrawnPath]
    let scale: CGFloat
    
    init(paths: [DrawnPath], scale: CGFloat) {
        self.paths = paths
        self.scale = scale
    }
}

// MARK: - GraphicsDrawing
extension CanvasMask: GraphicsDrawing {
    
    func draw(in context: CGContext, size: CGSize) {
        guard !paths.isEmpty else { return }
        guard
            let cglayer = CGLayer(context, size: size, auxiliaryInfo: nil),
            let layerContext = cglayer.context else {
            assert(false, "Failed to create CGLayer")
            return
        }
        
        UIGraphicsPushContext(layerContext)
        paths.forEach { path in
            layerContext.saveGState()
            layerContext.scaleBy(x: scale, y: scale)
            path.draw(in: layerContext, size: size)
            layerContext.restoreGState()
        }
        UIGraphicsPopContext()
        
        UIGraphicsPushContext(context)
        context.draw(cglayer, at: .zero)
        UIGraphicsPopContext()
    }
}
