//
//  TextTrashView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/16.
//

import UIKit
import Anchorage

final class TextTrashView: DDPicBaseView {

    enum State {
        case idle
        case remove
    }
    
    var state: State = .idle {
        didSet {
            set(state: state)
        }
    }
    
    private let options: EditorPhotoOptionsInfo
    
    init(options: EditorPhotoOptionsInfo, frame: CGRect) {
        self.options = options
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = Palette.black.withAlphaComponent(0.8)
        addSubview(imageView)
        addSubview(label)
        self.recursiveAddSubView(views: [self.imageView, self.label])
        self.imageView.topAnchor == self.topAnchor + 15
        self.imageView.centerXAnchor == self.centerXAnchor
        self.imageView.sizeAnchors == CGSize(width: 25, height: 25)
        
        self.label.topAnchor == self.imageView.bottomAnchor + 15
        self.label.horizontalAnchors == self.horizontalAnchors - 10
    }
    
    private func set(state: State) {
        switch state {
        case .idle:
            backgroundColor = Palette.black.withAlphaComponent(0.9)
            label.text = options.theme[string: .editorDragHereToRemove]
        case .remove:
            backgroundColor = Palette.red.withAlphaComponent(0.9)
            label.text = options.theme[string: .editorReleaseToRemove]
        }
    }
    
    private(set) lazy var imageView = UIImageView(image: options.theme[icon: .trash])
    private(set) lazy var label = UILabel(text: options.theme[string: .editorDragHereToRemove], color: .white, textFont: UIFont.PingFang(size: 12), textAlignment: .center)
}
