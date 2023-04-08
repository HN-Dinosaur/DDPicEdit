//
//  EditorTextColor.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/8.
//

import UIKit

/// Text color
///
/// There are two display styles for each text color element.
/// One is no background color, the text color is main color.
/// The other is that the background color is main color, and the text color is sub color(usually is white).
public struct EditorTextColor: Equatable, Hashable {
    
    /// Main color
    public let color: UIColor
    
    /// Sub color
    public let subColor: UIColor
    
    /// Shadow of first style
    public let shadow: Shadow?
    
    public init(color: UIColor, subColor: UIColor, shadow: Shadow? = nil) {
        self.color = color
        self.subColor = subColor
        self.shadow = shadow
    }
}
