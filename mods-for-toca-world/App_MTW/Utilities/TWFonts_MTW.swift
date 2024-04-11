//
//  TWFonts_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWFonts_MTW {
    
    enum FontStyle: String {
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case bold = "Bold"
        case extraBold = "ExtraBold"
    }
    
    class func defaultFont(for style: FontStyle, size: CGFloat) -> UIFont {
        .init(name: .init(format: "Anton-Regular", style.rawValue), size: size)!
    }
    
    class func notoSansFont(for style: FontStyle, size: CGFloat) -> UIFont {
        .init(name: .init(format: "Anton-Regular", style.rawValue), size: size)!
    }
    
    class func knicknackFont(for style: FontStyle, size: CGFloat) -> UIFont {
        .init(name: .init(format: "Knicknack-Regular", style.rawValue), size: size)!
    }
    
}
