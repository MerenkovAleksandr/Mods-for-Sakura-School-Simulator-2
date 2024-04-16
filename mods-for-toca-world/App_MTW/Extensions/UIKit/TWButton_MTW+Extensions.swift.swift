//
//  TWButton_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWButton_MTW = UIButton

extension TWButton_MTW {
    
    class func configured(type: UIButton.ButtonType = .system,
                          with title: String,
                          titleColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        
        button.configure_MTW(with: title, titleColor: titleColor)
        
        return button
    }
    
    func configure_MTW(with title: String,
                   titleColor: UIColor) {
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = TWFonts_MTW.knicknackFont(for: .regular,
                                                          size: 25)
        setTitleColor(titleColor, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
}
