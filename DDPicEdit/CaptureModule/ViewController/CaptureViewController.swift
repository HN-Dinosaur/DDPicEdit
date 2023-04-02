//
//  CaptureViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import UIKit

protocol CaptureViewControllerDelegate: AnyObject {

    func captureDidCancel(_ capture: CaptureViewController)
    func capture(_ capture: CaptureViewController, didOutput mediaURL: URL, type: MediaType)

}

public class CaptureViewController: DDPicBaseViewController {
    
    weak var delegate: CaptureViewControllerDelegate?
    
}
