//
//  TWAttributedString_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWAttributedString_MTW = NSAttributedString

extension TWAttributedString_MTW {
    
    class var iPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    class func compose(localizedString: String,
                       kern: CGFloat,
                       font: UIFont,
                       paragraphStyle: NSParagraphStyle,
                       foregroundcolor: UIColor) -> NSAttributedString {
        .init(string: localizedString,
              attributes: [.kern: kern,
                           .font: font,
                           .paragraphStyle: paragraphStyle,
                           .foregroundColor: foregroundcolor])
    }
    
}
