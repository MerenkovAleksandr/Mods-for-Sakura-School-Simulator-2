//  Created by Systems
//


import UIKit

protocol TransactionViewEvents_MTW : AnyObject {
    func userSubscribed_MTW()
    func transactionTreatment_MTW(title: String, message: String)
    func transactionFailed_MTW()
    func privacyOpen_MTW()
    func termsOpen_MTW()
}

class TransactionView_MTW: UIView,AnimatedButtonEvent_MTW,IAPManagerProtocol_MTW, NetworkStatusMonitorDelegate_MTW {
    func alert_MTW() {
        transactionTreatment_MTW(title: NSLocalizedString( "Text30ID", comment: ""), message: NSLocalizedString("Text31ID", comment: ""))
    }
    
    
    private let xib = "TransactionView_MTW"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private(set) weak var title: UILabel!
    @IBOutlet private weak var sliderStack: UIStackView!
    @IBOutlet private weak var trialStar: UIImageView!
    @IBOutlet private weak var trialLb: UILabel!
    @IBOutlet private weak var descriptLb: UILabel!
    @IBOutlet private weak var purchaseBtn: AnimatedButton_MTW!
    @IBOutlet private weak var privacyBtn: UIButton!
    @IBOutlet private weak var policyBtn: UIButton!
    @IBOutlet private weak var trialWight: NSLayoutConstraint!
    @IBOutlet private weak var sliderWight: NSLayoutConstraint!
    @IBOutlet private weak var sliderTop: NSLayoutConstraint!
    @IBOutlet private weak var conteinerWidth: NSLayoutConstraint!
    @IBOutlet private weak var heightView: NSLayoutConstraint!
    
    
    private let currentFont = "SFProText-Bold"
    public let inapp = IAPManager_MTW.shared
    private let locale = NSLocale.current.languageCode
    public weak var delegate : TransactionViewEvents_MTW?
    private let networkingMonitor = NetworkStatusMonitor_MTW.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Init()
    }
    
    private func Init() {
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                heightView.constant = 163
            } else {
//                sliderTop.constant = 60
                heightView.constant = 152
            }
        } else {
            conteinerWidth.constant = 400
            heightView.constant = 167
//            sliderTop.constant = 45
        }
        contentView.fixInView_MTW(self)
        contentView.backgroundColor = .clear
        buildConfigs_TOC()
    }
    
    private func buildConfigs_TOC(){
        configScreen_MTW()
        setSlider_TOC()
        setConfigLabels_MTW()
        setConfigButton_MTW()
        setLocalization_MTW()
        configsInApp_MTW()
    }
    
    private func setSlider_TOC(){
        
        title.text = (localizedString_MTW(forKey: "SliderID1").uppercased())
        let texts: [String] = ["\(localizedString_MTW(forKey: "SliderID2").uppercased())",
                               "\(localizedString_MTW(forKey: "SliderID3").uppercased())",
                               "\(localizedString_MTW(forKey: "SliderID4").uppercased())",
                               ]
        for t in texts {
            sliderStack.addArrangedSubview(SliderCellView(title: t, subTitle: t))
        }
    }
    
    //MARK: config labels
    
    private func setConfigLabels_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        //slider
        title.textColor = .white
        title.font = UIFont(name: currentFont, size: 21)
//        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 4
        title.setShadow_MTW()
        title.lineBreakMode = .byClipping
        if UIDevice.current.userInterfaceIdiom == .pad {
            title.font = UIFont(name: currentFont, size: 21)
        }
        trialLb.setShadow_MTW()
        trialLb.font = UIFont(name: currentFont, size: 13)
        trialLb.textColor = .white
        trialLb.textAlignment = .center
        trialLb.numberOfLines = 2
        trialLb.adjustsFontSizeToFitWidth = true
        
        descriptLb.setShadow_MTW()
        descriptLb.textColor = .white
        descriptLb.textAlignment = .center
        descriptLb.numberOfLines = 0
        descriptLb.font = UIFont.systemFont(ofSize: 15)
        
        privacyBtn.titleLabel?.setShadow_MTW()
        privacyBtn.titleLabel?.numberOfLines = 2
        privacyBtn.titleLabel?.textAlignment = .center
        
        privacyBtn.setTitleColor(.white, for: .normal)
        privacyBtn.tintColor = .white
        
        policyBtn.titleLabel?.setShadow_MTW()
        policyBtn.titleLabel?.numberOfLines = 2
        policyBtn.titleLabel?.textAlignment = .center
        policyBtn.setTitleColor(.white, for: .normal)
        policyBtn.tintColor = .white
    }
    
    //MARK: config button
    
    private func setConfigButton_MTW(){
        self.purchaseBtn.delegate = self
        self.purchaseBtn.style = .native
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.purchaseBtn.setPulseAnimation_MTW()
        }
    }
    
    //MARK: config localization
    
    public func setLocalization_MTW() {
        
//        title.labelTextsForSlider = "\(localizedString(forKey: "SliderID1").uppercased())|n\(localizedString(forKey: "SliderID2").uppercased())|n\(localizedString(forKey: "SliderID3").uppercased()) |n\(localizedString(forKey: "SliderID4").uppercased()) |n\(localizedString(forKey: "SliderID5").uppercased())"
        
        let description = localizedString_MTW(forKey: "iOSAfterID")
        let localizedPrice = inapp.localizedPrice_MTW()
        descriptLb.text = String(format: description, localizedPrice)
        
        if locale == "en" {
            trialLb.text = "Start 3-days for FREE\n Then \(localizedPrice)/week".uppercased()
        } else {
            trialLb.text = ""
        }
        trialStar.isHidden = trialLb.text?.isEmpty ?? true
        privacyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        privacyBtn.setAttributedTitle(localizedString_MTW(forKey: "TermsID").underLined, for: .normal)
        policyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        policyBtn.setAttributedTitle(localizedString_MTW(forKey: "PrivacyID").underLined, for: .normal)
    }
    
    //MARK: screen configs
    
    private func configScreen_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            trialWight.setValue(0.28, forKey: "multiplier")
            sliderWight.setValue(0.5, forKey: "multiplier")
        } else {
            trialWight.setValue(0.46, forKey: "multiplier")
            sliderWight.setValue(0.8, forKey: "multiplier")
        }
    }
    
    //MARK: configs
    
    private func configsInApp_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.inapp.transactionsDelegate_MTW = self
        self.networkingMonitor.delegate = self
    }
    
    public func restoreAction_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        inapp.doRestore_MTW()
    }
    
    //MARK: actions
    
    @IBAction func privacyAction_MTW(_ sender: UIButton) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.delegate?.termsOpen_MTW()
    }
    
    @IBAction func termsAction_MTW(_ sender: UIButton) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.delegate?.privacyOpen_MTW()
    }
    
    func onClick_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        UIApplication.shared.impactFeedbackGenerator_MTW(type: .heavy)
        networkingMonitor.startMonitoring_MTW()
        inapp.doPurchase_MTW()
        purchaseBtn.isUserInteractionEnabled = false
    }
    
    //inapp
    
    func transactionTreatment_MTW(title: String, message: String) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionTreatment_MTW(title: title, message: message)
    }
    
    func infoAlert_MTW(title: String, message: String) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionTreatment_MTW(title: title, message: message)
    }
    
    func goToTheApp_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.userSubscribed_MTW()
    }
    
    func failed_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionFailed_MTW()
    }
}
