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
            lblCoundownTimer.hide_MTW()
            ivContent.visibility(isVisible: true)
            ivResultBackground.visibility(isVisible: true)
            ivPlaceholder.visibility(isVisible: false)
            
            configureBtn(with: downloadTitle)

            delegate?.getCharacterImage { [weak self] image in
                self?.ivContent.image = image
                self?.configureBtn(with: self?.downloadTitle ?? "")
            }
        case .countdown:
            configureLoadingBtn()
        default:
            lblCoundownTimer.show_MTW()
            ivContent.visibility(isVisible: false)
            ivResultBackground.visibility(isVisible: false)
            ivPlaceholder.visibility(isVisible: true)
            
            ivContent.image = nil
            
            configureTimer()
            configureBtn(with: startTitle)
        }
    }
    
    func configureCountdown(_ seconds: Int) {
        lblCoundownTimer.text = formatSeconds(seconds: seconds)
    }
    
    func formatSeconds(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - Private API

private extension TWCharacterRandomizerView_MTW {
    
    var downloadTitle: String {
        NSLocalizedString("Text52ID", comment: "").uppercased()
    }
    
    var startTitle: String {
        NSLocalizedString("Text85ID", comment: "").uppercased()
    }
    
    func commonInit_MTW() {
       loadViewFromNib_MTW()
    }
    
    func loadViewFromNib_MTW() {
        view = loadFromNib_MTW(in: bounds)
        view.backgroundColor = .clear
        addSubview(view)
    }
    
    func configureTimer() {
        let attributedString = TWAttributtedStrings_MTW
            .timerAttrString(with: "00:00:00",
                             foregroundColor: TWColors_MTW.contentCellForeground)
        lblCoundownTimer.attributedText = attributedString
    }
    
    func configureBtn(with title: String) {
        btnDownload.subviews.forEach { $0.removeFromSuperview() }
        btnDownload.configure_MTW(with: title)
    }
    
    func configureLoadingBtn() {
        configureBtn(with: "")

        let activityDimensions: CGFloat = 38
        let activityIndicator = TWActivityIndicator_MTW(frame: CGRect(x: btnDownload.bounds.width / 2 - 20,
                                                                      y: btnDownload.bounds.height / 2 - 20,
                                                                      width: activityDimensions,
                                                                      height: activityDimensions))
        activityIndicator.rotateView()
        
        btnDownload.addSubview(activityIndicator)
        
    }
    
}
