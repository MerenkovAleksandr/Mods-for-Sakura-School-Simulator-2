//
//  TWContentModel_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

struct TWContentModel_MTW: Identifiable {
    
    let id: UUID
    let contentType: TWContentType_MTW
    var attributes: TWContentAttributes_MTW?
    var content: TWContent_MTW
    
    init(id: UUID = UUID(),
         contentType: TWContentType_MTW,
         attributes: TWContentAttributes_MTW? = nil,
         content: TWContent_MTW) {
        self.id = id
        self.contentType = contentType
        self.attributes = attributes
        self.content = content
    }

    init?(from codable: TWContentModelCodable_MTW,
          contentType: TWContentType_MTW,
          category: String? = nil) {
        let content = TWContent_MTW(contentId: codable.id,
                                    displayName: codable.name,
                                    description: codable.description,
                                    path: codable.path)
        let attributes = TWContentAttributes_MTW(new: codable.new ?? false,
                                                 timestamp: Date(),
                                                 category: category)
        self.init(contentType: contentType,
                  attributes: attributes,
                  content: content)
    }
    
    init(from codable: TWFileModelCodable_MTW) {
        self.init(contentType: .sound,
                  content: .init(contentId: codable.id,
                                 path: codable.path))
    }
    
    init?(from entity: ContentEntity) {
        guard let id = entity.id,
              let contentType = TWContentType_MTW(int64: entity.contentType)
        else { return nil}
        
        let content = TWContent_MTW(contentId: Int(entity.contentId),
                                    displayName: entity.contentName,
                                    description: entity.contentDescription,
                                    path: entity.primaryPath,
                                    data: entity.primaryData)
        let attributes = TWContentAttributes_MTW
            .init(favourite: entity.contentStared,
                  new: entity.newContent,
                  timestamp: entity.timestamp,
                  category: entity.contentCategory)
        self.init(id: id,
                  contentType: contentType,
                  attributes: attributes,
                  content: content)
    }
    
    mutating func addImage_MTW(_ data: Data) {
        content.data = data
    }
    
}

// MARK: - Hashable

extension TWContentModel_MTW: Hashable {
    
    static func == (lhs: TWContentModel_MTW,
                    rhs: TWContentModel_MTW) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

// MARK: - TWContentSearchable_MTW

extension TWContentModel_MTW: TWContentSearchable_MTW {
    
    var title: String {
        content.displayName ?? ""
    }
    
}

struct TWContent_MTW {
    let contentId: Int
    let displayName: String?
    let description: String?
    let path: String?
    var data: Data?
    
    var image: UIImage? {
        guard let data else { return nil }
        
        return UIImage(data: data)
    }
    
    
    init(contentId: Int,
         displayName: String? = nil,
         description: String? = nil,
         path: String? = nil,
         data: Data? = nil) {
        self.contentId = contentId
        self.displayName = displayName
        self.description = description
        self.path = path
        self.data = data
    }
}

struct TWContentAttributes_MTW {
    var favourite: Bool
    let new: Bool
    let timestamp: Date?
    let category: String?
    
    init(favourite: Bool  = false,
         new: Bool = true,
         timestamp: Date? = nil,
         category: String? = nil) {
        self.favourite = favourite
        self.new = new
        self.timestamp = timestamp
        self.category = category
    }
}
