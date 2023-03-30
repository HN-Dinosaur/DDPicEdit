//
//  DDPicBaseViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

class DDPicBaseViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool { isStatusBarHidden }
    
    public func updateStatusBarHidden(isStatusBarHidden: Bool) {
        self.isStatusBarHidden = isStatusBarHidden
    }
}
