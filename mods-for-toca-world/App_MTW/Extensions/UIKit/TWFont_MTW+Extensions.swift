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
    
    class func notoSantFont(_ style: TWFonts_MTW.FontStyle,
                           size: CGFloat) -> UIFont {
        TWFonts_MTW.notoSansFont(for: style, size: size)
    }
    
    class func knicknackFont(_ style: TWFonts_MTW.FontStyle,
                           size: CGFloat) -> UIFont {
        TWFonts_MTW.knicknackFont(for: style, size: size)
    }
    
}
