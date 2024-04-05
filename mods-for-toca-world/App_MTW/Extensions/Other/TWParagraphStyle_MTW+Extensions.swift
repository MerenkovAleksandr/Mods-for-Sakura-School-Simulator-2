//
//  TWParagraphStyle_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWParagraphStyle_MTW = NSParagraphStyle

extension TWParagraphStyle_MTW {
    
    class var centered: NSParagraphStyle { .centered() }
    
    class func aligned(_ alignment: NSTextAlignment,
                       lineSpacing: CGFloat? = nil,
                       lineBrakeMode: NSLineBreakMode? = nil,
                       lineHeightMultiple: CGFloat? = nil) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = alignment
        
        if let lineSpacing { paragraphStyle.lineSpacing = lineSpacing }
        if let lineBrakeMode { paragraphStyle.lineBreakMode = lineBrakeMode }
        if let lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        
        return paragraphStyle
    }
    
    class func centered(lineSpacing: CGFloat? = nil,
                        lineBrakeMode: NSLineBreakMode? = nil,
                        lineHeightMultiple: CGFloat? = nil) -> NSParagraphStyle {
        .aligned(.center,
                 lineSpacing: lineSpacing,
                 lineBrakeMode: lineBrakeMode,
                 lineHeightMultiple: lineHeightMultiple)
    }
    
}
