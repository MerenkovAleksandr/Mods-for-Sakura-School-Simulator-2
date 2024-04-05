//
//  TWArray_MTW+Extension.swift
//  mods-for-toca-world
//
//  Created by Systems
//

import Foundation
extension TWContentCollectionView_MTW  {
    func unique(contents: [TWContentModel_MTW]) -> [TWContentModel_MTW] {

        var uniqueContents = [TWContentModel_MTW]()
        
        for content in contents {
            if !uniqueContents.contains(where: { $0.content.displayName == content.content.displayName }) {
                    uniqueContents.append(content)
                }
            }

        return uniqueContents
    }
}
