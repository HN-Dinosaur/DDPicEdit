//
//  CaptureWhiteBalance.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/5.
//

import AVFoundation

struct CaptureWhiteBalance: Equatable {
    
    var temperature: Float
    var tint: Float
    
    init(temperature: Float, tint: Float) {
        self.temperature = temperature
        self.tint = tint
    }
    
    init(_ values: AVCaptureDevice.WhiteBalanceTemperatureAndTintValues) {
        self.init(temperature: values.temperature, tint: values.tint)
    }
}
