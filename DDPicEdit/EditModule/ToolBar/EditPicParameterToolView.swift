//
//  EditPicParameterToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/4.
//

import UIKit
import Anchorage

protocol EditPicParameterToolViewDelegate: AnyObject {
    func picParameterToolView(_ toolView: EditPicParameterToolView, data: PicParameterData)
    func picParameterToolViewCancelButtonTapped(_ cropToolView: EditPicParameterToolView)
    func picParameterToolViewDoneButtonTapped(_ cropToolView: EditPicParameterToolView)
}


final class EditPicParameterToolView: DDPicBaseView {
    public static let staticHeight: CGFloat = 190
    
    weak var delegate: EditPicParameterToolViewDelegate?
    private let options: EditorPhotoOptionsInfo
    private var toolViewModels: [IndicatorModel] = []
    
    init(options: EditorPhotoOptionsInfo) {
        self.options = options
        super.init(frame: .zero)
        setupView()
        createIndicatorOptions()
    }
    
    private func setupView() {
        let contentLayoutGuide = UILayoutGuide()
        self.addLayoutGuide(contentLayoutGuide)
        self.recursiveAddSubView(views: [
            self.toolView,
            self.cancelButton,
            self.doneButton,
        ])
        
        self.toolView.topAnchor == self.topAnchor
        self.toolView.horizontalAnchors == self.horizontalAnchors
        self.toolView.heightAnchor == 130
        
        contentLayoutGuide.horizontalAnchors == self.horizontalAnchors
        contentLayoutGuide.bottomAnchor == self.bottomAnchor
        contentLayoutGuide.heightAnchor == 60
        
        self.cancelButton.leftAnchor == contentLayoutGuide.leftAnchor + 20
        self.cancelButton.centerYAnchor == contentLayoutGuide.centerYAnchor + 8
        self.cancelButton.sizeAnchors == CGSize(width: 40, height: 40)
        
        self.doneButton.rightAnchor == contentLayoutGuide.rightAnchor - 20
        self.doneButton.centerYAnchor == contentLayoutGuide.centerYAnchor + 8
        self.doneButton.sizeAnchors == CGSize(width: 40, height: 40)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        delegate?.picParameterToolViewCancelButtonTapped(self)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        delegate?.picParameterToolViewDoneButtonTapped(self)
    }
    
    private func createIndicatorOptions() {
        var models: [IndicatorModel] = []
        self.options.picParameterChangeOption.forEach {
            models.append(IndicatorModel(limitNumber: 100, normalIconImage: nil, describeStr: $0.rawValue))
        }
        self.toolView.indicatorModels = models
    }
    
    private lazy var toolView: IndicatorAndSliderView = {
        let toolView = IndicatorAndSliderView()
        toolView.delegate = self
        return toolView
    }()
    private(set) lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(options.theme[icon: .xMark], for: .normal)
        view.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private(set) lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(options.theme[icon: .checkMark], for: .normal)
        view.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
}

extension EditPicParameterToolView: IndicatorAndSliderViewDelegate {
    
    public func didGetOffsetRatio(_ slider: IndicatorAndSliderView, activeIndicatorIndex: Int, offsetRatio: Float) {
        
    }
    
}
