//
//  ImageCaptureController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/30.
//

import UIKit

public protocol ImageCaptureControllerDelegate: AnyObject {
    
    func imageCaptureDidCancel(_ capture: ImageCaptureController)
    func imageCapture(_ capture: ImageCaptureController, didFinishCapturing result: CaptureResult)
}

extension ImageCaptureControllerDelegate {
    
    public func imageCaptureDidCancel(_ capture: ImageCaptureController) {
        capture.dismiss(animated: true, completion: nil)
    }
}

open class ImageCaptureController: DDPicBaseNaviController {
    
    open weak var captureDelegate: ImageCaptureControllerDelegate?
    
    init(options: CaptureOptionsInfo, delegate: ImageCaptureControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.captureDelegate = delegate
        self.update(options: options)
    }
    
    open func update(options: CaptureOptionsInfo) {
        guard viewControllers.isEmpty else { return }
        enableDebugLog = options.enableDebugLog
        let rootViewController = CaptureViewController(options: options)
        rootViewController.delegate = self
        rootViewController.trackObserver = self
        viewControllers = [rootViewController]
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        var didDismiss = false
        if let _ = presentedViewController as? ImageEditorController {
            didDismiss = true
            presentingViewController?.dismiss(animated: flag, completion: completion)
        }
        if !didDismiss {
            if let _ = presentedViewController as? UIImagePickerController {
                presentingViewController?.dismiss(animated: flag, completion: completion)
            } else {
                super.dismiss(animated: flag, completion: completion)
            }
        }
    }
}

// MARK: - CaptureViewControllerDelegate
extension ImageCaptureController: CaptureViewControllerDelegate {
    
    func captureDidCancel(_ capture: CaptureViewController) {
        captureDelegate?.imageCaptureDidCancel(self)
    }
    
    func capture(_ capture: CaptureViewController, didOutput mediaURL: URL, type: MediaType) {
        let result = CaptureResult(mediaURL: mediaURL, type: type)
        captureDelegate?.imageCapture(self, didFinishCapturing: result)
    }
}
