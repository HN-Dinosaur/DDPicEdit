//
//  EditorCropToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/12.
//

import UIKit
import Anchorage

protocol EditorCropToolViewDelegate: AnyObject {
    
    @discardableResult
    func cropToolView(_ toolView: EditorCropToolView, didClickCropOption option: EditorCropOption) -> Bool
    func cropToolViewCancelButtonTapped(_ cropToolView: EditorCropToolView)
    func cropToolViewDoneButtonTapped(_ cropToolView: EditorCropToolView)
    func cropToolViewResetButtonTapped(_ cropToolView: EditorCropToolView)
    @discardableResult
    func cropToolViewRotateButtonTapped(_ cropToolView: EditorCropToolView) -> Bool
}


final class EditorCropToolView: DDPicBaseView {
    
    weak var delegate: EditorCropToolViewDelegate?
    
    var currentOptionIdx: Int {
        get {
            if let idx = options.cropOptions.firstIndex(where: { $0 == currentOption }) {
                return idx
            }
            return 0
        } set {
            if newValue < options.cropOptions.count {
                currentOption = options.cropOptions[newValue]
            }
        }
    }
    var currentOption: EditorCropOption? = nil {
        didSet {
            let idx = currentOptionIdx
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(row: idx, section: 0), animated: true, scrollPosition: .left)
        }
    }
    
    private let options: EditorPhotoOptionsInfo
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        let contentLayoutGuide = UILayoutGuide()
        self.addLayoutGuide(contentLayoutGuide)
        self.recursiveAddSubView(views: [
            self.rotateButton,
            self.collectionView,
            self.line,
            self.cancelButton,
            self.doneButton,
            self.resetbutton
        ])
        
        self.rotateButton.isHidden = options.rotationDirection == .turnOff
        self.collectionView.isHidden = options.cropOptions.count <= 1
        
        self.rotateButton.leftAnchor == self.leftAnchor + 20
        self.rotateButton.bottomAnchor == self.line.topAnchor - 10
        self.rotateButton.sizeAnchors == CGSize(width: 40, height: 40)
        
        self.collectionView.verticalAnchors == self.rotateButton.verticalAnchors
        if self.options.rotationDirection == .turnOff {
            self.collectionView.leftAnchor == self.leftAnchor
        } else {
            self.collectionView.leftAnchor == self.rotateButton.rightAnchor + 10
        }
        self.collectionView.rightAnchor == self.rightAnchor
        self.collectionView.heightAnchor == 40
        
        contentLayoutGuide.horizontalAnchors == self.horizontalAnchors
        contentLayoutGuide.bottomAnchor == self.bottomAnchor
        contentLayoutGuide.heightAnchor == 60
        
        self.line.horizontalAnchors == contentLayoutGuide.horizontalAnchors
        self.line.topAnchor == contentLayoutGuide.topAnchor
        self.line.heightAnchor == 0.5
        
        self.cancelButton.leftAnchor == contentLayoutGuide.leftAnchor + 20
        self.cancelButton.centerYAnchor == contentLayoutGuide.centerYAnchor
        self.cancelButton.sizeAnchors == CGSize(width: 40, height: 40)
        
        self.doneButton.rightAnchor == contentLayoutGuide.rightAnchor - 20
        self.doneButton.centerYAnchor == contentLayoutGuide.centerYAnchor
        self.doneButton.sizeAnchors == CGSize(width: 40, height: 40)
        
        self.resetbutton.verticalAnchors == contentLayoutGuide.verticalAnchors
        self.resetbutton.centerXAnchor == contentLayoutGuide.centerXAnchor
        self.resetbutton.sizeAnchors == CGSize(width: 60, height: 60)
    }
    
    private(set) lazy var rotateButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(options.theme[icon: options.rotationDirection.iconKey], for: .normal)
        view.addTarget(self, action: #selector(rotateButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.registerCellClasses(classes: [EditorCropOptionCell.self])
        view.contentInset = UIEdgeInsets(top: 0, left: options.rotationDirection == .turnOff ? 20 : 0, bottom: 0, right: 20)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    private lazy var line: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
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
    private(set) lazy var resetbutton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle(options.theme[string: .reset], for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.setTitleColor(UIColor.lightGray, for: .highlighted)
        view.titleLabel?.font = UIFont.PingFang(size: 14)
        view.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
}

// MARK: - Target
extension EditorCropToolView {
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cropToolViewCancelButtonTapped(self)
    }
    
    @objc private func resetButtonTapped(_ sender: UIButton) {
        if currentOption == .free {
            delegate?.cropToolViewResetButtonTapped(self)
        } else {
            delegate?.cropToolView(self, didClickCropOption: currentOption ?? .free)
        }
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        delegate?.cropToolViewDoneButtonTapped(self)
    }
    
    @objc private func rotateButtonTapped(_ sender: UIButton) {
        let result = delegate?.cropToolViewRotateButtonTapped(self) ?? false
        guard result, let cropOption = currentOption else { return }
        if case let .custom(w, h) = cropOption {
            if let idx = options.cropOptions.firstIndex(of: .custom(w: h, h: w)) {
                currentOptionIdx = idx
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension EditorCropToolView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.cropOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EditorCropOptionCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.set(options, option: options.cropOptions[indexPath.row], selectColor: options.theme[color: .primary])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EditorCropToolView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentOption != options.cropOptions[indexPath.row] else { return }
        let nextOption = options.cropOptions[indexPath.row]
        let result = delegate?.cropToolView(self, didClickCropOption: nextOption) ?? false
        if result {
            currentOption = nextOption
        } else {
            collectionView.selectItem(at: IndexPath(row: currentOptionIdx, section: 0), animated: true, scrollPosition: .left)
        }
    }
}
