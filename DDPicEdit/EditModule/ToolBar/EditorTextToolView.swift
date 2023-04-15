//
//  EditorTextToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

protocol EditorTextToolViewDelegate: AnyObject {
    
    func textToolView(_ toolView: EditorTextToolView, textButtonTapped isSelected: Bool)
    func textToolView(_ toolView: EditorTextToolView, colorDidChange idx: Int)
}

final class EditorTextToolView: DDPicBaseView {
    
    weak var delegate: EditorTextToolViewDelegate?
    private var currentIdx: Int = 0
    private let options: EditorPhotoOptionsInfo
    private let colorOptions: [EditorTextColor]
    private var colorButtons: [ColorButton] = []
    private let spacing: CGFloat = 10
    private let itemWidth: CGFloat = 24
    private let buttonWidth: CGFloat = 34
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo, idx: Int, isTextSelected: Bool) {
        self.options = options
        self.colorOptions = options.textColors
        self.currentIdx = idx
        super.init(frame: frame)
        self.setupView()
        self.textButton.isSelected = isTextSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (idx, colorButton) in self.colorButtons.enumerated() {
            let scale: CGFloat = idx == self.currentIdx ? 1.25 : 1.0
            colorButton.colorView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let colorButtonRight = 56 + CGFloat(idx) * spacing + CGFloat(idx + 1) * itemWidth
            colorButton.isHidden = colorButtonRight > (bounds.width - 20)
        }
    }
    
    private func setupView() {
        self.addSubview(self.textButton)
        self.setupColorView()
        self.textButton.leftAnchor == self.leftAnchor + 12
        self.textButton.centerYAnchor == self.centerYAnchor
        self.textButton.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth)
    }
    
    private func setupColorView() {
        for (idx, color) in self.colorOptions.enumerated() {
            self.colorButtons.append(self.createColorView(color, idx: idx))
        }
        let stackView = UIStackView(arrangedSubviews: colorButtons, distribution: .fillEqually, spacing: self.spacing)
        self.addSubview(stackView)
        stackView.leftAnchor == self.textButton.rightAnchor + 12
        stackView.centerYAnchor == self.centerYAnchor
        stackView.heightAnchor == self.buttonWidth
        if UIDevice.current.userInterfaceIdiom == .phone && colorOptions.count >= 5 {
            stackView.rightAnchor == self.rightAnchor - 20
        }
        
        if !(UIDevice.current.userInterfaceIdiom == .phone && colorOptions.count >= 5) {
            self.colorButtons.forEach { $0.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth) }
        }
    }
    
    private func createColorView(_ color: EditorTextColor, idx: Int) -> ColorButton {
        let view = ColorButton(tag: idx, size: itemWidth, color: color.color)
        view.isHidden = true
        view.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        return view
    }
    
    private lazy var textButton: UIButton = {
        let view = UIButton(type: .custom)
        view.isSelected = true
        view.setImage(options.theme[icon: .textNormalIcon], for: .normal)
        view.setImage(options.theme[icon: .photoToolText], for: .selected)
        view.addTarget(self, action: #selector(textButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
}

// MARK: - Target
extension EditorTextToolView {
    
    @objc private func textButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.textToolView(self, textButtonTapped: sender.isSelected)
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        if currentIdx != sender.tag {
            currentIdx = sender.tag
            self.layoutSubviews()
            delegate?.textToolView(self, colorDidChange: sender.tag)
        }
    }
}
