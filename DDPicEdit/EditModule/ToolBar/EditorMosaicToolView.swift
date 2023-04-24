//
//  EditorMosaicToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

protocol EditorMosaicToolViewDelegate: AnyObject {
    
    func mosaicToolView(_ mosaicToolView: EditorMosaicToolView, mosaicDidChange idx: Int)
    
    func mosaicToolViewUndoButtonTapped(_ mosaicToolView: EditorMosaicToolView)
}

final class EditorMosaicToolView: DDPicBaseView {
    
    weak var delegate: EditorMosaicToolViewDelegate?
    
    private(set) var currentIdx: Int = 0
    
    private let options: EditorPhotoOptionsInfo
    private var mosaicButtons: [UIButton] = []
    private let spacing: CGFloat = 40
    private let itemWidth: CGFloat = 22
    private let buttonWidth: CGFloat = 34
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.options = options
        self.currentIdx = options.defaultMosaicIndex
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(self.undoButton)
        self.undoButton.rightAnchor == self.rightAnchor - 8
        self.undoButton.centerYAnchor == self.centerYAnchor
        self.undoButton.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth)
        
        self.setupMosaicView()
        self.updateState()
        
    }
    
    private func setupMosaicView() {
        for (idx, option) in options.mosaicOptions.enumerated() {
            self.mosaicButtons.append(createMosaicButton(option, idx: idx))
        }
        
        let stackView = UIStackView(arrangedSubviews: self.mosaicButtons, distribution: .equalSpacing, spacing: spacing)
        stackView.isHidden = self.options.mosaicOptions.count <= 1
        self.addSubview(stackView)
        let width = self.itemWidth * CGFloat(self.mosaicButtons.count) + self.spacing * CGFloat(self.mosaicButtons.count - 1)
        let offset = (UIScreen.main.bounds.width - width - 20 * 2 - 20) / 2
        stackView.leftAnchor == self.leftAnchor + offset
        stackView.centerYAnchor == self.centerYAnchor
        stackView.heightAnchor == self.buttonWidth
        
        self.mosaicButtons.forEach { $0.sizeAnchors == CGSize(width: self.buttonWidth, height: self.buttonWidth) }
    }
    
    private func createMosaicButton(_ option: EditorMosaicOption, idx: Int) -> UIButton {
        let image: UIImage?
        switch option {
        case .`default`:
            image = options.theme[icon: .photoToolMosaicDefault]?.withRenderingMode(.alwaysTemplate)
        case .custom(let customMosaicIcon, let customMosaic):
            image = customMosaicIcon ?? customMosaic
        }
        let inset = (buttonWidth - itemWidth) / 2
        let button = UIButton(type: .custom)
        button.tag = idx
        button.tintColor = .white
        button.clipsToBounds = true
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.imageView?.layer.cornerRadius = option == .default ? 0 : 2
        button.imageView?.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(mosaicButtonTapped(_:)), for: .touchUpInside)
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

// MARK: - Public function
extension EditorMosaicToolView {
    
    func setMosaicIdx(_ idx: Int) {
        guard idx < mosaicButtons.count else { return }
        self.mosaicButtonTapped(mosaicButtons[idx])
    }
}

// MARK: - Private function
extension EditorMosaicToolView {
    
    private func updateState() {
        let option = self.options.mosaicOptions[self.currentIdx]
        switch option {
        case .`default`:
            self.mosaicButtons.forEach {
                $0.tintColor = self.options.theme[color: .primary]
                $0.imageView?.layer.borderWidth = 0
            }
        default:
            for (idx, button) in mosaicButtons.enumerated() {
                button.tintColor = .white
                button.imageView?.layer.borderWidth = idx == currentIdx ? 2 : 0
            }
        }
    }
}

// MARK: - Target
extension EditorMosaicToolView {
    
    @objc private func mosaicButtonTapped(_ sender: UIButton) {
        if self.currentIdx != sender.tag {
            self.currentIdx = sender.tag
            self.layoutSubviews()
        }
        self.delegate?.mosaicToolView(self, mosaicDidChange: currentIdx)
        self.updateState()
    }
    
    @objc private func undoButtonTapped(_ sender: UIButton) {
        self.delegate?.mosaicToolViewUndoButtonTapped(self)
    }
}
