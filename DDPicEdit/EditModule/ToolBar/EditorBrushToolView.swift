//
//  EditorBrushToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/11.
//

import UIKit
import Anchorage

protocol EditorBrushToolViewDelegate: AnyObject {
    
    func brushToolView(_ brushToolView: EditorBrushToolView, colorDidChange color: UIColor)
    
    func brushToolViewUndoButtonTapped(_ brushToolView: EditorBrushToolView)
}

final class EditorBrushToolView: DDPicBaseView {
    
    weak var delegate: EditorBrushToolViewDelegate?
    
    private(set) var currentIdx: Int
    
    private let options: EditorPhotoOptionsInfo
    private let colorOptions: [EditorBrushColorOption]
    private var colorButtons: [UIControl] = []
    private let spacing: CGFloat = 10
    private let itemWidth: CGFloat = 24
    private let buttonWidth: CGFloat = 34
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.colorOptions = options.brushColors
        self.currentIdx = options.defaultBrushIndex
        self.options = options
        super.init(frame: frame)
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (idx, colorView) in self.colorButtons.enumerated() {
            let scale: CGFloat = idx == currentIdx ? 1.25 : 1.0
            if let button = colorView as? ColorButton {
                button.colorView.transform = CGAffineTransform(scaleX: scale, y: scale)
                button.isSelected = idx == currentIdx
            }
            
            let colorViewRight = CGFloat(idx) * spacing + CGFloat(idx + 1) * itemWidth
            colorView.isHidden = colorViewRight > (bounds.width - itemWidth)
        }
    }
    
    private func setupView() {
        addSubview(self.undoButton)
        self.setupColorView()
        self.undoButton.rightAnchor == self.rightAnchor - 8
        self.undoButton.centerYAnchor == self.centerYAnchor
        self.undoButton.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth)
    }
    
    private func setupColorView() {
        for (idx, option) in self.colorOptions.enumerated() {
            self.colorButtons.append(self.createColorButton(by: option, idx: idx))
        }
        let stackView = UIStackView(arrangedSubviews: self.colorButtons, axis: .horizontal, distribution: .fillEqually, spacing: self.spacing)
        self.addSubview(stackView)
        stackView.leftAnchor == self.leftAnchor + 12
        stackView.centerYAnchor == self.centerYAnchor
        stackView.heightAnchor == self.buttonWidth
        if UIDevice.current.userInterfaceIdiom == .phone && colorOptions.count >= 5 {
            stackView.rightAnchor == self.undoButton.leftAnchor - 20
        }
        if !(UIDevice.current.userInterfaceIdiom == .phone && colorOptions.count >= 5) {
            self.colorButtons.forEach { $0.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth) }
        }
    }
    
    private func createColorButton(by option: EditorBrushColorOption, idx: Int) -> UIControl {
        switch option {
        case .custom(let color):
            let button = ColorButton(tag: idx, size: itemWidth, color: color, borderWidth: 2, borderColor: UIColor.white)
            button.isHidden = true
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }
    
    private(set) lazy var undoButton: UIButton = {
        let view = UIButton(type: .custom)
        view.isEnabled = false
        view.setImage(options.theme[icon: .photoToolUndo], for: .normal)
        view.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
}

// MARK: - Target
extension EditorBrushToolView {
    
    @objc private func undoButtonTapped(_ sender: UIButton) {
        delegate?.brushToolViewUndoButtonTapped(self)
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        if currentIdx != sender.tag {
            currentIdx = sender.tag
            layoutSubviews()
        }
        delegate?.brushToolView(self, colorDidChange: colorOptions[currentIdx].color)
    }
}
