//
//  TWEditorContentType_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

enum TWEditorContentType_MTW: String, CaseIterable {
    case markup = "markup",
         shoes = "shoes",
         hair = "hair",
         eyes = "eyes",
         nose = "nose",
         eyebrows = "eyebrows",
         mouth = "mouth",
         hats = "hats",
         bags = "bags",
         shirt = "shirt",
         trousers = "trousers",
         shorts = "shorts",
         skirts = "skirts",
         dresses = "dresses"
    
    init?(rawValue: String) {
        switch rawValue {
        case "markup": self = .markup
        case "hair": self = .hair
        case "hats": self = .hats
        case "eyebrows": self = .eyebrows
        case "bags": self = .bags
        case "trousers": self = .trousers
        case "shorts": self = .shorts
        case "eyes": self = .eyes
        case "nose": self = .nose
        case "shirt": self = .shirt
        case "shoes": self = .shoes
        case "skirts": self = .skirts
        case "dresses": self = .dresses
        case "mouth": self = .mouth
        default: return nil
        }
    }
    
    var configuratorItem: EditorCategory {
        switch self {
        case .markup:
            return .content(.markup)
        case .hair:
            return .content(.hair)
        case .hats:
            return .content(.hats)
        case .eyebrows:
            return .content(.eyebrows)
        case .bags:
            return .content(.bags)
        case .trousers:
            return .content(.trousers)
        case .shorts:
            return .content(.shorts)
        case .eyes:
            return .content(.eyes)
        case .nose:
            return .content(.nose)
        case .shirt:
            return .content(.shirt)
        case .shoes:
            return .content(.shoes)
        case .skirts:
            return .content(.skirts)
        case .dresses:
            return .content(.dresses)
        case .mouth:
            return .content(.mouth)
        }
    }
    
    var childContentType: TWEditorContentType_MTW? {
        switch self {
        case .hair:
            return .hats
        default:
            return nil
        }
    }
}

// MARK: - Content

extension TWEditorContentType_MTW {
    
    var localizedTitle: String {
        let key: String
        
        switch self {
        case .markup:
            key = "Text67ID"
        case .hair:
            key = "Text68ID"
        case .hats:
            key = "Text69ID"
        case .eyebrows:
            key = "Text70ID"
        case .bags:
            key = "Text71ID"
        case .trousers:
            key = "Text72ID"
        case .shorts:
            key = "Text73ID"
        case .eyes:
            key = "Text74ID"
        case .nose:
            key = "Text75ID"
        case .shirt:
            key = "Text76ID"
        case .shoes:
            key = "Text77ID"
        case .skirts:
            key = "Text78ID"
        case .dresses:
            key = "Text79ID"
        case .mouth:
            key = "Text80ID"
        }
        
        return NSLocalizedString(key, comment: "")
    }
    
    var preview: UIImage {
        switch self {
        case .markup:
            return #imageLiteral(resourceName: "icon_editor_figure")
        case .hair:
            return #imageLiteral(resourceName: "icon_editor_hair")
        case .hats:
            return #imageLiteral(resourceName: "icon_editor_hats")
        case .eyebrows:
            return #imageLiteral(resourceName: "icon_editor_eyebrow")
        case .bags:
            return #imageLiteral(resourceName: "icon_editor_bag")
        case .trousers:
            return #imageLiteral(resourceName: "icon_editor_trousers")
        case .shorts:
            return #imageLiteral(resourceName: "icon_editor_shorts")
        case .eyes:
            return #imageLiteral(resourceName: "icon_editor_eyes")
        case .nose:
            return #imageLiteral(resourceName: "icon_editor_nose")
        case .shirt:
            return #imageLiteral(resourceName: "icon_editor_shirt")
        case .shoes:
            return #imageLiteral(resourceName: "icon_editor_shoes")
        case .skirts:
            return #imageLiteral(resourceName: "icon_editor_skirt")
        case .dresses:
            return #imageLiteral(resourceName: "icon_editor_dress")
        case .mouth:
            return #imageLiteral(resourceName: "icon_editor_mouth")
        }
    }
    
}
