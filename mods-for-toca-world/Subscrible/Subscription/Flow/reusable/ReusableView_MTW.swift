//  Created by Systems
//


import UIKit

enum configView_MTW {
    case first,second,transaction
}

protocol ReusableViewEvent_MTW : AnyObject {
    func nextStep_MTW(config: configView_MTW)
}


struct ReusableViewModel_MTW {
    var title : String
    var items : [ReusableContentCell_MTW]
}

struct ReusableContentCell_MTW {
    var title : String
    var image : UIImage
    var selectedImage: UIImage
}

class ReusableView_MTW: UIView, AnimatedButtonEvent_MTW {
    func onClick_MTW() {
        self.protocolElement?.nextStep_MTW(config: self.configView_MTW)
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var content: UICollectionView!
    @IBOutlet private weak var nextStepBtn: AnimatedButton_MTW!
    @IBOutlet private weak var titleWight: NSLayoutConstraint!
    @IBOutlet private weak var buttonBottom: NSLayoutConstraint!
    
    weak var protocolElement : ReusableViewEvent_MTW?
    
    public var configView_MTW : configView_MTW = .first
    public var viewModel : ReusableViewModel_MTW? = nil
    private let cellName = "ReusableCell_MTW"
    private var selectedStorage : [Int] = []
    private let multic: CGFloat = 0.94
    private let xib = "ReusableView_MTW"
    
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Init_MTW()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Init_MTW()
    }
    
    private func Init_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                // Устройство без физической кнопки "Home" (например, iPhone X и новее)
            } else {
                // Устройство с физической кнопкой "Home"
                buttonBottom.constant = 47
            }
        } else {
            buttonBottom.constant = 63
        }
        
        contentView.fixInView_MTW(self)
        nextStepBtn.delegate = self
        nextStepBtn.style = .native
        contentView.backgroundColor = .clear
        setContent_MTW()
        setConfigLabels_MTW()
        configScreen_MTW()
    }
    
    private func setContent_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        content.dataSource = self
        content.delegate = self
        content.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        content.backgroundColor = .clear
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    private func setConfigLabels_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        titleLb.setShadow_MTW()
        
        titleLb.textColor = .white
        titleLb.font = UIFont(name: "SFProText-Bold", size: 26)
//        titleLb.lineBreakMode = .byWordWrapping
        titleLb.adjustsFontSizeToFitWidth = true
    }
    
    public func setConfigView_MTW(config: configView_MTW) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.configView_MTW = config
    }
    
    private func setLocalizable_MTW(){
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        self.titleLb.text = viewModel?.title
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
            titleWight.setValue(0.35, forKey: "multiplier")
        } else {
            titleWight.setValue(0.7, forKey: "multiplier")
        }
    }
    
    private func getLastElement_MTW() -> Int {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return (viewModel?.items.count ?? 0) - 1
    }
}

extension ReusableView_MTW : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        setLocalizable_MTW()
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        let cell = content.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! TWReusableCell_MTW
        let content = viewModel?.items[indexPath.item]
        cell.cellLabel.text = content?.title
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            cell.cellImage.image = content?.selectedImage
        } else {
            cell.cellImage.image = content?.image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            selectedStorage.removeAll(where: {$0 == indexPath.item})
        } else {
            selectedStorage.append(indexPath.row)
        }
        
       
        UIApplication.shared.impactFeedbackGenerator_MTW(type: .light)
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
        if indexPath.last == getLastElement_MTW() {
            collectionView.scrollToLastItem_MTW(animated: false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return selectedStorage.contains(indexPath.row) ? CGSize(width: collectionView.frame.height * 0.8, height: collectionView.frame.height) : CGSize(width: collectionView.frame.height * 0.7, height: collectionView.frame.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
}
