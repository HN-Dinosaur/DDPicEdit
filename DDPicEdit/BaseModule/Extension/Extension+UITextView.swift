//
//  Extension+UITextView.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/19.
//

import UIKit

extension UITextView {
    
    /// 计算行数
    func getSeparatedLines() -> [String] {
        var linesArray: [String] = []
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText)
        let path = CGMutablePath()
        
        // size needs to be adjusted, because frame might change because of intelligent word wrapping of iOS
        let size = sizeThatFits(CGSize(width: self.frame.width, height: .greatestFiniteMagnitude))
        path.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height + 50), transform: .identity)
        
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attributedText.length), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else { return linesArray }
        for line in lines {
            let lineRef = line as! CTLine
            let lineRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
}
