//
//  CapturePreviewContentView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/3.
//

import UIKit
import CoreMedia
import AVFoundation

final class CapturePreviewContentView: UIView {
    
    var displayLayer: AVSampleBufferDisplayLayer {
        layer as! AVSampleBufferDisplayLayer
    }
    
    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }
    
    func clear() {
        Thread.runOnMain {
            self.displayLayer.flushAndRemoveImage()
        }
    }
    
    func draw(sampleBuffer: CMSampleBuffer) {
        Thread.runOnMain {
            self.displayLayer.enqueue(sampleBuffer)
        }
    }
}
