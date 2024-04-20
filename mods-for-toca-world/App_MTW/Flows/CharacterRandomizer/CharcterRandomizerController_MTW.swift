//
//  CharcterRandomizerController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import Photos

typealias RandomizerState = TWCharacterRandomizerController_MTW.TWState_MTW

final class TWCharacterRandomizerController_MTW: TWNavigationController_MTW {
    
    enum TWState_MTW {
        case idle,
             result,
             countdown
    }
    
    private var randomizerView = TWCharacterRandomizerView_MTW()
    private var configurator: TWCharacterConfigurator_MTW?
    
    private var currentState: TWCharacterRandomizerController_MTW.TWState_MTW = .idle
    private var preloader: TWAlertController_MTW?
    
    private var network: NetworkStatusMonitor_MTW { .shared }
    
    private var timer: Timer?
    private var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentView()
    }
    
    override var localizedTitle: String {
        NSLocalizedString("Text84ID", comment: "")
    }
    
    override var leadingBarIcon: UIImage? {
        currentState == .result ?  #imageLiteral(resourceName: "icon_navigation_back") :  #imageLiteral(resourceName: "icon_navigation_home")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            }, animated: false)
            return
        }
        
        showContentPerloader()
    }
    
    override func didTapLeadingBarBtn() {
        if currentState == .result {
            currentState = .idle
            randomizerView.configureView_MTW(accordingTo: currentState)
            configureNavigationBar()
            guard timer != nil else { return }
            stopStopwatch()
            return
        }
        
        navigationController?.popViewController(animated: false)
    }
    
}

// MARK: - TWCharacterRandomizerDelegate_MTW

extension TWCharacterRandomizerController_MTW: TWCharacterRandomizerDelegate_MTW {
    
    func didTapActionButton() {
        switch currentState {
        case .idle:
            configurator?.generateRandomCharacter()
            
            currentState = .result
            randomizerView.configureView_MTW(accordingTo: .result)
        case .countdown:
            break
        case .result:
            randomizerView.configureView_MTW(accordingTo: .countdown)
//            startTimer()
            savePreview()
        }
        
        configureNavigationBar()
    }
    
    func getCharacterImage(completion: @escaping (UIImage?) -> Void) {
        configurator?.getCharacterImage(completion: completion)
    }
    
}

// MARK: - Private API

private extension TWCharacterRandomizerController_MTW {
    var dropbox: TWDBManager_MTW { .shared }
    
    func showContentPerloader() {
        let title = NSLocalizedString("Text60ID", comment: "")
        let preloader = TWAlertController_MTW.indicator_MTW(title: title) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        present(preloader, animated: false) { [weak self] in
            self?.preloader = preloader
            self?.prepareContent()
        }
    }
    
    func updateState() {
        currentState = .idle
    }
    
    func finishCountdown() {
        updateState()
    }
    
    func configureContentView() {
        vContent.addSubview(randomizerView)
        
        randomizerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        randomizerView.configureView_MTW(accordingTo: currentState)
        randomizerView.delegate = self
        
        network.delegate = self
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
    }
    
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
//        randomizerView.configureCountdown(seconds)
    }
    
    func prepareContent() {
        dropbox.fetchEditorContent { [weak self] in
            guard let self = self else { return }
            
            let content = self.dropbox.contentManager.fetchEditorContent()
            if content.contains(where: { $0.data == nil }) {
                self.dropbox.contentManager.removeAllContentEntities()
                self.dropbox.contentManager.removeAllCharacters()
                self.prepareContent()
                return
            }
            
            if content.contains(where: { $0.data == nil }) {
                self.dropbox.contentManager.removeAllContentEntities()
                self.dropbox.contentManager.removeAllCharacters()
                self.prepareContent()
                return
            }

            
            guard let configurator = TWCharacterConfigurator_MTW
                .init(content: content,
                      character: nil) else {
                showErrorAndCloseRandomizer()
                return
            }
            
            self.configurator = configurator
            self.preloader?.dismiss(animated: false) { [weak self] in
                self?.configureNavigationBar()
            }
        }
    }
    
    func showErrorAndCloseRandomizer() {
        let title = NSLocalizedString("Text81ID", comment: "")
        let message = NSLocalizedString("Text82ID", comment: "")
        let okTitle = NSLocalizedString("Text33ID", comment: "")
        
        let alert = TWAlertController_MTW
            .show_MTW(with: title,
                         message: message,
                         leading: .init(title: okTitle,
                                        handler: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            }))
        
        present(alert, animated: true)
    }
    
    func savePreview() {
        guard let image = configurator?.character.image else { return }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        if status == .authorized {
            saveImage(image)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly, handler: {
            [weak self] status in
            if status == .authorized {
                self?.saveImage(image)
                return
            }
            
            let alert = UIAlertController.photoLibraryIssue()
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        })
    }
    
    func goToSettings() {
        UIApplication.shared.canOpenURL(.init(string: UIApplication.openSettingsURLString)!)
    }
    
    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if let error {
            print(error.localizedDescription)
            return
        }
        
        let alert = TWAlertController_MTW.loadingSuccessful { [weak self] in
            sleep(1)
            self?.didTapLeadingBarBtn()
        }
        
        present(alert, animated: true)
    }
    
    @objc func updateStopwatch() {
        seconds += 1
    }
    
    func configureNavigationBar() {
        vNavigation.update_MTW(leadingItem: leadingBarIcon)
    }
    
}

// MARK: - NetworkStatusMonitorDelegate_MTW

extension TWCharacterRandomizerController_MTW: NetworkStatusMonitorDelegate_MTW {
    
    func alert_MTW() {
        preloader?.dismissWithFade_MTW()
        DispatchQueue.main.async {
            guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
                self.present(UIAlertController.connectionIssue { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, animated: true)
                return
            }
        }
    }
    
}
