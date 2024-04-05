//
//  TWContentType_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation

enum TWContentType_MTW: Int, CaseIterable {
    case editor = 0,
         set,
         mod,
         wallpaper,
         map,
         sound,
         guide
    
    init?(int64: Int64?) {
        switch int64 {
        case 0: self = .editor
        case 1: self = .set
        case 2: self = .mod
        case 3: self = .wallpaper
        case 4: self = .map
        case 5: self = .sound
        case 6: self = .guide
        default: return nil
        }
    }
    
    var int64: Int64 { Int64(rawValue) }
    
    var associatedPath: TWKeys_MTW.TWPath_MTW {
        switch self {
        case .map:
            return .maps
        case .editor:
            return .editor
        case .set:
            return .sets
        case .mod:
            return  .mods
        case .wallpaper:
            return .wallpapers
        case .sound:
            return .sounds
        case .guide:
            return .guides
        }
    }
    
    var localizedTitle: String {
        let key: String
        
        switch self {
        case .editor:
            return ""
        case .set:
            key = "House ideas"
        case .mod:
            key = "Mods"
        case .wallpaper:
            key = "Wallpapers"
        case .map:
            key = "Maps"
        case .sound:
            key = "Sounds"
        case .guide:
            key = "Guides"
        }
        
        return key
    }
    
}
