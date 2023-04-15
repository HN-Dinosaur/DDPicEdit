//
//  MosaicData.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

struct MosaicData: Codable, Equatable {
    
    let idx: Int
    let drawnPaths: [DrawnPath]
    
    init(idx: Int, drawnPaths: [DrawnPath]) {
        self.idx = idx
        self.drawnPaths = drawnPaths
    }
}
