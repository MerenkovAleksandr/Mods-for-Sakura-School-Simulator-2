//
//  TWCharacterPreviewView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import Photos

final class TWCharacterPreviewView_MTW: TWBaseView_MTW {
    
    @IBOutlet private var view: UIView!
    
    @IBOutlet private var ivContent: UIImageView!
    @IBOutlet private var btnDownload: TWBaseButton_MTW!
    @IBOutlet private var vBubble: TWBubbleView_MTW!
    @IBOutlet private var vSubMenu: TWSubMenu_MTW!
    
    var didPerform: ((TWSubMenu_MTW.TWAction_MTW) -> Void)?
    var didSave: (() -> Void)?
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        loadViewFromNib_MTW()
        configureView_MTW()
    }
    
    override func draw(_ rect: CGRect) {}
    
    @IBAction func downloadBtnAction(_ sender: Any) {
        didSave?()
    }
    
}

// MARK: - Public API

extension TWCharacterPreviewView_MTW {
    
    func configure(_ preview: TWCharacterPreview_MTW) {
        ivContent.image = preview.image
    }
    
}

// MARK: - Private API

private extension TWCharacterPreviewView_MTW {
    
    func configureView_MTW() {
        configureBubbleView()
        configureSubMenuView()
        configureDownloadButton()
    }
    
    func configureBubbleView() {
        vBubble.makeInteractive { [weak self] in
            self?.toggleSubMenu()
        }
    }
    
    func configureDownloadButton() {
        let localizedTitle = NSLocalizedString("Text52ID", comment: "")
        btnDownload.setAttributedTitle(TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: TWColors_MTW.buttonForegroundColor),
                                       for: .normal)
    }
    
    func configureSubMenuView() {
        vSubMenu.alpha = .zero
        vSubMenu.didPerform = { [weak self] action in
            self?.didPerform?(action)
        }
        
        addGestureRecognizer(UITapGestureRecognizer
            .init(target: self,
                  action: #selector(dismissSubMenu)))
    }
    
    func toggleSubMenu() {
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.vSubMenu.alpha = self.vSubMenu.alpha == 1 ? 0 : 1
        })
    }
    
    @objc func dismissSubMenu() {
        guard vSubMenu.alpha == 1.0 else { return }
        toggleSubMenu()
    }
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
}
