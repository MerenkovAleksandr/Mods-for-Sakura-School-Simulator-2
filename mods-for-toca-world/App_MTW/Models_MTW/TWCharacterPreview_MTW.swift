//
//  TWCharacterPreview_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWCharacterPreview_MTW: Hashable {
    
    static func == (lhs: TWCharacterPreview_MTW,
                    rhs: TWCharacterPreview_MTW) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID
    let content: Data
    let colorString: String
    let markup: UUID
    let hair: UUID?
    let hat: UUID?
    let eyebrows: UUID?
    let eyes: UUID?
    let nose: UUID?
    let mouth: UUID?
    let top: UUID?
    let bottom: UUID?
    let shoes: UUID?
    let accessory: UUID?
    
    init(id: UUID,
         content: Data,
         colorString: String,
         markup: UUID,
         hair: UUID? = nil,
         hat: UUID? = nil,
         eyebrows: UUID? = nil,
         eyes: UUID? = nil,
         nose: UUID? = nil,
         mouth: UUID? = nil,
         top: UUID? = nil,
         bottom: UUID? = nil,
         shoes: UUID? = nil,
         accessory: UUID? = nil) {
        self.id = id
        self.content = content
        self.colorString = colorString
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
    
    init?(from model: TWCharacterModel_MTW) {
        guard let content = model.image?.pngData() else { return nil }
        self.id = model.id
        self.content = content
        self.colorString = model.color.rawValue
        self.markup = model.markup.id
        self.hair = model.hair?.id
        self.hat = model.hat?.id
        self.eyebrows = model.eyebrows?.id
        self.eyes = model.eyes?.id
        self.nose = model.nose?.id
        self.mouth = model.mouth?.id
        self.top = model.top?.id
        self.bottom = model.bottom?.id
        self.shoes = model.shoes?.id
        self.accessory = model.accessory?.id
    }
    
    init?(from entity: CharacterEntity) {
        guard let id = entity.id,
              let colorString = entity.color,
              let markup = entity.markup,
              let content = entity.content else { return nil }
        
        self.id = id
        self.content = content
        self.colorString = colorString
        self.markup = markup
        self.hat = entity.hat
        self.hair = entity.hair
        self.eyebrows = entity.eyebrows
        self.eyes = entity.eyes
        self.nose = entity.nose
        self.mouth = entity.mouth
        self.top = entity.top
        self.bottom = entity.bottom
        self.shoes = entity.shoes
        self.accessory = entity.accessory
    }
    
    var image: UIImage? { .init(data: content) }
    
}
