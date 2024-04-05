import UIKit
import AVKit
import AVFoundation

enum PremiumMainControllerStyle_MTW {
    case mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther
}

class PremiumMainController_MTW: UIViewController {

    private var playerLayer : AVPlayerLayer!
    private var view0 = ReusableView_MTW()
    private var view1 = ReusableView_MTW()
    private var viewTransaction = TransactionView_MTW()
    
    @IBOutlet private weak var freeform: UIView!
    @IBOutlet private weak var videoElement: UIView!
    @IBOutlet private weak var restoreBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var productBuy : PremiumMainControllerStyle_MTW = .mainProduct
    
    private var intScreenStatus = 0
    private var avPlayer: AVPlayer? = AVPlayer()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        
        if !TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() {
            transactionTreatment_MTW(title: NSLocalizedString( "Text30ID", comment: ""),
                                     message: NSLocalizedString("Text31ID", comment: ""))
        }
        
        initVideoElement_MTW()
        startMaked_MTW()
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        deinitOperation_MTW()
    }

    override  func viewDidDisappear(_ animated: Bool) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        chageScreenStatus_MTW()
    }
    
    
    private func initVideoElement_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            BGPlayer_MTW()
        }
    }
    
    //MARK: System events
    
    private func deinitOperation_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        intScreenStatus = 1
        avPlayer?.pause()
        avPlayer?.replaceCurrentItem(with: nil)
        if playerLayer != nil {
            playerLayer.player = nil
        }
        avPlayer = nil
        playerLayer = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func chageScreenStatus_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        intScreenStatus = 1
        avPlayer?.pause()
    }
   

   
    // MARK: - Setup Video Player

     private func BGPlayer_MTW(){
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         var pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MTW.nameFileVideoForPhone, withExtension: ConfigurationMediaSub_MTW.videoFileType)
         if UIDevice.current.userInterfaceIdiom == .pad {
             pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MTW.nameFileVideoForPad, withExtension: ConfigurationMediaSub_MTW.videoFileType)
         }else{
             pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MTW.nameFileVideoForPhone, withExtension: ConfigurationMediaSub_MTW.videoFileType)
         }
         
         avPlayer = AVPlayer(url: pathUrl!)
         playerLayer = AVPlayerLayer(player: avPlayer)
         playerLayer.frame = self.view.layer.bounds
         if UIDevice.current.userInterfaceIdiom == .pad{
             playerLayer.videoGravity = .resizeAspectFill
         }else{
             playerLayer.videoGravity = .resize
         }
         self.videoElement.layer.addSublayer(playerLayer)
         avPlayer?.play()
         
         if let avPlayer {
             loopVideoMB_MTW(videoPlayer: avPlayer)
         }
         addPlayerNotifications_MTW()
     }
     
     private func addPlayerNotifications_MTW() {
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd_MTW), name: .AVPlayerItemDidPlayToEndTime, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground_MTW), name: UIApplication.willEnterForegroundNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground_MTW), name: UIApplication.didEnterBackgroundNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption_MTW(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
     }
    
    @objc func handleInterruption_MTW(notification: Notification) {
        guard let info = notification.userInfo,
          let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        if type == .began {
          // Interruption began, take appropriate actions (save state, update user interface)
          self.avPlayer?.pause()
        } else if type == .ended {
          guard let optionsValue =
            info[AVAudioSessionInterruptionOptionKey] as? UInt else {
              return
          }
          let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
          if options.contains(.shouldResume) {
            // Interruption Ended - playback should resume
            self.avPlayer?.play()
          }
        }
      }
     
     private func loopVideoMB_MTW(videoPlayer:AVPlayer){
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
             videoPlayer.seek(to: .zero)
             videoPlayer.play()
         }
     }
     
     // Player end.
     @objc  private func playerItemDidPlayToEnd_MTW(_ notification: Notification) {
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         // Your Code.
         if intScreenStatus == 0{
             avPlayer?.seek(to: CMTime.zero)
         }
     }

     //App enter in forground.
     @objc private func applicationWillEnterForeground_MTW(_ notification: Notification) {
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         if intScreenStatus == 0 {
             avPlayer?.play()
         } else {
             avPlayer?.pause()
         }
     }

     //App enter in forground.
     @objc private func applicationDidEnterBackground_MTW(_ notification: Notification) {
         var _MTW = "_MTW"
         for i in _MTW {
             if i == "d" {
                 _MTW += "d"
             } else {
                 _MTW += "s"
             }
         }
         avPlayer?.pause()
     }
    
    // MARK: - Make UI/UX
    
    private func startMaked_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        setRestoreBtn_MTW()
        if productBuy == .mainProduct {
            setReusable_MTW(config: .first, isHide: false)
            setReusable_MTW(config: .second, isHide: true)
            setTransaction_MTW(isHide: true)
        } else {
            setTransaction_MTW(isHide: false)
            self.showRestore_MTW()
        }
       
    }
    
    //reusable setup
    
    private func generateContentForView_MTW(config: configView_MTW) -> [ReusableContentCell_MTW] {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        var contentForCV : [ReusableContentCell_MTW] = []
        switch config {
        case .first:
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text18ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text19ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text20ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text21ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text22ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text18ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text19ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text20ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text21ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text22ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .second:
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text18ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text19ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text20ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text21ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text22ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text18ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text19ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text20ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text21ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MTW(title: localizedString_MTW(forKey:"Text22ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .transaction: return contentForCV
        }
    }
    
    private func setReusable_MTW(config : configView_MTW, isHide : Bool){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        var currentView : ReusableView_MTW? = nil
        var viewModel : ReusableViewModel_MTW? = nil
        switch config {
        case .first:
            viewModel =  ReusableViewModel_MTW(title: localizedString_MTW(forKey: "Text0ID").uppercased(), items: self.generateContentForView_MTW(config: config))
            currentView = self.view0
        case .second:
            viewModel =  ReusableViewModel_MTW(title: localizedString_MTW(forKey: "Text17ID").uppercased(), items: self.generateContentForView_MTW(config: config))
            currentView = self.view1
            case .transaction:
            currentView = nil
        }
        guard let i = currentView else { return }
        i.protocolElement = self
        i.viewModel = viewModel
        i.configView_MTW = config
        freeform.addSubview(i)
        freeform.bringSubviewToFront(i)
        
        i.snp.makeConstraints { make in
            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        i.isHidden = isHide
    }
    //transaction setup
    
    private func setTransaction_MTW( isHide : Bool) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.viewTransaction.inapp.productBuy = self.productBuy
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewTransaction.setLocalization_MTW()
        }
        
        freeform.addSubview(self.viewTransaction)
        freeform.bringSubviewToFront(self.viewTransaction)
        self.viewTransaction.snp.makeConstraints { make in
            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        self.viewTransaction.isHidden = isHide
        self.viewTransaction.delegate = self
    }
    
    // restore button setup
    
    private func setRestoreBtn_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.restoreBtn.isHidden = true
        self.restoreBtn.setTitle(localizedString_MTW(forKey: "restore"), for: .normal)
        self.restoreBtn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 14)
        self.restoreBtn.titleLabel?.setShadow_MTW()
        self.restoreBtn.tintColor = .white
        self.restoreBtn.setTitleColor(.white, for: .normal)
    }
    
    private func openApp_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        
        guard productBuy == .mainProduct else {
            dismiss(animated: true)
            return
        }
        
        let vc = TWPreloader_MTW.loadFromNib() // MainAppController()
        UIApplication.shared.setRootVC_MTW(vc)
        UIApplication.shared.notificationFeedbackGenerator_MTW(type: .success)
    }
    
    private func showRestore_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.restoreBtn.isHidden = false
        self.closeBtn.isHidden = productBuy == .mainProduct
    }
    
    @IBAction func restoreAction_MTW(_ sender: UIButton) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.viewTransaction.restoreAction_MTW()
    }
    
    @IBAction func closeController(_ sender: UIButton) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        openApp_MTW()
    }
    
    
}

extension PremiumMainController_MTW : ReusableViewEvent_MTW {
    func nextStep_MTW(config: configView_MTW) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        switch config {
        case .first:
            self.view0.fadeOut_MTW()
            self.view1.fadeIn_MTW()
            UIApplication.shared.impactFeedbackGenerator_MTW(type: .medium)
            ThirdPartyServicesManager_MTW.shared.makeATT_MTW()
        case .second:
            self.view1.fadeOut_MTW()
            self.viewTransaction.fadeIn_MTW()
            self.showRestore_MTW()
            UIApplication.shared.impactFeedbackGenerator_MTW(type: .medium)
        case .transaction: break
        }
    }
}

extension PremiumMainController_MTW : TransactionViewEvents_MTW {
    func userSubscribed_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        deinitOperation_MTW()
        self.openApp_MTW()
    }
    
    func transactionTreatment_MTW(title: String, message: String) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        print(#function,title,message)
        let alert = UIAlertController(title: NSLocalizedString("Text30ID", comment: ""), message: NSLocalizedString("Text31ID", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        UIApplication.shared.notificationFeedbackGenerator_MTW(type: .warning)
    }
    
    func transactionFailed_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        print(#function)
        UIApplication.shared.notificationFeedbackGenerator_MTW(type: .error)
    }
    
    func privacyOpen_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Configurations_MTW.policyLink.openURL_MTW()
    }
    
    func termsOpen_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Configurations_MTW.termsLink.openURL_MTW()
    }
}



