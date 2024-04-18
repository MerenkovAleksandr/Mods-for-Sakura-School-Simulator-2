//
//  TWPreloader_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWPreloader_MTW: TWBaseController_MTW, NetworkStatusMonitorDelegate_MTW {

    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var vProgressBar: TWProgressBarView_MTW!
    @IBOutlet private var vActivitiIndicator: TWActivityIndicator_MTW!
    
    private var isReadyToProceed: Bool = false
    private var dropBox: TWDBManager_MTW { .shared }
    private var network: NetworkStatusMonitor_MTW { .shared }
    
    private var iPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitleLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureProgressView()
        
        network.delegate = self
        
        vProgressBar.delegate = self
        vProgressBar.setProgress_MTW(value: 0.5, animated: true)
        vProgressBar.layer.opacity = 0
        
        connectToDropbox()
        
        guard let image = UIImage(named: "load") else { return }
        
        vActivitiIndicator.setImage(image)
        vActivitiIndicator.show_MTW()
        vActivitiIndicator.rotateView()
    }
    
}

// MARK: - NetworkStatusMonitorDelegate_MTW

extension TWPreloader_MTW {
    
    func alert_MTW() {
        present(UIAlertController.connectionIssue { [weak self] in
            self?.navigateToMainMenu()
        }, animated: true)
        
        UIApplication.shared.notificationFeedbackGenerator_MTW(type: .warning)
    }
    
}

// MARK: - Private API

private extension TWPreloader_MTW {
    
    var localizedTitle: String {
        NSLocalizedString("0%", comment: "").uppercased()
    }
    
    var foregroundColor: UIColor {
        TWColors_MTW.progressBarText
    }
    
    var attributtedString: NSAttributedString {
        TWAttributtedStrings_MTW.progressbarAttrString(with: localizedTitle,
                                               foregroundColor: foregroundColor)
    }
    
    func configureTitleLabel() {
        lblTitle.attributedText = attributtedString
        lblTitle.text = localizedTitle
    }
    
    func configureProgressView() {
        vProgressBar.didFinishAnimation = { [weak self] progress in
            if progress == 1.0 {
                self?.navigateToMainMenu()
            }
        }
    }
    
    func makeLayout() {
        let offset = iPad ? 163.0 : 65.0
        vActivitiIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(offset)
            make.centerX.centerY.equalToSuperview()
        }
        
        lblTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func connectToDropbox() {
        guard network.isNetworkAvailable else {
            alert_MTW()
            return
        }
        
        vProgressBar.setProgress_MTW(value: 0.5, animated: true)
        dropBox.connect_mtw { [weak self] _ in
            DispatchQueue.main.async {
                self?.vProgressBar.setProgress_MTW(animated: true)
            }
        }
    }
    
    func navigateToMainMenu() {
        let navigationController = UINavigationController
            .init(rootViewController: TWContentSelectorController_MTW())
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.setRootVC_MTW(navigationController)
    }
    
}

// MARK: - TWProgressBarViewDelegate_MTW

extension TWPreloader_MTW: TWProgressBarViewDelegate_MTW {
    func updateProgressValue(_ value: Int) {
        lblTitle.text = String(value) + "%"
    }
    
}
