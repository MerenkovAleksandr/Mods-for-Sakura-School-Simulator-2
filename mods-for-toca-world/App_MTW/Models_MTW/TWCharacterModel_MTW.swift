//
//  TWCharacterModel_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

// MARK: - TWCharacterModel_MTW

class TWCharacterModel_MTW: NSObject {
    
    let id: UUID
    
    private(set) var color: TWCharacterColor_MTW
    private(set) var markup: TWEditorContentModel_MTW
    private(set) var hair: TWEditorContentModel_MTW?
    private(set) var hat: TWEditorContentModel_MTW?
    private(set) var eyebrows: TWEditorContentModel_MTW?
    private(set) var eyes: TWEditorContentModel_MTW?
    private(set) var nose: TWEditorContentModel_MTW?
    private(set) var mouth: TWEditorContentModel_MTW?
    private(set) var top: TWEditorContentModel_MTW?
    private(set) var bottom: TWEditorContentModel_MTW?
    private(set) var shoes: TWEditorContentModel_MTW?
    private(set) var accessory: TWEditorContentModel_MTW?
    private(set) var image: UIImage?
    
    init(id: UUID = UUID(),
         color: TWCharacterColor_MTW = .default,
         markup: TWEditorContentModel_MTW,
         hair: TWEditorContentModel_MTW? = nil,
         hat: TWEditorContentModel_MTW? = nil,
         eyebrows: TWEditorContentModel_MTW? = nil,
         eyes: TWEditorContentModel_MTW? = nil,
         nose: TWEditorContentModel_MTW? = nil,
         mouth: TWEditorContentModel_MTW? = nil,
         top: TWEditorContentModel_MTW? = nil,
         bottom: TWEditorContentModel_MTW? = nil,
         shoes: TWEditorContentModel_MTW? = nil,
         accessory: TWEditorContentModel_MTW? = nil) {
        self.id = id
        self.color = color
        self.markup = markup
        self.hair = hair
        self.hat = hat
        self.eyebrows = eyebrows
        self.eyes = eyes
        self.nose = nose
        self.mouth = mouth
        self.top = top
        self.bottom = bottom
        self.shoes = shoes
        self.accessory = accessory
    }
    
    var head: TWEditorContentModel_MTW? { hat ?? hair }
    
    init?(from preview: TWCharacterPreview_MTW,
         set: TWEditorMarkupSet_MTW) {
        guard let color = TWCharacterColor_MTW(rawValue: preview.colorString)
        else {
            return nil
        }
        
        self.id = preview.id
        self.color = color
        self.markup = set.markup
        
        self.hair = {
            if let id = preview.hair {
                return set.hair.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.hat = {
            if let id = preview.hat {
                return set.hats.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.eyebrows = {
            if let id = preview.eyebrows {
                return set.eyebrows.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.nose = {
            if let id = preview.nose {
                return set.nose.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.eyes = {
            if let id = preview.eyes {
                return set.eyes.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.mouth = {
            if let id = preview.mouth {
                return set.mouth.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.top = {
            if let id = preview.top {
                return set.shirt.first(where: { $0.id == id })
                ?? set.dresses.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.bottom = {
            if let id = preview.bottom {
                return set.trousers.first(where: { $0.id == id })
                ?? set.shorts.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.shoes = {
            if let id = preview.shoes {
                return set.shoes.first(where: { $0.id == id })
            }
            return nil
        }()
        
        self.accessory = {
            if let id = preview.accessory {
                return set.bags.first(where: { $0.id == id })
            }
            return nil
        }()
    }
    
}

// MARK: - Public API

extension TWCharacterModel_MTW {
    
    var content: String {
        [markup,
         shoes,
         bottom,
         top,
         nose,
         eyes,
         mouth,
         eyebrows,
         head,
         accessory]
            .lazy
            .compactMap { $0?.data?.toPrimarySVG }
            .joined()
            .components(separatedBy: .newlines)
            .reduce("", +)
    }
    
    var preview: TWCharacterPreview_MTW? {
        .init(from: self)
    }
    
    func change_MTW(item: TWEditorContentModel_MTW,
                set: TWEditorMarkupSet_MTW?) -> Bool {
        guard let set else { return false }
        
        if item.contentType == .markup {
            return updateMarkup(to: set)
        }
        
        guard item.tag == markup.tag else { return false }
        
        switch item.contentType {
        case .hair:
            hat = nil
            hair = item
        case .hats:
            hat = item
        case .eyebrows:
            eyebrows = item
        case .bags:
            accessory = item
        case .trousers, .shorts, .skirts:
            if top?.contentType == .dresses { top = nil }
            bottom = item
        case .eyes:
            eyes = item
        case .nose:
            nose = item
        case .shirt:
            top = item
        case .shoes:
            shoes = item
        case .dresses:
            top = item
            bottom = nil
        case .mouth:
            mouth = item
        default:
            fatalError("Invalid - TWEditorContentType_MTW: \(item.contentType)")
        }
        
        image = nil
        
        return true
    }
    
    func remove(_ contentType: TWEditorContentType_MTW) -> Bool {
        var result = false
        
        switch contentType {
        case .hair where hair != nil:
            hair = nil
            hat = nil
            result.toggle()
        case .hats where hat != nil:
            hat = nil
            result.toggle()
        case .bags where accessory != nil:
            accessory = nil
            result.toggle()
        case .trousers where bottom?.contentType == .trousers,
             .shorts where bottom?.contentType == .shorts,
             .skirts where bottom?.contentType == .skirts:
            bottom = nil
            result.toggle()
        case .shirt where top?.contentType == .shirt:
            top = nil
            result.toggle()
        case .shoes where shoes != nil:
            shoes = nil
            result.toggle()
        case .dresses where top?.contentType == .dresses:
            top = nil
            result.toggle()
        default:
            break
        }
        
        if result { image = nil }
        
        return result
    }
    
    func update(image: UIImage?) {
        self.image = image
    }
    
    func update(color: TWCharacterColor_MTW) {
        self.color = color
        self.image = nil
    }
    
}

// MARK: - Private API

private extension TWCharacterModel_MTW {
    
    func updateMarkup(to set: TWEditorMarkupSet_MTW) -> Bool {
        let baseCharacter = set.baseCharacter
        
        markup = set.markup
        hair = baseCharacter.hair
        hat = baseCharacter.hat
        eyebrows = baseCharacter.eyebrows
        eyes = baseCharacter.eyes
        nose = baseCharacter.nose
        top = baseCharacter.top
        bottom = baseCharacter.bottom
        shoes = baseCharacter.shoes
        accessory = baseCharacter.accessory
        mouth = baseCharacter.mouth
        
        image = nil
        
        return true
    }
    
}

