//
//  BrushData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import Foundation

struct BrushData: Codable, Equatable {
    
    let drawnPath: DrawnPath
    
    init(drawnPath: DrawnPath) {
        self.drawnPath = drawnPath
    }
}
