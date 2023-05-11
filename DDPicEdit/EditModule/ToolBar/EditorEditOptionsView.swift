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
    private(set) var currentSelectIndexpath: IndexPath?
    private let options: EditorPhotoOptionsInfo
    
    init(frame: CGRect, options: EditorPhotoOptionsInfo) {
        self.options = options
        super.init(frame: frame)
        self.setupView()
    }
    
    private func setupView() {
        self.addSubview(collectionView)
        self.collectionView.verticalAnchors == self.verticalAnchors
        self.collectionView.leftAnchor == self.leftAnchor + 12
        self.collectionView.rightAnchor == self.rightAnchor
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = EditorEditOptionsCell.staticSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.registerCellClasses(classes: [EditorEditOptionsCell.self])
        return view
    }()
}

extension EditorEditOptionsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.options.toolOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EditorEditOptionsCell = collectionView.dequeueCell(indexPath: indexPath)
        let option = self.options.toolOptions[indexPath.item]
        cell.updateData(options.theme[icon: option.iconKey]?.withRenderingMode(.alwaysTemplate))
        cell.contentImageView.tintColor = self.currentSelectIndexpath == indexPath ? options.theme[color: .primary] : .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let nextIndexpath: IndexPath?
        if let currentIndexpath = self.currentSelectIndexpath, currentIndexpath == indexPath {
            nextIndexpath = nil
        } else {
            nextIndexpath = indexPath
        }
        let result = delegate?.editOptionsView(self, optionWillChange: nextIndexpath == nil ? nil : self.options.toolOptions[nextIndexpath!.item]) ?? false
        guard result else { return }
        if nextIndexpath == nil {
            unselectButtons()
        } else {
            selectButtons(indexPath)
        }
    }
}

// MARK: - Public function
extension EditorEditOptionsView {
    
    public func selectFirstItemIfNeeded() {
        if currentOption == nil && options.toolOptions.count == 1 && options.toolOptions.first! != .text {
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    func selectButtons(_ indexPath: IndexPath) {
        self.currentOption = self.options.toolOptions[indexPath.item]
        self.currentSelectIndexpath = indexPath
        self.collectionView.reloadData()
    }
    
    func unselectButtons() {
        self.currentSelectIndexpath = nil
        self.collectionView.reloadData()
    }
}
