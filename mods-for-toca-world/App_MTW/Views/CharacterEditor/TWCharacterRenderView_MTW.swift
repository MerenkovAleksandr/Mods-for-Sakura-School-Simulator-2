//
//  TWCharacterRenderView.swift
//  template
//
//  Created by Systems
//

import UIKit
import WebKit

final class TWCharacterRenderView_MTW: UIView {
    
    private var renderView = {
        let renderView = WKWebView()
        
        renderView.isOpaque = false
        renderView.contentMode = .scaleAspectFill
        renderView.scrollView.showsHorizontalScrollIndicator = false
        renderView.scrollView.showsVerticalScrollIndicator = false
        renderView.translatesAutoresizingMaskIntoConstraints = false
        
        return renderView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit_MTW()
    }
    
    func commonInit_MTW() {
        addSubview(renderView)
        
        renderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func render_MTW(character: TWCharacterModel_MTW) {
        let hexColor = "character.color.hexString"
        let svg = character.content
        let content = "<!DOCTYPE html><html><style>html,svg{position:fixed;right:0;left:0;top:0;width:calc(100% - 100px);height:calc(100% - 100px);margin-top:auto;margin-bottom:auto;margin-left:auto;margin-right:auto}#color{fill:\(hexColor)}</style><head><meta name=\"viewport\" content=\"initial-scale=0.1,minimum-scale=0.1,maximum-scale=4,user-scalable=yes\"><script src=\"main.js\"></script></head><body>\(svg)</body></html>"
        renderView.loadHTMLString(content, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate

extension TWCharacterRenderView_MTW: WKNavigationDelegate {}


    
