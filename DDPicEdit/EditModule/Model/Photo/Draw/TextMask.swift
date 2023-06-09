//
//  TextMask.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/15.
//

import UIKit

struct TextMask {
    
    let data: StickerData
    let scale: CGFloat
    
    init(data: StickerData, scale: CGFloat) {
        self.data = data
        self.scale = scale
    }
}

// MARK: - GraphicsDrawing
extension TextMask: GraphicsDrawing {
    
    func draw(in context: CGContext, size: CGSize) {
        guard let cgImage = data.image.cgImage else { return }
        guard
            let cglayer = CGLayer(context, size: size, auxiliaryInfo: nil),
            let layerContext = cglayer.context else {
            assert(false, "Failed to create CGLayer")
            return
        }

        let frame = data.finalFrame.multipliedBy(scale)
        
        UIGraphicsPushContext(layerContext)
        layerContext.saveGState()
        layerContext.translateBy(x: frame.midX, y: frame.midY)
        layerContext.rotate(by: data.rotation)
        layerContext.scaleBy(x: 1, y: -1)
        layerContext.draw(cgImage, in: CGRect(x: -(frame.width / 2), y: -(frame.height / 2), width: frame.width, height: frame.height))
        layerContext.restoreGState()
        UIGraphicsPopContext()
        
        UIGraphicsPushContext(context)
        context.draw(cglayer, at: .zero)
        UIGraphicsPopContext()
    }
}
