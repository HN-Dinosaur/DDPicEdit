//
//  WaterMarkData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/30.
//

import UIKit

struct WaterMarkData: Codable, Equatable {
    
    var waterMarkContent: String = ""
    var waterMarkLocation: WaterMarkLocation = .none
    var fontSize: CGFloat = 70

}
