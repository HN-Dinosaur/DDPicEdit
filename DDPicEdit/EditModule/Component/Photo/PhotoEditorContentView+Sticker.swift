//
//  PhotoEditorContentView+Sticker.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/18.
//

import UIKit
import Anchorage

// MARK: - Internal
extension PhotoEditorContentView {
    
    @discardableResult
    func addSticker(data: StickerData, add: Bool = true) -> StickerBaseView {
        if data.frame.isEmpty {
            calculateStickerFrame(data: data)
            if cropContext.rotateState != .portrait {
                data.rotation = cropContext.rotateState.toPortraitAngle
            }
        }
        
        let stickerView = StickerBaseView(data: data)
        stickerView.transform = stickerView.calculateTransform()
        if add {
            imageView.insertSubview(stickerView, belowSubview: cropLayerLeave)
            stickerImageViews.append(stickerView)
            addTextGestureRecognizer(stickerView)
        }
        return stickerView
    }
    
    /// 裁剪结束时更新UI
    func updateStickerFrameWhenCropEnd() {
        let scale = imageView.bounds.width / cropContext.lastImageViewBounds.width
        resetStickerView(with: scale)
    }
    
    /// 更新UI
    func resetStickerView(with scale: CGFloat) {
        var newStickerImageViews: [StickerBaseView] = []
        for stickerView in stickerImageViews {
            let originPoint = stickerView.data.point
            let originScale = stickerView.data.scale
            let originRotation = stickerView.data.rotation
            stickerView.data.point = .zero
            stickerView.data.scale = 1.0
            stickerView.data.rotation = 0.0
            stickerView.transform = stickerView.calculateTransform()
            
            var frame = stickerView.frame
            frame.origin.x *= scale
            frame.origin.y *= scale
            frame.size.width *= scale
            frame.size.height *= scale
            stickerView.data.frame = frame
            
            let newStickerView = addSticker(data: stickerView.data, add: false)
            newStickerView.data.point = CGPoint(x: originPoint.x * scale, y: originPoint.y * scale)
            newStickerView.data.scale = originScale
            newStickerView.data.rotation = originRotation
            newStickerView.transform = stickerView.calculateTransform()
            newStickerImageViews.append(newStickerView)
        }
        
        stickerImageViews.forEach { $0.removeFromSuperview() }
        stickerImageViews.removeAll()
        newStickerImageViews.forEach {
            imageView.insertSubview($0, belowSubview: cropLayerLeave)
            self.stickerImageViews.append($0)
            self.addTextGestureRecognizer($0)
        }
    }
    
    func calculateFinalFrame(with scale: CGFloat) {
        for stickerView in stickerImageViews {
            let data = stickerView.data
            let originPoint = data.point
            let originScale = data.scale
            let originRotation = data.rotation
            let originFrame = data.frame
            data.point = .zero
            data.scale = 1.0
            data.rotation = 0.0
            stickerView.transform = stickerView.calculateTransform()
            var frame = stickerView.frame
            frame.origin.x *= scale
            frame.origin.y *= scale
            frame.size.width *= scale
            frame.size.height *= scale
            data.frame = frame
            
            let newStickerView = StickerBaseView(data: data)
            data.point = originPoint.multipliedBy(scale)
            data.scale = originScale
            data.frame = originFrame
            newStickerView.transform = stickerView.calculateTransform()
            data.finalFrame = newStickerView.frame
            data.point = originPoint
            data.rotation = originRotation
        }
    }
    
    /// 删除隐藏的Sticker
    func removeHiddenStickerView() {
        var newStickerImageViews = [StickerBaseView]()
        for (_, stickerView) in stickerImageViews.enumerated() {
            if stickerView.isHidden {
                stickerView.removeFromSuperview()
                context.action(.stickerDidFinishMove(data: stickerView.data, delete: true))
            } else {
                newStickerImageViews.append(stickerView)
            }
        }
        self.stickerImageViews = newStickerImageViews
    }
    
    /// 删除所有StickerView
    func removeAllStickerView() {
        stickerImageViews.forEach { $0.removeFromSuperview() }
        stickerImageViews.removeAll()
    }
    
    /// 显示所有Sticker
    func restoreHiddenTextView() {
        stickerImageViews.forEach { $0.isHidden = false }
    }
    
    /// 隐藏所有Sticker
    func hiddenAllTextView() {
        stickerImageViews.forEach { $0.isHidden = true }
    }
    
    /// 取消激活所有Sticker
    func deactivateAllTextView() {
        stickerImageViews.forEach { $0.setActive(false) }
    }
    
    func updateStickerView(with edit: PhotoEditingStack.Edit) {
        let stickerData = self.stickerImageViews.map { $0.data }
        if stickerData == edit.stickerData {
            return
        } else if stickerData.count < edit.stickerData.count {
            if stickerData == Array(edit.stickerData[0..<stickerImageViews.count]) {
                for i in stickerData.count..<edit.stickerData.count {
                    addSticker(data: edit.stickerData[i])
                }
            }
        } else {
            if edit.stickerData == Array(stickerData[0..<edit.stickerData.count]) {
                for _ in edit.stickerData.count..<stickerData.count {
                    let stickerView = stickerImageViews.removeLast()
                    stickerView.removeFromSuperview()
                }
            }
        }
        if stickerData != edit.stickerData { // Just in case
            removeAllStickerView()
            edit.stickerData.forEach { addSticker(data: $0) }
        }
    }
}

// MARK: - Private
extension PhotoEditorContentView {
    
    /// 计算视图位置
    public func calculateStickerFrame(data: StickerData) {
        let image = data.image
        let scale = scrollView.zoomScale
        let inset: CGFloat = 0
        let size = CGSize(width: (image.size.width + inset * 2) / scale, height: (image.size.height + inset * 2) / scale)
        
        var x: CGFloat
        var y: CGFloat
        if !cropContext.didCropOrRotate {
            if scrollView.zoomScale == scrollView.minimumZoomScale {
                x = (imageView.bounds.width - size.width) / 2
                y = (imageView.bounds.height - size.height) / 2
            } else {
                let width = UIScreen.main.bounds.width * imageView.bounds.width / imageView.frame.width
                x = abs(scrollView.contentOffset.x) / scale
                x = x + (width - size.width) / 2
                
                var height = UIScreen.main.bounds.height * imageView.bounds.height / imageView.frame.height
                let screenHeight = UIScreen.main.bounds.height / scale
                height = height > screenHeight ? screenHeight : height
                y = scrollView.contentOffset.y / scale
                y = y + (height - size.height) / 2
            }
        } else {
            let reversedCropRect = cropContext.cropRect.size.reversed(!cropContext.rotateState.isPortrait)
            let imageFrameSize = imageView.frame.size
            let contentSize = scrollView.contentSize
            let imageSize = CGSize(width: contentSize.width * imageFrameSize.width / reversedCropRect.width,
                                   height: contentSize.height * imageFrameSize.height / reversedCropRect.height)

            let contentOffset = cropContext.lastCropData.contentOffset
            let offsetX = contentOffset.x * imageSize.width / imageFrameSize.width
            let offsetY = contentOffset.y * imageSize.height / imageFrameSize.height
            
            let width = cropContext.cropRealRect.width * imageView.bounds.width / imageView.frame.width
            x = offsetX / scale
            x = x + (width - size.width) / 2
            
            let height = cropContext.cropRealRect.height * imageView.bounds.height / imageView.frame.height
            y = offsetY / scale
            y = y + (height - size.height) / 2
        }
        data.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    /// 添加手势
    public func addTextGestureRecognizer(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTextSingleTap(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onTextPan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onTextPinch(_:)))
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(onTextRotation(_:)))
        
        tap.delegate = self
        pan.delegate = self
        pinch.delegate = self
        rotation.delegate = self
        // pan识别fail之后再判断是否tap
        tap.require(toFail: pan)
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(pinch)
        view.addGestureRecognizer(rotation)
    }
    
    /// 允许开始响应手势
    private func shouldBeginGesture(in stickerView: StickerBaseView) -> Bool {
        if stickerView.isActive { return true }
        for view in stickerImageViews {
            // 如果还有手势状态为.changed
            // 不应该开始响应手势
            if !view.isGestureEnded {
                return false
            }
        }
        return true
    }
    
    /// 激活视图
    @discardableResult
    private func activeStickerViewIfPossible(_ stickerView: StickerBaseView) -> Bool {
        if !shouldBeginGesture(in: stickerView) { return false }
        for view in stickerImageViews {
            if view == stickerView && !stickerView.isActive {
                bringStickerViewToFront(stickerView)
                imageView.bringSubviewToFront(cropLayerLeave)
            }
            view.setActive(view == stickerView)
        }
        return true
    }
    
    private func bringStickerViewToFront(_ stickerView: StickerBaseView) {
        imageView.bringSubviewToFront(stickerView)
        context.action(.stickerBringToFront(stickerView.data))
        if let idx = stickerImageViews.firstIndex(of: stickerView) {
            stickerImageViews.remove(at: idx)
            stickerImageViews.append(stickerView)
        }
    }
}

// MARK: - Target
extension PhotoEditorContentView {
    
    /// 单击手势
    @objc private func onTextSingleTap(_ tap: UITapGestureRecognizer) {
        guard let stickerView = tap.view as? StickerBaseView else { return }
        if !shouldBeginGesture(in: stickerView) { return }
        if !stickerView.isActive {
            activeStickerViewIfPossible(stickerView)
        } else {
            // 隐藏当前stickerView，进入编辑页面
            stickerView.isHidden = true
            // 是文字不是贴纸
            if !stickerView.data.text.isEmpty {
                context.action(.textWillBeginEdit(stickerView.data))
            }
        }
    }
    
    /// 拖拽手势
    @objc private func onTextPan(_ pan: UIPanGestureRecognizer) {
        guard let stickerView = pan.view as? StickerBaseView else { return }
        guard activeStickerViewIfPossible(stickerView) else { return }
        
        if pan.state == .began {
            stickerView.data.pointBeforePan = stickerView.data.point
        }
        
        let scale = scrollView.zoomScale
        let point = stickerView.data.point
        let newPoint = pan.translation(in: self)
        switch cropContext.rotateState {
        case .portrait:
            stickerView.data.point = CGPoint(x: point.x + newPoint.x / scale, y: point.y + newPoint.y / scale)
        case .upsideDown:
            stickerView.data.point = CGPoint(x: point.x - newPoint.x / scale, y: point.y - newPoint.y / scale)
        case .landscapeLeft:
            stickerView.data.point = CGPoint(x: point.x - newPoint.y / scale, y: point.y + newPoint.x / scale)
        case .landscapeRight:
            stickerView.data.point = CGPoint(x: point.x + newPoint.y / scale, y: point.y - newPoint.x / scale)
        }
        stickerView.transform = stickerView.calculateTransform()
        pan.setTranslation(.zero, in: self)
        
        switch pan.state {
        case .began:
            showTrashView()
            bringStickerViewToFront(stickerView)
            context.action(.stickerWillBeginMove)
        case .changed:
            check(targetView: stickerView, inTrashView: pan.location(in: self))
        default:
            var delete = false
            if textTrashView.state == .remove && textTrashView.frame.contains(pan.location(in: self)) {
                delete = true
            } else if !cropLayerLeave.displayRect.contains(pan.location(in: cropLayerLeave)) { // 判断超出图片区域
                UIView.animate(withDuration: 0.25) {
                    stickerView.data.point = stickerView.data.pointBeforePan
                    stickerView.transform = stickerView.calculateTransform()
                } completion: { (_) in
                    self.imageView.bringSubviewToFront(self.cropLayerLeave)
                }
            } else {
                imageView.bringSubviewToFront(cropLayerLeave)
            }
            hideTrashView()
            context.action(.stickerDidFinishMove(data: stickerView.data, delete: delete))
        }
    }
    
    /// 捏合手势
    @objc private func onTextPinch(_ pinch: UIPinchGestureRecognizer) {
        guard let stickerView = pinch.view as? StickerBaseView else { return }
        guard activeStickerViewIfPossible(stickerView) else { return }
        
        let scale = stickerView.data.scale + (pinch.scale - 1.0)
        if scale < stickerView.data.scale || stickerView.frame.width < imageView.bounds.width * 2.0 {
            stickerView.data.scale = scale
            stickerView.transform = stickerView.calculateTransform()
        }
        pinch.scale = 1.0
    }
    
    /// 旋转手势
    @objc private func onTextRotation(_ rotation: UIRotationGestureRecognizer) {
        guard let stickerView = rotation.view as? StickerBaseView else { return }
        guard activeStickerViewIfPossible(stickerView) else { return }
        
        stickerView.data.rotation += rotation.rotation
        stickerView.transform = stickerView.calculateTransform()
        rotation.rotation = 0.0
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PhotoEditorContentView: UIGestureRecognizerDelegate {
    
    /// 允许多个手势同时响应
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let view = gestureRecognizer.view as? StickerBaseView,
            let otherView = otherGestureRecognizer.view as? StickerBaseView
            else { return false }
        guard view == otherView, view.isActive else { return false }
        return true
    }
}

// MARK: - Trash view
extension PhotoEditorContentView {
    
    private func showTrashView() {
        self.textTrashView.centerXAnchor == self.centerXAnchor
        self.textTrashView.widthAnchor >= 160
        self.textTrashView.heightAnchor == 80
        self.textTrashView.topAnchor == self.safeAreaLayoutGuide.bottomAnchor - 80 - 30
        
        UIView.animate(withDuration: 0.25) {
            self.textTrashView.alpha = 1
        }
    }
    
    private func hideTrashView() {
        UIView.animate(withDuration: 0.25) {
            self.textTrashView.alpha = 0
        } completion: { _ in
            self.textTrashView.state = .idle
        }
    }
    
    private func check(targetView: UIView, inTrashView point: CGPoint) {
        guard textTrashView.alpha == 1 else { return }
        if textTrashView.frame.contains(point) { // move in
            textTrashView.state = .remove
            UIView.animate(withDuration: 0.25) {
                targetView.alpha = 0.25
            }
        } else if textTrashView.state == .remove { // move out
            textTrashView.state = .idle
            UIView.animate(withDuration: 0.25) {
                targetView.alpha = 1.0
            }
        }
    }
}
