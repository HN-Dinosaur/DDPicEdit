//
//  EditorPasterToolView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/5/6.
//

import UIKit
import Anchorage

protocol EditPasterToolViewDelegate: AnyObject {
    func pasterToolViewDidSelectPaster(_ pasterToolView: EditorPasterToolView, data: StickerData)
    func pasterToolViewCancelButtonTapped(_ pasterToolView: EditorPasterToolView)
    func pasterToolViewDoneButtonTapped(_ pasterToolView: EditorPasterToolView)
}

public class EditorPasterToolView: DDPicBaseView {
    
    public static let staticHeight: CGFloat = 215
    
    private let options: EditorPhotoOptionsInfo
    weak var delegate: EditPasterToolViewDelegate?
    public var stickers: [UIImage?] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    init(options: EditorPhotoOptionsInfo) {
        self.options = options
        super.init(frame: .zero)
        self.setupView()
        self.createDataSource()
    }
    
    private func createDataSource() {
        var images: [UIImage?] = []
        for i in 0...4 {
            images.append(UIImage(named: "sticker\(i)"))
        }
        self.stickers = images
    }
    
    private func setupView() {
        let contentLayoutGuide = UILayoutGuide()
        let line1 = UIView(backgroundColor: .white.withAlphaComponent(0.2))
        let line2 = UIView(backgroundColor: .white.withAlphaComponent(0.2))
        self.addLayoutGuide(contentLayoutGuide)
        self.recursiveAddSubView(views: [
            self.titleLabel,
            line1,
            line2,
            self.collectionView,
            self.cancelButton,
            self.doneButton,
        ])
        
        self.titleLabel.leftAnchor == self.leftAnchor + 10
        self.titleLabel.topAnchor == self.topAnchor + 10
        
        line1.horizontalAnchors == self.horizontalAnchors
        line1.bottomAnchor == self.titleLabel.bottomAnchor + 5
        line1.heightAnchor == 0.5
        
        self.collectionView.horizontalAnchors == self.horizontalAnchors
        self.collectionView.topAnchor == line1.bottomAnchor + 5
        self.collectionView.heightAnchor == 115
        
        contentLayoutGuide.horizontalAnchors == self.horizontalAnchors
        contentLayoutGuide.bottomAnchor == self.bottomAnchor
        contentLayoutGuide.heightAnchor == 60
        
        line2.horizontalAnchors == contentLayoutGuide.horizontalAnchors
        line2.topAnchor == contentLayoutGuide.topAnchor
        line2.heightAnchor == 0.5
        
        self.cancelButton.leftAnchor == contentLayoutGuide.leftAnchor + 20
        self.cancelButton.centerYAnchor == contentLayoutGuide.centerYAnchor
        self.cancelButton.sizeAnchors == CGSize(width: 40, height: 40)
        
        self.doneButton.rightAnchor == contentLayoutGuide.rightAnchor - 20
        self.doneButton.centerYAnchor == contentLayoutGuide.centerYAnchor
        self.doneButton.sizeAnchors == CGSize(width: 40, height: 40)
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        delegate?.pasterToolViewCancelButtonTapped(self)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        delegate?.pasterToolViewDoneButtonTapped(self)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 115)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCellClasses(classes: [EditorStickerCell.self])
        return collectionView
    }()
    
    private lazy var titleLabel = UILabel(text: options.theme[string: .editorSticker], color: .white, textFont: .PingFangSemibold(size: 14))
    
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

extension EditorPasterToolView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stickers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EditorStickerCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.setImage(self.stickers[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let data = StickerData()
        if let selectImage = self.stickers[indexPath.item] {
            data.imageData = selectImage.pngData() ?? Data()
        }
        self.delegate?.pasterToolViewDidSelectPaster(self, data: data)
    }
    
}
