//
//  TWContentItemCategory_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

enum TWContentItemCategory_MTW: Hashable {
    static let dafault: [TWContentItemCategory_MTW] = [.all, .stared, .lastAdded]
    
    case all,
         stared,
         lastAdded,
         custom(_ title: String)
    
    var localizedTitle: String {
        let key: String
        
        switch self {
        case .all:
            key = "Text49ID"
        case .stared:
            key = "Text50ID"
        case .lastAdded:
            key = "Text51ID"
        case let .custom(title):
            return title.capitalized
        }
        
        return NSLocalizedString(key, comment: "")
    }
}
