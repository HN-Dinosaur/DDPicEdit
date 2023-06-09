//
//  DeviceOrientationUtil.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/2.
//

import CoreMotion

protocol DeviceOrientationUtilDelegate: AnyObject {
    
    func device(_ util: DeviceOrientationUtil, didUpdate orientation: DeviceOrientation)
    
}

final class DeviceOrientationUtil {
    
    weak var delegate: DeviceOrientationUtilDelegate?
    
    private(set) var orientation: DeviceOrientation = .portrait

    private lazy var queue: OperationQueue = OperationQueue()
    
    init(delegate: DeviceOrientationUtilDelegate) {
        self.delegate = delegate
    }
    
    func startRunning() {
        let motionLimit: Double = 0.6
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            let newOrientation: DeviceOrientation
            if data.acceleration.x >= motionLimit {
                newOrientation = .landscapeRight
            } else if data.acceleration.x <= -motionLimit {
                newOrientation = .landscapeLeft
            } else if data.acceleration.y <= -motionLimit {
                newOrientation = .portrait
            } else if data.acceleration.y >= motionLimit {
                newOrientation = .portraitUpsideDown
            } else {
                return
            }
            if newOrientation != self.orientation {
                self.orientation = newOrientation
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.device(self, didUpdate: newOrientation)
                }
            }
        }
    }
    
    func stopRunning() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private lazy var motionManager: CMMotionManager = {
        let manager = CMMotionManager()
        manager.accelerometerUpdateInterval = 0.2
        return manager
    }()
}
