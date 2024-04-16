//
//  TWAlertController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import Combine

final class TWAlertController_MTW: UIViewController {
    
    class func show_MTW(with alertTitle: String,
                        message alertMessage: String,
                        leading leadingBtn: TWAlertButton_MTW = .defaultBtn,
                        trailing trailingBtn: TWAlertButton_MTW? = nil)
    -> TWAlertController_MTW {
        let alert = TWAlertController_MTW()
        
        alert.alertTitle = alertTitle
        alert.alertMessage = alertMessage
        alert.leadingBtn = leadingBtn
        alert.trailingBtn = trailingBtn
        alert.modalPresentationStyle = .overFullScreen
        
        return alert
    }
    
    class func indicator_MTW(title alertTitle: String, handler: @escaping () -> Void)
    -> TWAlertController_MTW {
        let alert = TWAlertController_MTW()
        
        alert.alertTitle = alertTitle
        alert.alertMessage = ""
        alert.showIndicator = true
        alert.leadingBtn = .cancel_MTW(handler: handler)
        alert.modalPresentationStyle = .overFullScreen
        
        return alert
    }
    
    class func loadingIndicator(handler: @escaping () -> Void)
    -> TWAlertController_MTW {
        let title = NSLocalizedString("Text32ID", comment: "")
        let alert = indicator_MTW(title: title, handler: handler)
        
        return alert
    }
    
    private let activityIndicator = TWActivityIndicator_MTW()
    private let alertView = TWAlertView_MTW()
    
    private var showIndicator: Bool = false
    private var alertTitle: String!
    private var alertMessage: String!
    private var leadingBtn: TWAlertButton_MTW!
    private var trailingBtn: TWAlertButton_MTW?
    private var progressToken: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(alertView)
        view.addSubview(activityIndicator)
        
        alertView.configure(title: alertTitle,
                            message: alertMessage,
                            leadingButton: leadingBtn,
                            trailingButton: trailingBtn)
        alertView.didSelect = { [weak self] leading in
            self?.fadeDismiss_MTW(withSelected: leading)
        }
        alertView.alpha = .zero
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(330.0)
            $0.height.equalTo(205.0)
        }
        
        activityIndicator.alpha = .zero
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(24.0)
        }
        
        progressToken = TWDBManager_MTW.shared
            .progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
                    dismissWithFade_MTW()
                    return
                }
                if showIndicator {
                    self.activityIndicator.hide_MTW()
                }
                self.alertView.configure(message: message)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = 1.0
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
            
            if self.showIndicator {
                self.activityIndicator.alpha = 1.0
                self.activityIndicator.rotateView()
            }
        })
    }
    
    func dismissWithFade_MTW(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = .zero
            self.activityIndicator.alpha = .zero
            self.view.backgroundColor = .clear
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false,
                          completion: completion)
        })
    }
    
    private func fadeDismiss_MTW(withSelected leading: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = .zero
            self.activityIndicator.alpha = .zero
            self.view.backgroundColor = .clear
        }, completion: { [weak self] _ in
            self?.dismiss(animated: false) {
                leading
                ? self?.leadingBtn.handler?()
                : self?.trailingBtn?.handler?()
            }
        })
    }
    
}
