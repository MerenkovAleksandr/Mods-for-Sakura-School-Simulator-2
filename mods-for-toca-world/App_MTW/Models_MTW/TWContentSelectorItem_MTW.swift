//
//  TWContentSelectorItem_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

enum TWContentSelectorItem_MTW: String, CaseIterable {
    case mods = "Mods"
    case maps = "Maps"
    case sets = "House ideas"
    case wallpapers = "Wallpapers"
    case characters = "Characters"
    case sounds = "Sounds"
    case characterRandomizer = "CharacterRandomizer"
    case guides = "Guides"
    
    static var mainSectionItems: [TWContentSelectorItem_MTW] {
        TWContentSelectorItem_MTW.allCases.dropLast(2)
    }
    
    static var subSectionItems: [TWContentSelectorItem_MTW] {
        [.characterRandomizer, .guides]
    }
    
    var isContentLocked: Bool {
        switch self {
        case .mods:
            return !IAPManager_MTW.shared.isFirstFuncEnabled
        case .characters:
            return !IAPManager_MTW.shared.isSecondFuncEnabled
        default:
            return false
        }
    }
    
}

// MARK: - Content

extension TWContentSelectorItem_MTW {
    
    var localizedTitle: String {
        let key: String
        
        switch self {
        case .mods:
            key = "Text40ID"
        case .maps:
            key = "Text41ID"
        case .sets:
            key = "Text42ID"
        case .wallpapers:
            key = "Text43ID"
        case .characters:
            key = "Text44ID"
        case .sounds:
            key = "Text45ID"
        case .characterRandomizer:
            key = "Text46ID"
        case .guides:
            key = "Text47ID"
        }
        
        return NSLocalizedString(key, comment: "")
    }
    
    var image: UIImage? {
        switch self {
        case .mods:
            return #imageLiteral(resourceName: "icon_delivery")
        case .maps:
            return #imageLiteral(resourceName: "icon_world")
        case .sets:
            return #imageLiteral(resourceName: "icon_blueprint")
        case .wallpapers:
            return #imageLiteral(resourceName: "icon_image")
        case .characters:
            return #imageLiteral(resourceName: "icon_children")
        case .sounds:
            return #imageLiteral(resourceName: "icon_volume")
        default:
            return nil
        }
    }
    
    var isPlainTextCell: Bool {
        TWContentSelectorItem_MTW.subSectionItems.contains(self)
    }
    
    var contentType: TWContentType_MTW {
        switch self {
        case .mods:
            return .mod
        case .maps:
            return .map
        case .sets:
            return .set
        case .wallpapers:
            return .wallpaper
        case .characters:
            return .editor
        case .sounds:
            return .sound
        case .characterRandomizer:
            return .editor
        case .guides:
            return .guide
        }
    }
    
}
