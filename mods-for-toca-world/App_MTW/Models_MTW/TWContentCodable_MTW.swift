//
//  TWContentCodable_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation

struct TWContentCodable_MTW: Codable {
    let list: [TWContentCategoryCodable_MTW]
    
    enum CodingKeys: String, CodingKey {
        case list = "category_list"
    }
}

struct TWContentCategoryCodable_MTW: Codable {
    let title: String
    let list: [TWContentModelCodable_MTW]
}

struct TWGuidesCodable_MTW: Codable {
    let list: [TWContentModelCodable_MTW]
    
    enum CodingKeys: String, CodingKey {
        case list = "guides_list"
    }
}

struct TWSoundCodable_MTW: Codable {
    let list: [TWFileModelCodable_MTW]
    
    enum CodingKeys: String, CodingKey {
        case list = "sounds_list"
    }
}

struct TWFileModelCodable_MTW: Codable {
    let id: Int
    let path: String
}

struct TWContentModelCodable_MTW: Codable {
    let id: Int
    let path: String
    let name: String?
    let description: String?
    let new: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id,
             path = "img-path",
             name,
             description,
             new
    }
    
}
