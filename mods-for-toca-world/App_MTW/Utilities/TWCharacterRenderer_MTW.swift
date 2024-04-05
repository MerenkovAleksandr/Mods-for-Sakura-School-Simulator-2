//
//  TWCharacterRenderer_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import WebKit

final class TWCharacterRenderer_MTW: NSObject {
    
    private var renderView: WKWebView!
    
    static let size: CGSize = .init(width: 512.0, height: 512.0)
    
    private(set) var completion: ((UIImage?) -> Void)!
    
    override init() {
        renderView = .init(frame: .init(origin: .zero,
                                        size: TWCharacterRenderer_MTW.size))
        renderView.isOpaque = false
        renderView.contentMode = .scaleAspectFit
        renderView.scrollView.showsHorizontalScrollIndicator = false
        renderView.scrollView.showsVerticalScrollIndicator = false
        renderView.translatesAutoresizingMaskIntoConstraints = false
    }
        
}

// MARK: - WKNavigationDelegate

extension TWCharacterRenderer_MTW: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let configuration = WKSnapshotConfiguration()
        configuration.rect = .init(origin: .zero,
                                   size: TWCharacterRenderer_MTW.size)
        renderView.takeSnapshot(with: configuration) {
            [weak self] image, error in
            if let error { print(error.localizedDescription) }
            self?.completion(image)
        }
    }
    
}

// MARK: = Public API

extension TWCharacterRenderer_MTW {
    
    func render(character: TWCharacterModel_MTW,
                completion: ((UIImage?) -> Void)?) {
        self.completion = completion
        let hexColor = character.color.rawValue
        let svg = character.content
        let content = "<!DOCTYPE html><html><style>html,svg{position:fixed;right:0;left:0;top:0;width:calc(100% - 100px);height:calc(100% - 100px);margin-top:auto;margin-bottom:auto;margin-left:auto;margin-right:auto}#color{fill:\(hexColor)}</style><head><meta name=\"viewport\" content=\"initial-scale=0.1,minimum-scale=0.1,maximum-scale=4,user-scalable=yes\"><script src=\"main.js\"></script></head><body>\(svg)</body></html>"
        renderView.navigationDelegate = self
        renderView.loadHTMLString(content, baseURL: nil)
    }
    
}
