//
//  TWCharacterEditorController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

final class TWCharacterEditorController_MTW: TWBaseController_MTW {
    
    typealias CategoryCell = TWEditorCategoryCollectionViewCell_MTW
    typealias ContentCell = TWEditorElementCollectionViewCell_MTW
    
    typealias CategoryDataSource = UICollectionViewDiffableDataSource
    <Int, EditorCategory>
    
    typealias CategorySnapshot = NSDiffableDataSourceSnapshot
    <Int, EditorCategory>
    
    typealias ContentDataSource = UICollectionViewDiffableDataSource
    <Int, EditorContent>
    
    typealias ContentSnapshot = NSDiffableDataSourceSnapshot
    <Int, EditorContent>
    
    class func instantiate_MTW(character: TWCharacterPreview_MTW? = nil)
    -> TWCharacterEditorController_MTW {
        let controller = TWCharacterEditorController_MTW.loadFromNib()
        controller.character = character
        return controller
    }
    
    @IBOutlet private var vCharacter: UIImageView!
    @IBOutlet private var cvElement: UICollectionView!
    @IBOutlet private var cvCategory: UICollectionView!
    @IBOutlet private var lblCategory: UILabel!
    @IBOutlet private var vColorPicker: TWColorPicker_MTW!
    @IBOutlet private var btnDone: TWBaseButton_MTW!
    @IBOutlet private var vToolbar: TWEditorToolbarView!
    @IBOutlet private var ivBackBtn: UIImageView!
    @IBOutlet private var activityIndicator: TWActivityIndicator_MTW!
    
    var onSave: ((TWCharacterPreview_MTW) -> Void)?
    
    private var category: CategoryDataSource?
    private var content: ContentDataSource?
    
    private var preloader: TWAlertController_MTW?
    
    private var character: TWCharacterPreview_MTW?
    private var configurator: TWCharacterConfigurator_MTW!
    
    private var dropbox: TWDBManager_MTW {
        TWDBManager_MTW.shared
    }
    private var network: NetworkStatusMonitor_MTW { .shared }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureCharacterViewAndToolbar()
        configureView_MTWs()
        
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue {
                UIApplication.shared.setRootVC_MTW(TWContentSelectorController_MTW())
            }, animated: true)
            return
        }
        
        
        let title = NSLocalizedString("Text60ID", comment: "")
        let preloader = TWAlertController_MTW.indicator_MTW(title: title) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
        }
        
        present(preloader, animated: false) { [weak self] in
            self?.preloader = preloader
            self?.prepareContent()
        }
    }
    
    @IBAction func backButtonAction_MTW(_ sender: Any) {
        
        if configurator.isConfirmationRequired(for: character) {
            showDiscardChangesAlert()
            return
        }
        
        closeEditor()
    }
    
    @IBAction func doneButtonAction_MTW(_ sender: Any) {
        viewIsUserInteractive(false)
        vCharacter.alpha = 0.5
        activityIndicator.show_MTW()
        activityIndicator.rotateView()
        configurator.getCharacterImage(completion: { [weak self] image in
            guard let self = self else { return }
            self.vCharacter.image = image
            self.vCharacter.alpha = 1.0
            activityIndicator.layer.removeAllAnimations()
            activityIndicator.hide_MTW()
            let character =  self.configurator.character.preview!
            
            self.dropbox.contentManager.store(character: character)
            self.onSave?(character)
            self.closeEditor()
        })
    }
}

// MARK: - UICollectionViewDelegate

extension TWCharacterEditorController_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        switch collectionView {
        case cvCategory:
            guard let selectedItem = category?.itemIdentifier(for: indexPath),
                  configurator.selectedItem != selectedItem else { return }
            configurator.update(selectedItem: selectedItem)
            reloadToolbar()
        case cvElement:
            guard let selectedItem = content?.itemIdentifier(for: indexPath) else { return }
            if configurator.update(character: selectedItem) {
                beginUpdatingCharacterPreview()
                reloadToolbar()
            }
        default: break
        }
    }
    
}

// MARK: - Private API

private extension TWCharacterEditorController_MTW {
    
    func configureView_MTWs() {
        configureDoneButton()
        configureCollectionView_MTWs()
        configureDataSource()
        configureActivityIndicator()
        
        network.delegate = self
    }
    
    func configureDoneButton() {
        let localizedTitle = NSLocalizedString("Text86ID",
                                               comment: "")
        btnDone.setAttributedTitle(TWAttributtedStrings_MTW
            .barAttrString(with: localizedTitle,
                           foregroundColor: TWColors_MTW.buttonForegroundColor),
                                       for: .normal)
    }
    
    func configureActivityIndicator() {
        activityIndicator.hide_MTW()
    }
    
    func configureCollectionView_MTWs() {
        configureCategoryCollectionView()
        configureContentCollectionView()
    }
    
    func beginUpdatingCharacterPreview() {
        view.isUserInteractionEnabled = false
        
        activityIndicator.show_MTW()
        activityIndicator.rotateView()
        activityIndicator.alpha = .zero
        
        UIView.animate(withDuration: 0.3, animations: {
            self.activityIndicator.alpha = 1.0
            self.vCharacter.alpha = 0.5
        }, completion: { _ in
            self.configurator.getCharacterImage { [weak self] image in
                self?.finishUpdatingCharacterPreview(image)
            }
        })
    }
    
    func finishUpdatingCharacterPreview(_ image: UIImage?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.vCharacter.image = image
            self.vCharacter.alpha = 1.0
            self.activityIndicator.alpha = .zero
        }, completion: { _ in
            self.activityIndicator.hide_MTW()
            self.activityIndicator.layer.removeAllAnimations()
            self.view.isUserInteractionEnabled = true
        })
    }
    
    func configureCategoryCollectionView() {
        cvCategory.delegate = self
        cvCategory.allowsMultipleSelection = false
        cvCategory.showsVerticalScrollIndicator = false
        cvCategory.showsHorizontalScrollIndicator = false
        cvCategory.collectionViewLayout = collectionViewLayout(item: 70.0)
        cvCategory.register(CategoryCell.self,
                            forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    }
    
    func configureContentCollectionView() {
        cvElement.delegate = self
        cvElement.allowsMultipleSelection = false
        cvElement.showsVerticalScrollIndicator = false
        cvElement.showsHorizontalScrollIndicator = false
        cvElement.collectionViewLayout = collectionViewLayout(item: 80.0)
        cvElement.register(ContentCell.self,
                           forCellWithReuseIdentifier: ContentCell.reuseIdentifier)
    }
    
    func collectionViewLayout(item size: CGFloat) -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = .init(top: 4.0,
                                                  left: .zero,
                                                  bottom: 4.0,
                                                  right: .zero)
        collectionViewLayout.minimumLineSpacing = 12.0
        collectionViewLayout.minimumInteritemSpacing = 12.0
        collectionViewLayout.itemSize = .init(width: size, height: size)
        
        return collectionViewLayout
    }
    
    func viewIsUserInteractive(_ newValue: Bool) {
        guard view.isUserInteractionEnabled != newValue else { return }
        view.isUserInteractionEnabled = newValue
    }
    
    func updateViewState() {
        switch configurator.selectedItem {
        case .color:
            let localizedTitle = configurator.selectedItem.localizedTitle
            lblCategory.attributedText = TWAttributtedStrings_MTW
                .colorPickerTitleAttrString(with: localizedTitle,
                                            foregroundColor: TWColors_MTW.navigationBarBackground)
            cvElement.alpha = .zero
            cvElement.hide_MTW()
            configureColorPicker(configurator.character.color,
                                 visibility: true)
        case .content:
            let localizedTitle = configurator.selectedItem.localizedTitle
            lblCategory.attributedText = TWAttributtedStrings_MTW
                .colorPickerTitleAttrString(with: localizedTitle,
                                            foregroundColor: TWColors_MTW.navigationBarBackground)
            cvElement.alpha = 1.0
            cvElement.show_MTW()
            configureColorPicker(configurator.character.color,
                                 visibility: false)
        }
    }
    
    func configureColorPicker(_ color: TWCharacterColor_MTW,
                              visibility isVisible: Bool) {
        vColorPicker.visibility(isVisible: isVisible)
        vColorPicker.configure_MTW(color: color)
        vColorPicker.didSelectColor = { [weak self] color in
            if self?.configurator.update(color: color) == true {
                self?.beginUpdatingCharacterPreview()
                self?.reloadToolbar()
            }
        }
    }
    
    func configureDataSource() {
        configureCategoryDataSource()
        configureContentDataSource()
    }
    
    func configureCategoryDataSource() {
        category = CategoryDataSource(collectionView: cvCategory) {
            [weak self] collectionView, indexPath, category in
            if let self,
               let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                     for: indexPath) as? CategoryCell {
                cell.configure(with: category,
                               isSelected: self.configurator.selectedItem == category)
                return cell
            }
            
            return nil
        }
    }
    
    func configureContentDataSource() {
        content = ContentDataSource(collectionView: cvElement) {
            [weak self] collectionView, indexPath, content in
            if let self,
               let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdentifier,
                                     for: indexPath) as? ContentCell {
                var isSelected = false
                switch content {
                case .remove(let contentType):
                    isSelected = self.configurator.isRemoved(contentType)
                case .update(let model):
                    isSelected = self.configurator.isSelected(model)
                }
                
                cell.configure(with: content, isSelected: isSelected)
                
                return cell
            }
            
            return nil
        }
    }
    
    func configureCharacterViewAndToolbar() {
        if let preview = character?.image { vCharacter.image = preview }
        
        for view in [vToolbar, btnDone] { view?.hide_MTW() }
        
        cvElement.hide_MTW()
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
            
            guard let configurator = TWCharacterConfigurator_MTW
                .init(content: content,
                      character: character) else {
                showErrorAndCloseEditor()
                return
            }
            
            self.configurator = configurator
            
            if vCharacter.image == nil {
                self.configurator.getCharacterImage { image in
                    self.vCharacter.image = image
                    self.prepareEditorTools()
                    self.preloader?.dismissWithFade_MTW()
                }
                return
            }
            
            self.preloader?.dismiss(animated: false)
            self.prepareEditorTools()
        }
    }
    
    func showErrorAndCloseEditor() {
        let title = NSLocalizedString("Text81ID", comment: "")
        let message = NSLocalizedString("Text82ID", comment: "")
        let okTitle = NSLocalizedString("Text33ID", comment: "")
        
        let alert = TWAlertController_MTW
            .show_MTW(with: title,
                         message: message,
                         leading: .init(title: okTitle,
                                        handler: { [weak self] in
                self?.closeEditor()
            }))
        
        present(alert, animated: true)
    }
    
    func closeEditor() {
        navigationController?.popViewController(animated: true)
    }
    
    func showDiscardChangesAlert() {
        let title = NSLocalizedString("Text35ID", comment: "")
        let message = NSLocalizedString("Text83ID", comment: "")
        let closeTitle = NSLocalizedString("Text37ID", comment: "")
        let deleteTitle = NSLocalizedString("Text38ID", comment: "")
        
        let alert = TWAlertController_MTW
            .show_MTW(with: title,
                         message: message,
                         leading: .init(title: closeTitle),
                         trailing: .init(title: deleteTitle,
                                         style: .desctructive,
                                         handler: { [weak self] in
                self?.closeEditor()
            }))
        
        present(alert, animated: true)
    }
    
    func prepareEditorTools() {
        for view in [vToolbar, btnDone] {
            view?.show_MTW()
            view?.alpha = .zero
        }
        
        updateViewState()
        applySnapshots()
        
        UIView.animate(withDuration: 0.3, animations: {
            for view in [self.vToolbar, self.btnDone] { view?.alpha = 1.0 }
        })
    }
    
    func reloadToolbar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateViewState()
        }, completion: { _ in
            self.applySnapshots()
        })
    }
    
    func applySnapshots() {
        self.applyCategorySnapshot()
        self.applyElementSnapshot()
    }
    
    func applyCategorySnapshot() {
        var snapshot = CategorySnapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(configurator.items)
        
        category?.apply(snapshot, animatingDifferences: true)
        cvCategory.reloadData()
    }
    
    func applyElementSnapshot() {
        var snapshot = ContentSnapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(configurator.elements)
        
        content?.apply(snapshot, animatingDifferences: true)
        cvElement.reloadData()
    }
    
}

// MARK: - TWEditorCollectionViewCell_MTW

final class TWEditorCategoryCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    private var ivContent = UIImageView()
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        contentView.addSubview(ivContent)
        ivContent.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        ivContent.layer.cornerRadius = bounds.height / 2
    }
    
    func configure(with category: EditorCategory,
                   isSelected: Bool = false) {
        let category = isSelected ? category.preview : category.previewPurple
        setImage(category, isSelected: isSelected)
    }
    
    func setImage(_ image: UIImage?, isSelected: Bool) {
        ivContent.image = image
        ivContent.contentMode = .scaleAspectFit
        ivContent.backgroundColor = TWColors_MTW.contentSelectorCellBackground
    }
    
}

final class TWEditorElementCollectionViewCell_MTW: TWBaseCollectionViewCell_MTW {
    
    private var ivContent = UIImageView()
    private var setBackground: UIColor = .clear
    private var setShadow: UIColor = .clear
    private let radius = 24.0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setBackground = .clear
        setShadow = .clear
    }
    
    override var adjustedRect: CGRect {
        .init(x: 3,
              y: 3,
              width: bounds.width - 3,
              height: bounds.height - 3)
    }
    
    override var adjustedShadowRect: CGRect {
        .init(x: 0,
              y: 0,
              width: bounds.width - 5,
              height: bounds.height - 5)
    }
    
    override var backgroundFillColor: UIColor {
        setShadow
    }
    
    override var shadowBackgroundColor: UIColor {
        setBackground
    }
    
    override func commonInit_MTW() {
        super.commonInit_MTW()
        
        contentView.addSubview(ivContent)
        contentView.clipsToBounds = true
        
        ivContent.snp.makeConstraints { $0.edges.equalToSuperview().inset(8.0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = bounds.height / 2
    }
    
    override func drawBackgroundLayer_MTW() {
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - radius))
        path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: radius, y: bounds.height))
        path.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = borderWidth
        mask.strokeColor = UIColor.black.cgColor
        mask.fillColor = nil
        
        gradientLayer.removeFromSuperlayer()
        gradientLayer = {
            let layer = CAGradientLayer()
            
            layer.frame = bounds
            layer.colors = gradientColors
            layer.startPoint = gradientStartPoint
            layer.endPoint = gradientEndPoint
            layer.mask = mask
            
            return layer
        }()
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundFillColor.setFill()
        
        path.fill()
        
        
    }
    
    func configure(with content: EditorContent,
                   isSelected: Bool = false) {
        switch content {
        case .remove:
            emptyCell(isSelected: isSelected)
        case .update(let item):
            setImage(item.data?.preview, isSelected: isSelected)
        }
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        ivContent.image = nil
        ivContent.hide_MTW()
        
        setBackground = color
        setShadow = color.darker(by: 20)
                
        set(isSelected: isSelected)
    }
    
    private func emptyCell(isSelected: Bool) {
        ivContent.image = nil
        setShadow = TWColors_MTW.navigationBarForeground
        setBackground = TWColors_MTW.navigationBarForeground
        set(isSelected: isSelected)
    }
    
    private func setImage(_ image: UIImage?, isSelected: Bool) {
        ivContent.image = image
        ivContent.contentMode = .scaleAspectFit
        
        setBackground = isSelected ? TWColors_MTW.menuOrangeCellShadow : TWColors_MTW.menuPurpleCellShadow
        setShadow = isSelected ? TWColors_MTW.menuOrangeCellBackground : TWColors_MTW.menuPurpleCellBackground
    }
    
    private func set(isSelected: Bool) {
        layer.cornerRadius = radius
        layer.borderWidth = 4.0
        layer.borderColor = isSelected
        ? TWColors_MTW.searchBarForeground.cgColor
        : UIColor.clear.cgColor
    }
    
}

// MARK: - NetworkStatusMonitorDelegate_MTW

extension TWCharacterEditorController_MTW: NetworkStatusMonitorDelegate_MTW {
    
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
