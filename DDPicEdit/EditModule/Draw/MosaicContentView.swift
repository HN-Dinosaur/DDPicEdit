//
//  MosaicContentView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/17.
//

import UIKit

final class MosaicContentView: DryDrawingView {

    weak var dataSource: MosaicDataSource?
    weak var delegate: MosaicDelegate?
    
    var didDraw: Block? {
        didSet {
            maskLayer.didDraw = didDraw
        }
    }
    
    let idx: Int
    
    private(set) var brush = Brush()
    private(set) var drawnPaths: [DrawnPath] = [] {
        didSet {
            updateMask()
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        maskLayer.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    init(idx: Int, mosaic: UIImage) {
        self.idx = idx
        super.init(frame: .zero)
        addSubview(imageView)
        imageView.image = mosaic
    }
    
    override func willBeginDraw(path: UIBezierPath) {
        delegate?.mosaicDidBeginDraw()
        brush.lineWidth = dataSource?.mosaicGetLineWidth() ?? 15.0
        let drawnPath = DrawnPath(brush: brush, scale: scale, path: path)
        drawnPaths.append(drawnPath)
    }
    
    override func panning(path: UIBezierPath) {
        updateMask()
    }
    
    override func didFinishDraw(path: UIBezierPath) {
        delegate?.mosaicDidEndDraw()
        updateMask()
    }
    
    func updateMask() {
        maskLayer.drawnPaths = drawnPaths
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.layer.mask = maskLayer
        return view
    }()
    private lazy var maskLayer: MaskLayer = {
        let layer = MaskLayer()
        layer.scale = { [weak self] in
            return self?.scale ?? 1.0
        }
        layer.contentsScale = UIScreen.main.scale
        layer.drawsAsynchronously = true
        return layer
    }()
}

// MARK: - Public
extension MosaicContentView {
    
    func setDrawn(paths: [DrawnPath]) {
        drawnPaths = paths
    }
}

// MARK: - MaskLayer
private class MaskLayer: CALayer {
    
    var didDraw: Block?
    var scale: (() -> CGFloat)?
    
    var drawnPaths: [DrawnPath] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        drawnPaths.forEach { $0.draw(in: ctx, size: bounds.size, scale: scale?() ?? 1.0) }
        didDraw?()
    }
}
