//
//  EditorEditOptionsView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

protocol EditorEditOptionsViewDelegate: AnyObject {
    
    @discardableResult
    func editOptionsView(_ editOptionsView: EditorEditOptionsView, optionWillChange option: EditorPhotoToolOption?) -> Bool
}

final class EditorEditOptionsView: DDPicBaseView {
    
    weak var delegate: EditorEditOptionsViewDelegate?
    
    private(set) var currentOption: EditorPhotoToolOption?
    
    private let options: EditorPhotoOptionsInfo
    private var buttons: [UIButton] = []
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView() {
        for (idx, option) in self.options.toolOptions.enumerated() {
            self.buttons.append(self.createButton(tag: idx, option: option))
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons, distribution: .fillEqually)
        self.addSubview(stackView)
        stackView.horizontalAnchors == self.horizontalAnchors
        stackView.leftAnchor == self.leftAnchor + 12
        
        // MARK: -未对stackView高度设置
        self.buttons.forEach {
            $0.heightAnchor == stackView.heightAnchor
            $0.widthAnchor == stackView.heightAnchor
        }
    }
    
    private func createButton(tag: Int, option: EditorPhotoToolOption) -> UIButton {
        let button = UIButton(type: .custom)
        let image = options.theme[icon: option.iconKey]?.withRenderingMode(.alwaysTemplate)
        button.tag = tag
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func selectButton(_ button: UIButton) {
        self.currentOption = self.options.toolOptions[button.tag]
        for btn in buttons {
            let isSelected = btn == button
            btn.isSelected = isSelected
            btn.imageView?.tintColor = isSelected ? options.theme[color: .primary] : .white
        }
    }
}

// MARK: - Target
extension EditorEditOptionsView {
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let nextOption: EditorPhotoToolOption?
        if let current = currentOption, options.toolOptions[sender.tag] == current {
            nextOption = nil
        } else {
            nextOption = options.toolOptions[sender.tag]
        }

        let result = delegate?.editOptionsView(self, optionWillChange: nextOption) ?? false
        guard result else { return }
        if nextOption == nil {
            unselectButtons()
        } else {
            selectButton(sender)
        }
    }
}

// MARK: - Public function
extension EditorEditOptionsView {
    
    public func selectFirstItemIfNeeded() {
        if currentOption == nil && options.toolOptions.count == 1 && options.toolOptions.first! != .text {
            buttonTapped(buttons.first!)
        }
    }
    
    func unselectButtons() {
        self.currentOption = nil
        for button in buttons {
            button.isSelected = false
            button.imageView?.tintColor = .white
        }
    }
}
