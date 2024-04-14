//
//  TWCharacterConfigurator_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

typealias EditorCategory = TWCharacterConfigurator_MTW.CategoryItem
typealias EditorContent = TWCharacterConfigurator_MTW.ContentItem

final class TWCharacterConfigurator_MTW: NSObject {
    
    enum CategoryItem: Hashable {
        case color,
             content(_ contentType: TWEditorContentType_MTW)
        
        var preview: UIImage {
            switch self {
            case .color:
                return #imageLiteral(resourceName: "icon_editor_color")
            case .content(let contentType):
                return contentType.preview
            }
        }
        
        var previewPurple: UIImage {
            switch self {
            case .color:
                return #imageLiteral(resourceName: "icon_editor_color_purple")
            case .content(let contentType):
                return contentType.previewPurple
            }
        }
        
        var localizedTitle: String {
            switch self {
            case .color:
                return NSLocalizedString("Text66ID", comment: "")
            case let .content(contentType):
                return contentType.localizedTitle
            }
        }
        
    }
    
    enum ContentItem: Hashable {
        case remove(_ contentType: TWEditorContentType_MTW),
             update(_ item: TWEditorContentModel_MTW)
    }
    
    let sets: [TWEditorMarkupSet_MTW]
    
    private let renderer = TWCharacterRenderer_MTW()
    
    private(set) var character: TWCharacterModel_MTW
    private(set) var selectedItem: EditorCategory = .color
    
    init?(content: [TWEditorContentModel_MTW],
         character preview: TWCharacterPreview_MTW?) {
        let markups = content.filter { $0.contentType == .markup }
        let sets: [TWEditorMarkupSet_MTW] = markups
            .compactMap { markup in
                .init(content: content.filter {
                    $0.tag == markup.tag
                })
            }
        
        if sets.isEmpty { return nil }
        
        self.sets = sets
        
        var character: TWCharacterModel_MTW?
        
        if let preview {
            guard let set = sets.first(where: { $0.markup.id == preview.markup })
            else {
                return nil
            }
            character = .init(from: preview, set: set)
        } else {
            character = sets.first?.baseCharacter
        }
        
        guard let character else { return nil }
        
        self.character = character
    }
    
}

// MARK: - Public API

extension TWCharacterConfigurator_MTW {
    
    var selectedSet: TWEditorMarkupSet_MTW? {
        sets.first(where: { $0.markup.id == character.markup.id })
    }
    
    var items: [CategoryItem] {
        var items: [CategoryItem] = [.color]
        
        for contentType in TWEditorContentType_MTW.allCases {
            let addItem: Bool = {
                guard let selectedSet else { return false }
                
                if contentType == .hats,
                   let parentId = character.hair?.id {
                    return selectedSet.hasContent(for: .hair, with: parentId)
                }
                
                return selectedSet.hasContent(for: contentType)
            }()
            
            guard addItem else { continue }
            
            items.append(contentType.configuratorItem)
        }
        
        return items
    }
    
    var elements: [ContentItem] {
        var content = [ContentItem]()
        
        switch selectedItem {
        case .color:
            return []
        case .content(let contentType):
            switch contentType {
            case .markup:
                content.append(contentsOf: sets.compactMap { .update($0.markup) })
            case .hair:
                if let hair = selectedSet?.hair {
                    content.append(.remove(.hair))
                    content.append(contentsOf: hair.map { .update($0) })
                }
            case .hats:
                if let hats = selectedSet?.hats {
                    content.append(.remove(.hats))
                    content.append(contentsOf: hats
                        .filter { $0.parentId == character.hair?.id }
                        .map { .update($0) })
                }
            case .eyebrows:
                if let eyebrows = selectedSet?.eyebrows {
                    content.append(contentsOf: eyebrows.map { .update($0) })
                }
            case .bags:
                if let bags = selectedSet?.bags {
                    content.append(.remove(.bags))
                    content.append(contentsOf: bags.map { .update($0) })
                }
            case .trousers:
                if let trousers = selectedSet?.trousers {
                    content.append(.remove(.trousers))
                    content.append(contentsOf: trousers.map { .update($0) })
                }
            case .shorts:
                if let shorts = selectedSet?.shorts {
                    content.append(.remove(.shorts))
                    content.append(contentsOf: shorts.map { .update($0) })
                }
            case .eyes:
                if let eyes = selectedSet?.eyes {
                    content.append(contentsOf: eyes.map { .update($0) })
                }
            case .nose:
                if let nose = selectedSet?.nose {
                    content.append(contentsOf: nose.map { .update($0) })
                }
            case .shirt:
                if let shirt = selectedSet?.shirt {
                    content.append(.remove(.shirt))
                    content.append(contentsOf: shirt.map { .update($0) })
                }
            case .shoes:
                if let shoes = selectedSet?.shoes {
                    content.append(.remove(.shoes))
                    content.append(contentsOf: shoes.map { .update($0) })
                }
            case .skirts:
                if let skirts = selectedSet?.skirts {
                    content.append(.remove(.skirts))
                    content.append(contentsOf: skirts.map { .update($0) })
                }
            case .dresses:
                if let dresses = selectedSet?.dresses {
                    content.append(.remove(.dresses))
                    content.append(contentsOf: dresses.map { .update($0) })
                }
            case .mouth:
                if let dresses = selectedSet?.mouth {
                    content.append(contentsOf: dresses.map { .update($0) })
                }
            }
        }
        
        return content
    }
    
    func isSelected(_ model: TWEditorContentModel_MTW) -> Bool {
        switch model.contentType {
        case .markup where character.markup.id == model.id,
             .hair where character.hair?.id == model.id,
             .hats where character.hat?.id == model.id,
             .eyebrows where character.eyebrows?.id == model.id,
             .bags where character.accessory?.id == model.id,
             .trousers where character.bottom?.id == model.id,
             .shorts where character.bottom?.id == model.id,
             .shoes where character.shoes?.id == model.id,
             .skirts where character.bottom?.id == model.id,
             .dresses where character.top?.id == model.id,
             .mouth where character.mouth?.id == model.id,
             .nose where character.nose?.id == model.id,
             .eyes where character.eyes?.id == model.id,
             .shirt where character.top?.id == model.id:
            return true
        default:
            return false
        }
    }
    
    func isRemoved(_ contentType: TWEditorContentType_MTW) -> Bool {
        switch contentType {
        case .hair:
            return character.hair == nil
        case .hats:
            return character.hat == nil
        case .bags:
            return character.accessory == nil
        case .trousers:
            return character.bottom?.contentType != .trousers
        case .shorts:
            return character.bottom?.contentType != .shorts
        case .shirt:
            return character.top?.contentType != .shirt
        case .shoes:
            return character.shoes?.contentType != .shoes
        case .skirts:
            return character.top?.contentType != .skirts
        case .dresses:
            return character.top?.contentType != .dresses
        default:
            return false
        }
    }
    
    func getCharacterImage(completion: @escaping (UIImage?) -> Void) {
        if let image = character.image {
            completion(image)
            return
        }
        
        renderer.render(character: character) { [weak self] image in
            self?.character.update(image: image)
            completion(image)
        }
    }
    
    func update(selectedItem: CategoryItem) {
        self.selectedItem = selectedItem
    }
    
    func update(character content: ContentItem) -> Bool {
        switch content {
        case let .remove(contentType):
            return character.remove(contentType)
        case let .update(item):
            if item.contentType == .markup,
               item.id != selectedSet?.markup.id,
               let newSet = sets.first(where: {
                   $0.markup.id == item.id
               }) {
                return character.change_MTW(item: item, set: newSet)
            }
            
            return character.change_MTW(item: item, set: selectedSet)
        }
    }
    
    func update(color selectedColor: TWCharacterColor_MTW) -> Bool {
        guard character.color != selectedColor else { return false }
        character.update(color: selectedColor)
        
        return true
    }
    
    func isConfirmationRequired(for preview: TWCharacterPreview_MTW?) -> Bool {
        let original = preview ?? sets.first?.basePreview
        let current = character.preview
        if let original,
           let current {
            return original.colorString != current.colorString
            || original.markup != current.markup
            || original.hair != current.hair
            || original.hat != current.hat
            || original.eyebrows != current.eyebrows
            || original.eyes != current.eyes
            || original.nose != current.nose
            || original.mouth != current.mouth
            || original.top != current.top
            || original.bottom != current.bottom
            || original.shoes != current.shoes
            || original.accessory != current.accessory
        }
        
        return false
    }
    
    func generateRandomCharacter() {
        guard let set = sets.randomElement(),
              let color = TWCharacterColor_MTW.allCases.randomElement()
        else { return }
        
        let markup = set.markup
        let head = getRandomHeadOption(from: set)
        let top = getRandomTopOption(from: set)
        let bottom = top?.contentType == .dresses
        ? nil
        : getRandomBottomOption(from: set)
        
        let eyebrows = set.eyebrows.randomElement()
        let eyes = set.eyes.randomElement()
        let mouth = set.mouth.randomElement()
        let nose = set.nose.randomElement()
        let shoes = set.shoes.randomElement()
        let accesory = set.bags.randomElement()
        
        character = .init(id: UUID(),
                          color: color,
                          markup: markup,
                          hair: head?.contentType == .hair ? head : nil,
                          hat: head?.contentType == .hats ? head : nil,
                          eyebrows: eyebrows,
                          eyes: eyes,
                          nose: nose,
                          mouth: mouth,
                          top: top,
                          bottom: bottom,
                          shoes: shoes,
                          accessory: accesory)
    }
    
}

// MARK: - Private API

private extension TWCharacterConfigurator_MTW {
    
    func getRandomHeadOption(from set: TWEditorMarkupSet_MTW)
    -> TWEditorContentModel_MTW? {
        var allOptions: [TWEditorContentModel_MTW] = []
        allOptions.append(contentsOf: set.hair)
        allOptions.append(contentsOf: set.hats)
        
        return allOptions.randomElement()
    }
    
    func getRandomTopOption(from set: TWEditorMarkupSet_MTW)
    -> TWEditorContentModel_MTW? {
        var allOptions: [TWEditorContentModel_MTW] = []
        allOptions.append(contentsOf: set.shirt)
        allOptions.append(contentsOf: set.dresses)
        
        return allOptions.randomElement()
    }
    
    func getRandomBottomOption(from set: TWEditorMarkupSet_MTW)
    -> TWEditorContentModel_MTW? {
        var allOptions: [TWEditorContentModel_MTW] = []
        allOptions.append(contentsOf: set.trousers)
        allOptions.append(contentsOf: set.shorts)
        allOptions.append(contentsOf: set.skirts)
        
        return allOptions.randomElement()
    }
    
}

struct CharacterConfiguratorItem_MTW {
    
    let id: UUID
    let type: EditorCategory
    
    var image: UIImage {
        switch type {
        case .color:
            return #imageLiteral(resourceName: "icon_editor_color")
        case let .content(contentType):
            return contentType.preview
        }
    }
    
}
