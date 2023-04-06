//
//  CaptureResultViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/6.
//

import UIKit
import Anchorage

class CaptureResultViewController: DDPicBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.resultImageView)
        self.view.backgroundColor = .white
        self.resultImageView.centerAnchors == self.view.centerAnchors
        self.resultImageView.widthAnchor == self.resultImageView.heightAnchor
    }
    
    public lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

