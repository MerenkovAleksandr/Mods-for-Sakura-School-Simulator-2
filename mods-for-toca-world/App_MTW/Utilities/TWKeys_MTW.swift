//
//  TWKeys_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation

struct TWKeys_MTW {
    enum App: String {
        case accessCode_MTW = "8smM42oF9jIAAAAAAAAAZU-RuXi5eXUEnyAF_065fl8",
             key_MTW = "rdwg0xrvr6as173",
             secret_MTW = "ljuzxdw2lmkukzq",
             link_MTW = "https://api.dropboxapi.com/oauth2/token"
    }
    
    enum TWPath_MTW: String {
        case guides = "guides",
             maps = "maps",
             sets = "sets",
             sounds = "sounds",
             wallpapers = "wallpapers",
             mods = "mods",
             editor = "editor"
        
        var contentPath: String {
            .init(format: "/%@/%@.json", rawValue, rawValue)
        }
        
        func getPath(forMarkup tag: String) -> String {
            .init(format: "/%@/%@/content.json", rawValue, tag)
        }
        
        func getPath(for contentType: TWEditorContentType_MTW,
                     markup: String,
                     path: String) -> String {
            contentType == .markup
            ? .init(format: "/%@/%@/%@", TWPath_MTW.editor.rawValue, markup, path)
            : .init(format: "/%@/%@/%@/%@",
                    TWPath_MTW.editor.rawValue,
                    markup,
                    contentType.rawValue,
                    path)
        }
    }
}
