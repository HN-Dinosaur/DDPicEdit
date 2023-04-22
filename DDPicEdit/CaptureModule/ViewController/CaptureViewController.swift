//
//  CaptureViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/1.
//

import UIKit
import AVFoundation
import Anchorage

protocol CaptureViewControllerDelegate: AnyObject {

    func captureDidCancel(_ capture: CaptureViewController)
    func capture(_ capture: CaptureViewController, didOutput mediaURL: URL, type: MediaType)

}

public class CaptureViewController: DDPicBaseViewController {
    
    weak var delegate: CaptureViewControllerDelegate?
    private var permissionsChecked: Bool = false
    private let options: CaptureOptionsInfo
    
    init(options: CaptureOptionsInfo) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    public override var prefersStatusBarHidden: Bool { true }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        var permissions: [Permission] = [.camera]
        if options.mediaOptions.contains(.video) {
            permissions.append(.micphone)
        }
        self.check(permissions: permissions, stringConfig: options.theme) { [weak self] in
            guard let self = self else { return }
            self.permissionsChecked = true
            self.orientationUtil.startRunning()
            self.capture.startRunning()
        } canceled: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.captureDidCancel(self)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tipsView.showTips(hideAfter: 3, animated: true)
        if permissionsChecked {
            self.captureAutoFocus()
        }
    }
    
    private func captureAutoFocus() {
        self.capture.focus()
        self.capture.exposure()
        self.previewView.autoFocus()
    }
    
    private func setupView() {
        self.view.backgroundColor = .black
        let layoutGuide = UILayoutGuide()
        self.view.addLayoutGuide(layoutGuide)
        self.view.recursiveAddSubView(views: [self.previewView, self.toolView, self.tipsView])
        self.previewView.horizontalAnchors == self.view.horizontalAnchors
        self.previewView.widthAnchor == self.previewView.heightAnchor * (9.0 / 16.0)
        self.previewView.centerAnchors == self.view.centerAnchors
        
        layoutGuide.horizontalAnchors == self.view.horizontalAnchors
        layoutGuide.centerAnchors == self.view.centerAnchors
        layoutGuide.widthAnchor == layoutGuide.heightAnchor * (9.0 / 16.0)
        
        self.toolView.horizontalAnchors == self.view.horizontalAnchors
        self.toolView.bottomAnchor == layoutGuide.bottomAnchor
        self.toolView.heightAnchor == 88
        
        self.tipsView.centerXAnchor == self.view.centerXAnchor
        self.tipsView.bottomAnchor == self.toolView.topAnchor - 8
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc
    private func cancelButtonTapped(_ sender: UIButton) {
        self.delegate?.captureDidCancel(self)
        self.trackObserver?.track(event: .captureCancel, userInfo: [:])
    }
    
    @objc
    private func switchButtonTapped(_ sender: UIButton) {
        self.impactFeedback()
        self.toolView.hideButtons(animated: true)
        self.previewView.transitionFlip(isIn: sender.isSelected, stopPreview: { [weak self] in
            guard let self = self else { return }
            self.capture.startSwitchCamera()
        }, startPreview: { [weak self] in
            guard let self = self else { return }
            self.capture.stopSwitchCamera()
        }) { [weak self] in
            guard let self = self else { return }
            self.toolView.showButtons(animated: true)
        }
        sender.isSelected.toggle()
        trackObserver?.track(event: .captureSwitchCamera, userInfo: [:])
    }
    
    // MARK: - Impact Feedback
    @objc
    private func impactFeedback() {
        if #available(iOS 13.0, *) {
            do {
                try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
            } catch {
                print("error")
            }
            let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
        } else {
            
        }
    }
    
    private lazy var orientationUtil = DeviceOrientationUtil(delegate: self)
    private lazy var previewView = CapturePreviewView(frame: .zero, options: options, delegate: self)
    private lazy var capture = Capture(options: options, delegate: self)
    private lazy var tipsView: CaptureTipsView = {
        let view = CaptureTipsView(frame: .zero, options: options)
        view.isHidden = true
        return view
    }()
    private lazy var toolView: CaptureToolView = {
        let view = CaptureToolView(frame: .zero, options: options)
        view.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        view.switchButton.addTarget(self, action: #selector(switchButtonTapped(_:)), for: .touchUpInside)
        view.switchButton.isHidden = options.preferredPositions.count <= 1
        view.captureButton.delegate = self
        return view
    }()
}

extension CaptureViewController: CaptureDelegate {
    func captureDidCapturePhoto(_ capture: Capture) {
        self.previewView.isRunning = false
    }
    
    func captureDidChangeSubjectArea(_ capture: Capture) {
        self.captureAutoFocus()
    }
    
    func capture(_ capture: Capture, didUpdate videoProperty: VideoIOComponent.ObservableProperty) { }
    
    func capture(_ capture: Capture, didOutput photoData: Data, fileType: FileType) {
        self.trackObserver?.track(event: .capturePhoto, userInfo: [:])
        guard let image = UIImage(data: photoData) else { return }
        var editorOptions = options.editorPhotoOptions
        editorOptions.enableDebugLog = options.enableDebugLog
        
        let controller = ImageEditorController(photo: image, options: editorOptions, delegate: self)
        present(controller, animated: false) { [weak self] in
            guard let self = self else { return }
            self.capture.stopRunning()
            self.orientationUtil.stopRunning()
        }
    }
    
    func capture(_ capture: Capture, didOutput sampleBuffer: CMSampleBuffer, type: CaptureBufferType) {
        if type == .video {
            self.previewView.draw(sampleBuffer)
        }
    }

}

extension CaptureViewController: CapturePreviewViewDelegate {
    func previewView(_ previewView: CapturePreviewView, didFocusAt point: CGPoint) {
        self.capture.focus(at: point)
        self.capture.exposure(at: point)
    }
    
    func previewView(_ previewView: CapturePreviewView, didUpdateExposure level: CGFloat) {
        self.capture.exposure(bias: 1 - level)
    }
    
    func previewView(_ previewView: CapturePreviewView, didPinchWith scale: CGFloat) {
        self.capture.zoom(scale)
    }
}

extension CaptureViewController: CaptureButtonDelegate {
    
    func captureButtonDidTapped(_ button: CaptureButton) {
        guard !capture.isSwitchingCamera else { return }
        impactFeedback()
        capture.capturePhoto()
    }
    
    func captureButtonDidBeganLongPress(_ button: CaptureButton) {
        // no implement
    }
    
    func captureButtonDidEndedLongPress(_ button: CaptureButton) {
        // no implement
    }
    
}

// MARK: - DeviceOrientationUtilDelegate
extension CaptureViewController: DeviceOrientationUtilDelegate {
    func device(_ util: DeviceOrientationUtil, didUpdate orientation: DeviceOrientation) {
        capture.orientation = orientation
        toolView.rotate(to: orientation, animated: true)
        previewView.rotate(to: orientation, animated: true)
    }
}

// MARK: - ImageEditorControllerDelegate
extension CaptureViewController: ImageEditorControllerDelegate {
    
    public func imageEditorDidCancel(_ editor: ImageEditorController) {
        capture.startRunning()
        orientationUtil.startRunning()
        previewView.isRunning = true
        editor.dismiss(animated: false, completion: nil)
    }
    
    public func imageEditor(_ editor: ImageEditorController, didFinishEditing result: EditorResult) {
        delegate?.capture(self, didOutput: result.mediaURL, type: result.type)
    }
}
