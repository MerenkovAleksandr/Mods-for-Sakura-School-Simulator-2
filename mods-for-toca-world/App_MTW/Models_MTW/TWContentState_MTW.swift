//
//  TWContentState_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation

final class TWContentState_MTW: NSObject {
    
    private(set) var selectedCategory: TWContentItemCategory_MTW = .all
    private(set) var content: [TWContentModel_MTW] = []
    private(set) var searchResults: [TWContentModel_MTW] = []
    private(set) var lastPage: Int = 0
    private(set) var loadingContent: Bool = false
    
    var hasSearchResult: Bool {
        !searchResults.isEmpty
    }
    
    func update(searchResults: [TWContentModel_MTW]) {
        self.searchResults = searchResults
    }
    
    func update(content: [TWContentModel_MTW]) {
        self.content = content
    }
    
    func update_MTW(category: TWContentItemCategory_MTW) -> Bool {
        guard category != selectedCategory else { return false }
        self.selectedCategory = category
        return true
    }
    
    func update_MTW(model: TWContentModel_MTW) {
        guard let index = content
            .firstIndex(where: { $0.id == model.id }) else { return }
        
        if selectedCategory == .stared,
           model.attributes?.favourite == false {
            content.remove(at: index)
            return
        }
        
        content[index] = model
    }
    
    func clearSearchResults() {
        searchResults.removeAll()
    }
    
}
