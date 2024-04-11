//
//  TWAttributtedStrings_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWAttributtedStrings_MTW {
    
    class var iPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    class var searchBarTextFieldTextAttridbutes: [NSAttributedString.Key : Any]
    {[
        .font: UIFont.defaultFont(.regular, size: 24.0),
        .kern: -1.0,
        .paragraphStyle: NSParagraphStyle.aligned(.left),
        .foregroundColor: TWColors_MTW.navigationBarForeground
    ]}
    
    class var searchBarTextFieldParagraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        return paragraphStyle
    }
    
    class func barAttrString(with localizedString: String,
                             foregroundColor: UIColor) -> NSAttributedString {
        let size: CGFloat = iPad ? 44.0 : 32.0
        let lineSpacing: CGFloat = iPad ? .zero : 20.0
        let kern = iPad ? -2.0 : -0.5
        
        return .compose(localizedString: localizedString,
                        kern: kern,
                        font: .defaultFont(.semiBold,
                                           size: size),
                        paragraphStyle: .aligned(.center,
                                                 lineSpacing: lineSpacing),
                        foregroundcolor: foregroundColor)
    }
    
    class func barNewAttrString(with localizedString: String,
                             foregroundColor: UIColor) -> NSAttributedString {
        let size: CGFloat = iPad ? 44.0 : 17.0
        let lineSpacing: CGFloat = iPad ? .zero : 20.0
        let kern = iPad ? -2.0 : -0.5
        
        return .compose(localizedString: localizedString,
                        kern: kern,
                        font: .defaultFont(.semiBold,
                                           size: size),
                        paragraphStyle: .aligned(.center,
                                                 lineSpacing: lineSpacing),
                        foregroundcolor: foregroundColor)
    }
    
    class func contentSelectorItemAttrString(with localizedString: String,
                                             foregroundColor: UIColor)
    -> NSAttributedString {
        let kern: CGFloat = iPad ? -1.5 : -0.5
        let size: CGFloat
        
        if UIScreen.main.nativeBounds.height < 2436, !iPad {
            size = 20.0
        } else {
            size = iPad ? 36.0 : 21.0
        }
        
        return .compose(localizedString: localizedString,
                        kern: kern,
                        font: .defaultFont(.regular, size: size),
                        paragraphStyle: .centered(lineSpacing: 20.0),
                        foregroundcolor: foregroundColor)
    }
    
    class func searchBarAttrString(with localizedString: String,
                                   foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -1.5,
                 font: .defaultFont(.medium, size: 20.0),
                 paragraphStyle: .aligned(.center),
                 foregroundcolor: foregroundColor)
    }
    
    class func searchResultAttrString(with localizedString: String,
                                      foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -1.5,
                 font: .defaultFont( .regular, size: 24.0),
                 paragraphStyle: .aligned(.left),
                 foregroundcolor: foregroundColor)
    }
    
    class func categoryItemAttrString(with localizedString: String,
                                            foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.semiBold, size: 20.0),
                 paragraphStyle: .aligned(.center),
                 foregroundcolor: foregroundColor)
    }
    
    class func bubbleButtonTitleAttrString(with localizedString: String,
                                                 foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.semiBold, size: 36.0),
                 paragraphStyle: .aligned(.center),
                 foregroundcolor: foregroundColor)
    }
    
    class func bubbleButtonDotsTitleAttrString(foregroundColor: UIColor = .white)
    -> NSAttributedString {
        .compose(localizedString: "...",
                 kern: -0.5,
                 font: .defaultFont(.regular, size: 17.0),
                 paragraphStyle: .aligned(.center, lineHeightMultiple: 0.7),
                 foregroundcolor: foregroundColor)
    }
    
    class func contentCellTitleAttrString(with localizedString: String,
                                          foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.regular,
                                    size: iPad ? 24.0 : 24.0),
                 paragraphStyle: .aligned(.left,
                                          lineBrakeMode: .byTruncatingTail,
                                          lineHeightMultiple: 0.9),
                 foregroundcolor: foregroundColor)
    }
    
    class func contentDetailsCellTitleAttrString(with localizedString: String,
                                          foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .notoSantFont(.medium,
                                    size: iPad ? 24.0 : 16.0),
                 paragraphStyle: .aligned(.left,
                                          lineBrakeMode: .byTruncatingTail,
                                          lineHeightMultiple: 1.1),
                 foregroundcolor: foregroundColor)
    }
    
    class func contentDetailTitleAttrString(with localizedString: String,
                                          foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.regular,
                                    size: iPad ? 36.0 : 21.0),
                 paragraphStyle: .aligned(.center,
                                          lineBrakeMode: .byTruncatingTail,
                                          lineHeightMultiple: 0.8),
                 foregroundcolor: foregroundColor)
    }
    
    class func alertViewTitleAttrString(with localizedString: String,
                                        foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.semiBold, size: 24.0),
                 paragraphStyle: .centered,
                 foregroundcolor: foregroundColor)
    }
    
    class func alertViewMessageAttrString(with localizedString: String,
                                          foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -1.25,
                 font: .defaultFont(.medium, size: 24.0),
                 paragraphStyle: .centered(lineHeightMultiple: 0.52),
                 foregroundcolor: foregroundColor)
    }
    
    class func recomendationsTitleAttrString(with localizedString: String,
                                             foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -0.5,
                 font: .defaultFont(.semiBold, size: 24.0),
                 paragraphStyle:.aligned(.left),
                 foregroundcolor: foregroundColor)
    }
    
    class func colorPickerTitleAttrString(with localizedString: String,
                                          foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -1.0,
                 font: .defaultFont(.semiBold, size: 24.0),
                 paragraphStyle: .aligned(.left, lineSpacing: 20.0),
                 foregroundcolor: foregroundColor)
    }
    
    class func bubbleViewAttrString(with localizedString: String,
                                    foregroundColor: UIColor)
    -> NSAttributedString {
        .compose(localizedString: localizedString,
                 kern: -1.0,
                 font: .defaultFont(.bold, size: 40.0),
                 paragraphStyle: .aligned(.center, lineHeightMultiple: 0.8),
                 foregroundcolor: foregroundColor)
    }
    
}
