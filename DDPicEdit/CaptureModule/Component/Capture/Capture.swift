//
//  Capture.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import AVFoundation
import UIKit

protocol CaptureDelegate: AnyObject {
    func captureDidCapturePhoto(_ capture: Capture)
    func captureDidChangeSubjectArea(_ capture: Capture)
    func capture(_ capture: Capture, didUpdate videoProperty: VideoIOComponent.ObservableProperty)
    func capture(_ capture: Capture, didOutput photoData: Data, fileType: FileType)
    func capture(_ capture: Capture, didOutput sampleBuffer: CMSampleBuffer, type: CaptureBufferType)
}

final class Capture {
    
    weak var delegate: CaptureDelegate?
    
    private let options: CaptureOptionsInfo
    private let session: AVCaptureSession
    private let videoIO: VideoIOComponent
    
    var orientation: DeviceOrientation = .portrait
    var isSwitchingCamera = false
    
    init(options: CaptureOptionsInfo, delegate: CaptureDelegate) {
        self.options = options
        self.delegate = delegate
        self.session = AVCaptureSession()
        self.session.beginConfiguration()
        self.videoIO = VideoIOComponent(session: session, options: options)
        self.session.commitConfiguration()
        self.videoIO.delegate = self
    }
    
    func startRunning() {
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
    
    func stopRunning() {
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    
    func startSwitchCamera() {
        isSwitchingCamera = true
        session.beginConfiguration()
        videoIO.switchCamera(session: session)
        session.commitConfiguration()
    }
    
    func stopSwitchCamera() {
        isSwitchingCamera = false
    }
    
    func zoom(_ scale: CGFloat = 1.0) {
        var zoomFactor = videoIO.zoomFactor*scale
        let minZoomFactor = videoIO.minZoomFactor
        let maxZoomFactor = videoIO.maxZoomFactor
        if zoomFactor < minZoomFactor {
            zoomFactor = minZoomFactor
        }
        if zoomFactor > maxZoomFactor {
            zoomFactor = maxZoomFactor
        }
        videoIO.setZoomFactor(zoomFactor)
    }
    
    func focus(at point: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        videoIO.setFocus(point: point)
    }
    
    func exposure(at point: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        videoIO.setExposure(point: point)
    }
    
    func capturePhoto() {
        videoIO.capturePhoto(orientation: orientation)
    }
    
    func exposure(bias level: CGFloat) {
        let level = Float(level)
        let base: Float = 0.0
        let newBias: Float
        if level < 0.5 { // [minExposureTargetBias, exposureBiasBaseline)
            let systemMin = videoIO.minExposureTargetBias
            let avaiableRange: Float = 0.5
            let min = systemMin + (base-systemMin)*avaiableRange
            newBias = min + (base-min)*(level/0.5)
        } else { // [exposureBiasBaseline, maxExposureTargetBias]
            let systemMax = videoIO.maxExposureTargetBias
            let avaiableRange: Float = 0.4
            let max = base + (systemMax-base)*avaiableRange
            newBias = base + (max - base)*((level-0.5)/0.5)
        }
        videoIO.setExposure(bias: newBias)
    }
}

extension Capture: VideoIOComponentDelegate {
    
    func videoIODidCapturePhoto(_ component: VideoIOComponent) {
        delegate?.captureDidCapturePhoto(self)
    }
    
    func videoIODidChangeSubjectArea(_ component: VideoIOComponent) {
        delegate?.captureDidChangeSubjectArea(self)
    }
    
    func videoIO(_ component: VideoIOComponent, didUpdate property: VideoIOComponent.ObservableProperty) {
        delegate?.capture(self, didUpdate: property)
    }
    
    func videoIO(_ component: VideoIOComponent, didOutput photoData: Data, fileType: FileType) {
        delegate?.capture(self, didOutput: photoData, fileType: fileType)
    }
    
    func videoIO(_ component: VideoIOComponent, didOutput sampleBuffer: CMSampleBuffer) {
        guard !isSwitchingCamera else { return }
        delegate?.capture(self, didOutput: sampleBuffer, type: .video)
    }
    
}
