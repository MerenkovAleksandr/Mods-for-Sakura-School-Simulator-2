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
        .init(name: .init(format: "Baloo2-%@", style.rawValue), size: size)!
    }
    
}
