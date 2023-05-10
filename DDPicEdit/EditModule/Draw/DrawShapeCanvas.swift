//
//  DrawShapeCanvas.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/9.
//

import UIKit

protocol ShapeCanvasDelegate {
    func shapeCanvasDidBeginDraw()
    func shapeCanvasAddShape(data: DrawShapeData)
    func shapeCanvasDidEndDraw()
}

class DrawShapeCanvas: DDPicBaseView {
    
    var delegate: ShapeCanvasDelegate?
    var data: DrawShapeData?
    private var selectIndex = 0
    
    public func updateSelectShapeStype(index: Int) {
        self.selectIndex = index
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchPoint = touch.preciseLocation(in: self)
        data = .init(style: EditorDrawShapeOption(rawValue: self.selectIndex) ?? .rectangle, startPoint: touchPoint, endPoint: touchPoint)
        delegate?.shapeCanvasDidBeginDraw()
        delegate?.shapeCanvasAddShape(data: data!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let touchPoint = touch.preciseLocation(in: self)
        data?.endPoint = touchPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        data = nil
        delegate?.shapeCanvasDidEndDraw()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        data = nil
        delegate?.shapeCanvasDidEndDraw()
    }
}
