//
//  TWContentEditorModel_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

struct TWEditorContentModel_MTW: Hashable {
    
    static func == (lhs: TWEditorContentModel_MTW,
                    rhs: TWEditorContentModel_MTW) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID
    let contentType: TWEditorContentType_MTW
    let tag: Int
    let parentId: UUID?
    let path: TWEditorContentPath_MTW
    var data: TWEditorContentData_MTW?
    
    init(id: UUID,
         contentType: TWEditorContentType_MTW,
         tag: Int,
         path: String,
         preview: String,
         parentId: UUID? = nil,
         data: TWEditorContentData_MTW? = nil) {
        self.id = id
        self.contentType = contentType
        self.tag = tag
        self.path = .init(svgPath: path, elPath: preview)
        self.data = data
        self.parentId = parentId
    }
    
    init(from entity: ContentEntity) {
        guard let id = entity.id,
              let rawValue = entity.editorContentType,
              let contentType = TWEditorContentType_MTW(rawValue: rawValue),
              let path = entity.primaryPath,
              let preview = entity.secondaryPath else {
            fatalError("Invalid Entity!")
        }
        var data: TWEditorContentData_MTW?
        
        if let primary = entity.primaryData,
           let secondaty = entity.secondaryData {
            data = .init(primary: primary, secondaty: secondaty)
        }
        
        self.init(id: id,
                  contentType: contentType,
                  tag: Int(entity.editorTag),
                  path: path,
                  preview: preview,
                  parentId: entity.parentId,
                  data: data)
    }
    
    init(from codable: TWEditorCodableContent_MTW,
         contentType: TWEditorContentType_MTW,
         tag: Int) {
        self.init(id: UUID(),
                  contentType: contentType,
                  tag: tag,
                  path: codable.path,
                  preview: codable.preview)
    }
    
}

// MARK: - Public API

extension TWEditorContentModel_MTW {
    
    var needData: Bool {
        data == nil
    }
    
}

struct TWEditorContentPath_MTW {
    let svgPath: String
    let elPath: String
}

struct TWEditorContentData_MTW {
    let primary: Data
    let secondary: Data
    
    init(primary: Data, secondaty: Data) {
        self.primary = primary
        self.secondary = secondaty
    }
    
    var toPrimarySVG: String? {
        String
            .init(data: primary, encoding: .utf8)?
            .components(separatedBy: .newlines)
            .reduce("", +)
    }
    
    var preview: UIImage? {
        .init(data: secondary)
    }
    
}

struct TWEditorMarkup_MTW: Codable, Hashable {
    let id: Int
    let path: String
}

struct TWEditorCodableContent_MTW: Codable {
    let id: Int
    let path: String
    let preview: String
    let list: [TWEditorCodableContent_MTW]?
}

struct TWEditorMarkupCodableContent_MTW: Codable {
    let path: String
    let preview: String
}

struct TWEditorCodableMarkupSet_MTW: Codable {
    let markup: TWEditorMarkupCodableContent_MTW
    let hair: [TWEditorCodableContent_MTW]?
    let hats: [TWEditorCodableContent_MTW]?
    let eyebrows: [TWEditorCodableContent_MTW]?
    let bags: [TWEditorCodableContent_MTW]?
    let trousers: [TWEditorCodableContent_MTW]?
    let shorts: [TWEditorCodableContent_MTW]?
    let eyes: [TWEditorCodableContent_MTW]?
    let nose: [TWEditorCodableContent_MTW]?
    let shirt: [TWEditorCodableContent_MTW]?
    let shoes: [TWEditorCodableContent_MTW]?
    let skirts: [TWEditorCodableContent_MTW]?
    let dresses: [TWEditorCodableContent_MTW]?
    let mouth: [TWEditorCodableContent_MTW]?
}
