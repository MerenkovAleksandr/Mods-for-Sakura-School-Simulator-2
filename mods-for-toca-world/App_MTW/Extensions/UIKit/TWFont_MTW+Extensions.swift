//
//  TWFont_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWFont_MTW = UIFont

extension TWFont_MTW {
    
    class func defaultFont(_ style: TWFonts_MTW.FontStyle,
                           size: CGFloat) -> UIFont {
        TWFonts_MTW.defaultFont(for: style, size: size)
    }
    
}
