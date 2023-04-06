//
//  DeviceIOComponent.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/4.
//

import AVFoundation

class DeviceIOComponent: NSObject {
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
}

// MARK: - Device Property
extension DeviceIOComponent {
    
    func updateProperty(_ change: (AVCaptureDevice) -> Void) {
        guard let device = device else { return }
        do {
            try device.lockForConfiguration()
            change(device)
            device.unlockForConfiguration()
        } catch {
            _print(error.localizedDescription)
        }
    }
}

