//
//  PhotoEditorContentView+DrawShape.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/7.
//

import UIKit

extension PhotoEditorContentView {
    @discardableResult
    func addDrawShape(data: DrawShapeData) -> DrawShapeView {
        let view = DrawShapeView(model: data)
        imageView.insertSubview(view, belowSubview: cropLayerLeave)
        drawShapeViews.append(view)
        return view
    }
    
    /// 裁剪结束时更新UI
    func updateDrawShapeFrameWhenCropEnd() {
        let scaleX = imageView.bounds.width / cropContext.lastImageViewBounds.width
        let scaleY = imageView.bounds.height / cropContext.lastImageViewBounds.height
        drawShapeViews.map { $0.model }.forEach { model in
            model.startPoint.x *= scaleX
            model.startPoint.y *= scaleY
            var end = model.endPoint
            end.x *= scaleX
            end.y *= scaleY
            model.endPoint = end
        }
        restoreHiddenDrawShapeView()
    }
    
    /// 删除隐藏的DrawShapeView
    func removeHiddenDrawShapeView() {
        drawShapeViews.enumerated()
            .filter { $0.element.isHidden }
            .forEach { (idx, shapeView) in
                shapeView.removeFromSuperview()
                drawShapeViews.remove(at: idx)
                context.action(.shapeDidRemove(shapeView.model))
            }
    }
    
    /// 删除所有DrawShapeView
    func removeAllDrawShapeView() {
        drawShapeViews.forEach { $0.removeFromSuperview() }
        drawShapeViews.removeAll()
    }
    
    /// 显示所有DrawShapeView
    func restoreHiddenDrawShapeView() {
        drawShapeViews.forEach{ $0.isHidden = false }
    }
    
    /// 隐藏所有DrawShapeView
    func hiddenAllDrawShapeView() {
        drawShapeViews.forEach{ $0.isHidden = true }
    }
    
    func removeDrawShape(data: DrawShapeData) {
        guard let (index, shapeView) = drawShapeViews.enumerated().first(where: { $0.element.model == data }) else { return }
        shapeView.removeFromSuperview()
        drawShapeViews.remove(at: index)
        context.action(.shapeDidRemove(data))
    }
    
    func updateDrawShapeView(with edit: PhotoEditingStack.Edit) {
        let shapeData = drawShapeViews.map { $0.model }
        if shapeData == edit.drawShapeData {
            return
        } else if shapeData.count < edit.drawShapeData.count {
            if shapeData == Array(edit.drawShapeData[0..<drawShapeViews.count]) {
                for i in shapeData.count..<edit.drawShapeData.count {
                    addDrawShape(data: edit.drawShapeData[i])
                }
            }
        } else {
            if edit.drawShapeData == Array(shapeData[0..<edit.drawShapeData.count]) {
                for _ in edit.drawShapeData.count..<shapeData.count {
                    let shapeView = drawShapeViews.removeLast()
                    shapeView.removeFromSuperview()
                }
            }
        }
        let newShapeData = drawShapeViews.map { $0.model }
        if newShapeData != edit.drawShapeData { // Just in case
            removeAllDrawShapeView()
            edit.drawShapeData.forEach { addDrawShape(data: $0) }
        }
    }
}

extension PhotoEditorContentView: ShapeCanvasDelegate {
    func shapeCanvasDidBeginDraw() {
        context.action(.shapeBeginDraw)
    }
    
    func shapeCanvasAddShape(data: DrawShapeData) {
        context.action(.shapeAddData(data))
    }
    
    func shapeCanvasDidEndDraw() {
        context.action(.shapeFinishDraw)
    }
}
