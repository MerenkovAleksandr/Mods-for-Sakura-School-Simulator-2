//
//  TWCharacterRandomizerView_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

protocol TWCharacterRandomizerDelegate_MTW: AnyObject {
    func didTapActionButton()
    func getCharacterImage(completion: @escaping (UIImage?) -> Void)
}

final class TWCharacterRandomizerView_MTW: UIView {
    
    weak var delegate: TWCharacterRandomizerDelegate_MTW?
    
    @IBOutlet var view: UIView!
    
    @IBOutlet private var ivPlaceholder: UIImageView!
    @IBOutlet private var ivResultBackground: UIImageView!
    @IBOutlet private var ivContent: UIImageView!
    @IBOutlet private var lblCoundownTimer: UILabel!
    @IBOutlet private var btnDownload: TWBaseButton_MTW!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit_MTW()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit_MTW()
    }
    
    @IBAction func btnAction(_ sender: Any) {
        delegate?.didTapActionButton()
    }
    
}


// MARK: - Public API

extension TWCharacterRandomizerView_MTW {
    
    func configureView_MTW(accordingTo state: RandomizerState) {
        switch state {
        case .result:
            ivContent.visibility(isVisible: true)
            ivResultBackground.visibility(isVisible: true)
            ivPlaceholder.visibility(isVisible: false)
            
            configureBtn(with: downloadTitle)
            
            delegate?.getCharacterImage { [weak self] image in
                self?.ivContent.image = image
                self?.configureBtn(with: self?.downloadTitle ?? "")
            }
        default:
            ivContent.visibility(isVisible: false)
            ivResultBackground.visibility(isVisible: false)
            ivPlaceholder.visibility(isVisible: true)
            
            ivContent.image = nil
            
            configureBtn(with: startTitle)
        }
    }
    
    
}

// MARK: - Private API

private extension TWCharacterRandomizerView_MTW {
    
    var downloadTitle: String {
        NSLocalizedString("Text52ID", comment: "")
    }
    
    var startTitle: String {
        NSLocalizedString("Text85ID", comment: "")
    }
    
    func commonInit_MTW() {
       loadViewFromNib_MTW()
    }
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
    func configureBtn(with title: String) {
        btnDownload.configure_MTW(with: title)
    }
    
}
