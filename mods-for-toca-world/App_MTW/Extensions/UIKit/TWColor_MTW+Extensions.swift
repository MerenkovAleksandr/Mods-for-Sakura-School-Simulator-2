//
//  TWColor_MTW+Extensions.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias TWColor_MTW = UIColor

extension TWColor_MTW {
    
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String(format: "#%02lX%02lX%02lX",
                               lroundf(Float(r * 255)),
                               lroundf(Float(g * 255)),
                               lroundf(Float(b * 255)))
        return hexString
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return self }
        return UIColor(red: min(red + percentage/100, 1.0),
                       green: min(green + percentage/100, 1.0),
                       blue: min(blue + percentage/100, 1.0),
                       alpha: alpha)
    }
    
}
