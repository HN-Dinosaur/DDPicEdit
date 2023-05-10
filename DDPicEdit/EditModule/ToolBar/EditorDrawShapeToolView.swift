//
//  EditorDrawShapeToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/7.
//

import UIKit
import Anchorage

protocol EditorDrawShapeToolViewDelegate: AnyObject {
    
    func drawShapeToolView(_ drawShapeToolView: EditorDrawShapeToolView, shapeDidChange idx: Int)
    
    func drawShapeToolViewUndoButtonTapped(_ drawShapeToolView: EditorDrawShapeToolView)
}

final class EditorDrawShapeToolView: DDPicBaseView {
    
    weak var delegate: EditorDrawShapeToolViewDelegate?
    
    private(set) var currentIdx: Int = 0
    
    private let options: EditorPhotoOptionsInfo
    private var shapeButtons: [UIButton] = []
    private let spacing: CGFloat = 40
    private let itemWidth: CGFloat = 22
    private let buttonWidth: CGFloat = 34
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.options = options
        self.currentIdx = options.defaultShapeIndex
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(self.undoButton)
        self.undoButton.rightAnchor == self.rightAnchor - 8
        self.undoButton.centerYAnchor == self.centerYAnchor
        self.undoButton.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth)
        
        self.setupShapeView()
        self.updateState()
    }
    
    private func setupShapeView() {
        for (idx, option) in options.drawShapeOptions.enumerated() {
            self.shapeButtons.append(createShapeButton(option, idx: idx))
        }
        
        let stackView = UIStackView(arrangedSubviews: self.shapeButtons, distribution: .equalSpacing, spacing: spacing)
        stackView.isHidden = self.options.drawShapeOptions.count <= 1
        self.addSubview(stackView)
        let width = self.itemWidth * CGFloat(self.shapeButtons.count) + self.spacing * CGFloat(self.shapeButtons.count - 1)
        let offset = (UIScreen.main.bounds.width - width - 20 * 2 - 20) / 2
        stackView.leftAnchor == self.leftAnchor + offset
        stackView.centerYAnchor == self.centerYAnchor
        stackView.heightAnchor == self.buttonWidth
        
        self.shapeButtons.forEach { $0.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth) }
    }
    
    private func updateState() {
        self.shapeButtons.forEach {
            $0.tintColor = $0.tag == self.currentIdx ? self.options.theme[color: .primary] : .white
            $0.imageView?.layer.borderWidth = 0
        }
    }
    
    @objc private func shapeButtonTapped(_ sender: UIButton) {
        if self.currentIdx != sender.tag {
            self.currentIdx = sender.tag
            self.layoutSubviews()
        }
        self.delegate?.drawShapeToolView(self, shapeDidChange: currentIdx)
        self.updateState()
    }
    
    @objc private func undoButtonTapped(_ sender: UIButton) {
        self.delegate?.drawShapeToolViewUndoButtonTapped(self)
    }
    
    private func createShapeButton(_ option: EditorDrawShapeOption, idx: Int) -> UIButton {
        let image: UIImage? = options.theme[icon: option.iconKey]?.withRenderingMode(.alwaysTemplate)
        let inset = (buttonWidth - itemWidth) / 2
        let button = UIButton(type: .custom)
        button.tag = idx
        button.tintColor = .white
        button.clipsToBounds = true
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
//        button.imageView?.layer.cornerRadius = 2
//        button.imageView?.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private(set) lazy var undoButton: UIButton = {
        let view = UIButton(type: .custom)
        view.isEnabled = false
        view.setImage(options.theme[icon: .photoToolUndo], for: .normal)
        view.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
}
