//
//  EditorToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

final class EditorToolView: DDPicBaseView {

    var currentOption: EditorPhotoToolOption? {
        editOptionsView.currentOption
    }
    private let context: PhotoEditorContext
    private var options: EditorPhotoOptionsInfo {
        return context.options
    }

    init(frame: CGRect, context: PhotoEditorContext) {
        self.context = context
        super.init(frame: frame)
        self.setupView()
    }

    private func setupView() {
        self.recursiveAddSubView(views: [
            self.topCoverView,
            self.bottomCoverView,
            self.editOptionsView,
            self.brushToolView,
            self.cropToolView,
            self.mosaicToolView,
            self.drawShapeToolView,
            self.waterMarkToolView,
            self.picParameterToolView,
            self.pasterToolView,
            self.doneButton,
        ])

        self.topCoverView.horizontalAnchors == self.horizontalAnchors
        self.topCoverView.topAnchor == self.topAnchor
        self.topCoverView.heightAnchor == 140
        
        self.bottomCoverView.topAnchor == self.brushToolView.topAnchor - 20
        self.bottomCoverView.horizontalAnchors == self.horizontalAnchors
        self.bottomCoverView.bottomAnchor == self.bottomAnchor
        
        self.editOptionsView.leftAnchor == self.leftAnchor
        self.editOptionsView.rightAnchor == self.doneButton.leftAnchor - 20
        if #available(iOS 11.0, *) {
            self.editOptionsView.bottomAnchor == self.safeAreaLayoutGuide.bottomAnchor - 14
        } else {
            self.editOptionsView.bottomAnchor == self.bottomAnchor - 14
        }
        self.editOptionsView.heightAnchor == 50
        
        self.brushToolView.horizontalAnchors == self.horizontalAnchors
        self.brushToolView.bottomAnchor == self.editOptionsView.topAnchor - 10
        self.brushToolView.heightAnchor == 40
        
        self.mosaicToolView.edgeAnchors == self.brushToolView.edgeAnchors
        self.waterMarkToolView.edgeAnchors == self.mosaicToolView.edgeAnchors
        
        self.drawShapeToolView.edgeAnchors == self.mosaicToolView.edgeAnchors
        
        self.cropToolView.horizontalAnchors == self.horizontalAnchors
        self.cropToolView.bottomAnchor == self.editOptionsView.bottomAnchor + 15
        let height: CGFloat = 40 + 10 + 60
        self.cropToolView.heightAnchor == height
        
        self.picParameterToolView.horizontalAnchors == self.horizontalAnchors
        self.picParameterToolView.bottomAnchor == self.cropToolView.bottomAnchor
        self.picParameterToolView.heightAnchor == EditPicParameterToolView.staticHeight
        
        self.pasterToolView.horizontalAnchors == self.horizontalAnchors
        self.pasterToolView.bottomAnchor == self.cropToolView.bottomAnchor
        self.pasterToolView.heightAnchor == EditorPasterToolView.staticHeight
        
        self.doneButton.centerYAnchor == self.editOptionsView.centerYAnchor
        self.doneButton.rightAnchor == self.rightAnchor - 20
    }
    
    private(set) lazy var topCoverView = AxialGradientView(startAnchor: .top, endAnchor: .bottom, startColor: UIColor.black.withAlphaComponent(0.12), endColor: UIColor.black.withAlphaComponent(0))
    private(set) lazy var bottomCoverView = AxialGradientView(startAnchor: .top, endAnchor: .bottom, startColor: UIColor.black.withAlphaComponent(0.25), endColor: UIColor.black.withAlphaComponent(0))

    // 选项View
    private(set) lazy var editOptionsView: EditorEditOptionsView = {
        let view = EditorEditOptionsView(frame: .zero, options: options)
        view.delegate = self
        return view
    }()
    // 画笔View
    private(set) lazy var brushToolView: EditorBrushToolView = {
        let view = EditorBrushToolView(frame: .zero, options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 裁剪View
    private(set) lazy var cropToolView: EditorCropToolView = {
        let view = EditorCropToolView(frame: .zero, options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 马赛克View
    private(set) lazy var mosaicToolView: EditorMosaicToolView = {
        let view = EditorMosaicToolView(frame: .zero, options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 水印View
    private(set) lazy var waterMarkToolView: EditWaterMarkToolView = {
        let view = EditWaterMarkToolView(options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 图片参数View
    private(set) lazy var picParameterToolView: EditPicParameterToolView = {
        let view = EditPicParameterToolView(options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 贴纸View
    private(set) lazy var pasterToolView: EditorPasterToolView = {
        let view = EditorPasterToolView(options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    // 绘制矩形View
    private(set) lazy var drawShapeToolView: EditorDrawShapeToolView = {
        let view = EditorDrawShapeToolView(frame: .zero, options: options)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    private(set) lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 2
        view.backgroundColor = options.theme[color: .primary]
        view.setTitle(options.theme[string: .done], for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        view.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return view
    }()
}

// MARK: - Public
extension EditorToolView {

    public func selectFirstItemIfNeeded() {
        editOptionsView.selectFirstItemIfNeeded()
    }

    public func hiddenToolBarIfNeeded() {
        if currentOption == nil && options.toolOptions.count == 1 && options.toolOptions.first! == .crop {
            doneButton.isHidden = true
            editOptionsView.isHidden = true
        }
    }
}

// MARK: - Target
extension EditorToolView {

    @objc private func doneButtonTapped() {
        context.action(.done)
    }
}

// MARK: - EditorEditOptionsViewDelegate
extension EditorToolView: EditorEditOptionsViewDelegate {

    func editOptionsView(_ editOptionsView: EditorEditOptionsView, optionWillChange option: EditorPhotoToolOption?) -> Bool {
        let result = context.action(.toolOptionChanged(option))
        guard result else { return false }

        guard let option = option else {
            brushToolView.isHidden = true
            cropToolView.isHidden = true
            pasterToolView.isHidden = true
            picParameterToolView.isHidden = true
            mosaicToolView.isHidden = true
            drawShapeToolView.isHidden = true
            waterMarkToolView.isHidden = true
            return true
        }

        brushToolView.isHidden = option != .brush
        cropToolView.isHidden = option != .crop
        pasterToolView.isHidden = option != .paster
        picParameterToolView.isHidden = option != .picParameter
        mosaicToolView.isHidden = option != .mosaic
        drawShapeToolView.isHidden = option != .drawShape
        waterMarkToolView.isHidden = option != .waterMark

        switch option {
        case .crop, .picParameter, .paster:
            editOptionsView.isHidden = true
            topCoverView.isHidden = true
            doneButton.isHidden = true
            if option == .crop, let option = options.cropOptions.first, cropToolView.currentOption == nil {
                cropToolView.currentOption = option
            }
        default:
            break
        }
        return true
    }
}

// MARK: - EditorBrushToolViewDelegate
extension EditorToolView: EditorBrushToolViewDelegate {

    func brushToolView(_ brushToolView: EditorBrushToolView, colorDidChange color: UIColor) {
        context.action(.brushChangeColor(color))
    }

    func brushToolViewUndoButtonTapped(_ brushToolView: EditorBrushToolView) {
        context.action(.brushUndo)
    }
}

// MARK: - EditorMosaicToolViewDelegate
extension EditorToolView: EditorMosaicToolViewDelegate {

    func mosaicToolView(_ mosaicToolView: EditorMosaicToolView, mosaicDidChange idx: Int) {
        context.action(.mosaicChangeImage(idx))
    }

    func mosaicToolViewUndoButtonTapped(_ mosaicToolView: EditorMosaicToolView) {
        context.action(.mosaicUndo)
    }
}

// MARK: - EditorMosaicToolViewDelegate
extension EditorToolView: EditorDrawShapeToolViewDelegate {

    func drawShapeToolView(_ drawShapeToolView: EditorDrawShapeToolView, shapeDidChange idx: Int) {
        context.action(.shapeChange(idx))
    }

    func drawShapeToolViewUndoButtonTapped(_ drawShapeToolView: EditorDrawShapeToolView) {
        context.action(.shapeUndo)
    }
}

// MARK: - EditorCropToolViewDelegate
extension EditorToolView: EditorCropToolViewDelegate {

    private func hiddenCropView() {
        exposureCommonView()
        cropToolView.isHidden = true
    }
    
    private func exposureCommonView() {
        editOptionsView.isHidden = false
        topCoverView.isHidden = false
        doneButton.isHidden = false
        editOptionsView.unselectButtons()
    }
    
    func cropToolView(_ toolView: EditorCropToolView, didClickCropOption option: EditorCropOption) -> Bool {
        return context.action(.cropUpdateOption(option))
    }

    func cropToolViewCancelButtonTapped(_ cropToolView: EditorCropToolView) {
        let result = context.action(.cropCancel)
        guard result else { return }
        hiddenCropView()
        editOptionsView.unselectButtons()
    }

    func cropToolViewDoneButtonTapped(_ cropToolView: EditorCropToolView) {
        let result = context.action(.cropDone)
        guard result else { return }
        hiddenCropView()
        editOptionsView.unselectButtons()
    }

    func cropToolViewResetButtonTapped(_ cropToolView: EditorCropToolView) {
        context.action(.cropReset)
    }

    func cropToolViewRotateButtonTapped(_ cropToolView: EditorCropToolView) -> Bool {
        return context.action(.cropRotate)
    }
}

// MARK: - EditWaterMarkToolViewDelegate
extension EditorToolView: EditWaterMarkToolViewDelegate {
    func selectWaterMarkToolLocation(_ waterMarkView: EditWaterMarkToolView, _ data: WaterMarkData) {
        context.action(.waterMarkChange(data))
    }
}

// MARK: -EditPicParameterToolViewDelegate
extension EditorToolView: EditPicParameterToolViewDelegate {
    private func hiddenPicParameterView() {
        exposureCommonView()
        picParameterToolView.isHidden = true
    }
    
    func picParameterToolView(_ toolView: EditPicParameterToolView, data: PicParameterData) {
        context.action(.picParameterChange(data))
    }
    
    func picParameterToolViewCancelButtonTapped(_ toolView: EditPicParameterToolView) {
        context.action(.picParameterCancel)
        hiddenPicParameterView()
    }
    
    func picParameterToolViewDoneButtonTapped(_ toolView: EditPicParameterToolView) {
        context.action(.picParameterDone)
        hiddenPicParameterView()
    }
}

// MARK: -EditPasterToolViewDelegate
extension EditorToolView: EditPasterToolViewDelegate {
    
    private func hiddenPasterToolView() {
        exposureCommonView()
        pasterToolView.isHidden = true
    }
    
    func pasterToolViewDidSelectPaster(_ pasterToolView: EditorPasterToolView, data: StickerData) {
        context.action(.pasterSelect(data))
        hiddenPasterToolView()
    }
    
    func pasterToolViewCancelButtonTapped(_ pasterToolView: EditorPasterToolView) {
        context.action(.pasterCancel)
        hiddenPasterToolView()
    }
    
    func pasterToolViewDoneButtonTapped(_ pasterToolView: EditorPasterToolView) {
        context.action(.pasterDone)
        hiddenPasterToolView()
    }
}

// MARK: - Event
extension EditorToolView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden || !isUserInteractionEnabled || alpha < 0.01 {
            return nil
        }
        let subViews = [editOptionsView, brushToolView, cropToolView, mosaicToolView, waterMarkToolView, picParameterToolView, pasterToolView, drawShapeToolView, doneButton]
        for subView in subViews {
            if let hitView = subView.hitTest(subView.convert(point, from: self), with: event) {
                return hitView
            }
        }
        return nil
    }
}
