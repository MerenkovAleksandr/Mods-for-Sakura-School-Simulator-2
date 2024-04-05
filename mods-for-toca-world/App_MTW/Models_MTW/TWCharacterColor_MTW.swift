//
//  TWCharacterColor_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

struct ColorsDataModel: Hashable {
    let color: UIColor
    let colorString: String
    var isSelected: Bool
}

enum TWCharacterColor_MTW: String, CaseIterable {
    case color1 = "#AD5C26"
    case color2 = "#62371A"
    case color3 = "#A96921"
    case color4 = "#F9C78A"
    case color5 = "#DCBAB4"
    case color6 = "#7D472D"
    case color7 = "#D99774"
    case color8 = "#AD6A57"
    case color9 = "#F2B694"
    case color10 = "#654337"
    case color11 = "#8A3D2D"
    case color12 = "#D29461"
    case color13 = "#E98A61"
    case color14 = "#F1A456"
    case color15 = "#F7C1B7"
    case color16 = "#AC6740"
    
    var color: UIColor {
        switch self {
        case .color1:
            return #colorLiteral(red: 0.6784313725, green: 0.3607843137, blue: 0.1490196078, alpha: 1)
        case .color2:
            return #colorLiteral(red: 0.3818636537, green: 0.2182752192, blue: 0.0989734903, alpha: 1)
        case .color3:
            return #colorLiteral(red: 0.662745098, green: 0.4117647059, blue: 0.1294117647, alpha: 1)
        case .color4:
            return #colorLiteral(red: 0.9764705882, green: 0.7803921569, blue: 0.5411764706, alpha: 1)
        case .color5:
            return #colorLiteral(red: 0.862745098, green: 0.7294117647, blue: 0.7058823529, alpha: 1)
        case .color6:
            return #colorLiteral(red: 0.5671243072, green: 0.3520736098, blue: 0.2309092879, alpha: 1)
        case .color7:
            return #colorLiteral(red: 0.8843398094, green: 0.6588075757, blue: 0.5282646418, alpha: 1)
        case .color8:
            return #colorLiteral(red: 0.7384323478, green: 0.4951764941, blue: 0.4149955511, alpha: 1)
        case .color9:
            return #colorLiteral(red: 0.96356529, green: 0.7651998401, blue: 0.6456027627, alpha: 1)
        case .color10:
            return #colorLiteral(red: 0.4745722413, green: 0.3340153992, blue: 0.2783295214, alpha: 1)
        case .color11:
            return #colorLiteral(red: 0.6159920096, green: 0.3134503663, blue: 0.2307428718, alpha: 1)
        case .color12:
            return #colorLiteral(red: 0.8613632321, green: 0.6464272141, blue: 0.4545235634, alpha: 1)
        case .color13:
            return #colorLiteral(red: 0.9371764064, green: 0.614834249, blue: 0.4542899132, alpha: 1)
        case .color14:
            return #colorLiteral(red: 0.961363256, green: 0.7017213106, blue: 0.4094272256, alpha: 1)
        case .color15:
            return #colorLiteral(red: 0.9789196849, green: 0.8038823009, blue: 0.7671123147, alpha: 1)
        case .color16:
            return #colorLiteral(red: 0.7350828052, green: 0.4819041491, blue: 0.3174339831, alpha: 1)
        }
    }
    
    static let `default` = TWCharacterColor_MTW.color9
}
