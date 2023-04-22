//
//  PhotoEditorContentView+Brush.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/18.
//

import UIKit

// MARK: - CanvasDelegate
extension PhotoEditorContentView: CanvasDelegate {
    
    func canvasDidBeginDraw() {
        context.action(.brushBeginDraw)
    }
    
    func canvasDidEndDraw() {
        context.action(.brushFinishDraw(canvas.drawnPaths.map { BrushData(drawnPath: $0) }))
    }
}

// MARK: - CanvasDataSource
extension PhotoEditorContentView: CanvasDataSource {
    
    func canvasGetLineWidth(_ canvas: Canvas) -> CGFloat {
        let scale = scrollView.zoomScale
        return options.brushWidth / scale
    }
}
