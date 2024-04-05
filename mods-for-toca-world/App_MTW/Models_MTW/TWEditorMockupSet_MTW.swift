//
//  TWEditorMockupSet.swift
//  template
//
//  Created by Systems
//

import Foundation

struct TWEditorMarkupSet_MTW {
    let markup: TWEditorContentModel_MTW
    let hair: [TWEditorContentModel_MTW]
    let hats: [TWEditorContentModel_MTW]
    let eyebrows: [TWEditorContentModel_MTW]
    let bags: [TWEditorContentModel_MTW]
    let trousers: [TWEditorContentModel_MTW]
    let shorts: [TWEditorContentModel_MTW]
    let eyes: [TWEditorContentModel_MTW]
    let nose: [TWEditorContentModel_MTW]
    let shirt: [TWEditorContentModel_MTW]
    let shoes: [TWEditorContentModel_MTW]
    let skirts: [TWEditorContentModel_MTW]
    let dresses: [TWEditorContentModel_MTW]
    let mouth: [TWEditorContentModel_MTW]
    
    var baseCharacter: TWCharacterModel_MTW {
        let hair = hair.first
        let eyebrows = eyebrows.first
        let eyes = eyes.first
        let nose = nose.first
        let mouth = mouth.first
        let top = shirt.first ?? dresses.first
        let bottom = top?.contentType == .dresses
        ? nil
        : trousers.first ?? shorts.first ?? skirts.first
        let shoes = shoes.first
        let accessory = bags.first
        
        return .init(markup: markup,
                     hair: hair,
                     hat: nil,
                     eyebrows: eyebrows,
                     eyes: eyes,
                     nose: nose,
                     mouth: mouth,
                     top: top,
                     bottom: bottom,
                     shoes: shoes,
                     accessory: accessory)
    }
    
    var basePreview: TWCharacterPreview_MTW {
        let base = baseCharacter
        
        return .init(id: UUID(),
                     content: Data(),
                     colorString: base.color.rawValue,
                     markup: base.markup.id,
                     hair: base.hair?.id,
                     hat: base.hat?.id,
                     eyebrows: base.eyebrows?.id,
                     eyes: base.eyes?.id,
                     nose: base.nose?.id,
                     mouth: base.mouth?.id,
                     top: base.top?.id,
                     bottom: base.bottom?.id,
                     shoes: base.shoes?.id,
                     accessory: base.accessory?.id)
    }
    
    var randomCharacter: TWCharacterModel_MTW { baseCharacter }
    
    init(markup: TWEditorContentModel_MTW,
         hair: [TWEditorContentModel_MTW],
         hats: [TWEditorContentModel_MTW],
         eyebrows: [TWEditorContentModel_MTW],
         bags: [TWEditorContentModel_MTW],
         trousers: [TWEditorContentModel_MTW],
         shorts: [TWEditorContentModel_MTW],
         eyes: [TWEditorContentModel_MTW],
         nose: [TWEditorContentModel_MTW],
         shirt: [TWEditorContentModel_MTW],
         shoes: [TWEditorContentModel_MTW],
         skirts: [TWEditorContentModel_MTW],
         dresses: [TWEditorContentModel_MTW],
         mouth: [TWEditorContentModel_MTW]) {
        self.markup = markup
        self.hair = hair
        self.hats = hats
        self.eyebrows = eyebrows
        self.bags = bags
        self.trousers = trousers
        self.shorts = shorts
        self.eyes = eyes
        self.nose = nose
        self.shirt = shirt
        self.shoes = shoes
        self.skirts = skirts
        self.dresses = dresses
        self.mouth = mouth
    }
    
    init?(content: [TWEditorContentModel_MTW]) {
        if content.isEmpty { return nil }
        
        var markup: TWEditorContentModel_MTW?
        var hair = [TWEditorContentModel_MTW]()
        var hats = [TWEditorContentModel_MTW]()
        var eyebrows = [TWEditorContentModel_MTW]()
        var bags = [TWEditorContentModel_MTW]()
        var trousers = [TWEditorContentModel_MTW]()
        var shorts = [TWEditorContentModel_MTW]()
        var eyes = [TWEditorContentModel_MTW]()
        var nose = [TWEditorContentModel_MTW]()
        var shirt = [TWEditorContentModel_MTW]()
        var shoes = [TWEditorContentModel_MTW]()
        var skirts = [TWEditorContentModel_MTW]()
        var dresses = [TWEditorContentModel_MTW]()
        var mouth = [TWEditorContentModel_MTW]()
        
        for item in content {
            switch item.contentType {
            case .markup:
                markup = item
            case .hair:
                hair.append(item)
            case .eyebrows:
                eyebrows.append(item)
            case .bags:
                bags.append(item)
            case .trousers:
                trousers.append(item)
            case .shorts:
                shorts.append(item)
            case .eyes:
                eyes.append(item)
            case .nose:
                nose.append(item)
            case .shirt:
                shirt.append(item)
            case .shoes:
                shoes.append(item)
            case .skirts:
                skirts.append(item)
            case .dresses:
                dresses.append(item)
            case .hats:
                hats.append(item)
            case .mouth:
                mouth.append(item)
            }
        }
        
        guard let markup else { return nil }
        
        self.init(markup: markup,
                  hair: hair,
                  hats: hats,
                  eyebrows: eyebrows,
                  bags: bags,
                  trousers: trousers,
                  shorts: shorts,
                  eyes: eyes,
                  nose: nose,
                  shirt: shirt,
                  shoes: shoes,
                  skirts: skirts,
                  dresses: dresses,
                  mouth: mouth)
    }
    
    func hasContent(for contentType: TWEditorContentType_MTW,
                    with parentId: UUID? = nil) -> Bool {
        switch contentType {
        case .markup:
            return true
        case .hair:
            return !hair.isEmpty
        case .hats:
            guard let parentId else { return false }
            return hats.contains(where: { $0.parentId == parentId })
        case .eyebrows:
            return !eyebrows.isEmpty
        case .bags:
            return !bags.isEmpty
        case .trousers:
            return !trousers.isEmpty
        case .shorts:
            return !shorts.isEmpty
        case .eyes:
            return !eyes.isEmpty
        case .nose:
            return !nose.isEmpty
        case .shirt:
            return !shirt.isEmpty
        case .shoes:
            return !shoes.isEmpty
        case .skirts:
            return !skirts.isEmpty
        case .dresses:
            return !dresses.isEmpty
        case .mouth:
            return !mouth.isEmpty
        }
    }
}
