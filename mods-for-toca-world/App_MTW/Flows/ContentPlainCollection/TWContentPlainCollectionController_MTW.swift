//
//  TWContentPlainCollectionController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit

class TWContentPlainCollectionController_MTW: TWNavigationController_MTW {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TWContentModel_MTW>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TWContentModel_MTW>
    typealias Cell = TWContentPlainCollectionViewCell_MTW
    
    var collectionView: UICollectionView!
    var currentPage = 1
    var isContentLimitReached = false
    
    private var content = [TWContentModel_MTW]()
    private var dataSource: DataSource?
    
    var dropbox: TWDBManager_MTW { .shared }
    var contentManager: TWContentManager_MTW { dropbox.contentManager }
    
    override var localizedTitle: String {
        TWContentType_MTW.guide.localizedTitle
    }
    
    override var leadingBarIcon: UIImage? {
        #imageLiteral(resourceName: "icon_navigation_home")
    }
    
    override func didTapLeadingBarBtn() {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView_MTW()
        layoutCollectionView()
        registerCells()
        configureController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue { [weak self] in
                self?.showContentPreloader()
            }, animated: true)
            return
        }
        
        if dropbox.contentManager.isContentReady(for: .guide) {
            loadContent()
            fetchContentFromDropbox { [weak self] in
                self?.loadContent()
            }
            return
        }
        
        showContentPreloader()
    }
    
    func showContentPreloader() {
        let preloader = TWAlertController_MTW.loadingIndicator { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        present(preloader, animated: false) { [weak self] in
            self?.dropbox.fetchContent(for: .guide) { [weak self] in
                DispatchQueue.main.async {
                    preloader.dismissWithFade_MTW {
                        self?.loadContent()
                    }
                }
            }
        }

    }
    
    func registerCells() {
        collectionView.register(Cell.nib,
                                forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func configureController() {
        configureDataSource()
    }
    
    func generateLayoutPhone() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.17))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
//        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    func generateLayoutPad() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.15))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: .zero,
                                    leading: 48.0,
                                    bottom: .zero,
                                    trailing: 48.0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func navigate(to item: TWContentModel_MTW) {
        let controller = TWContentDetailsController_MTW
            .instantiate_MTW(selectedItem: item)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func layoutCollectionView() {
        let multiplier: CGFloat = iPad ? 0.75 : 0.9
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(multiplier)
            $0.bottom.equalToSuperview()
        }
    }
    
    func generateLayout() -> UICollectionViewLayout {
        iPad ? generateLayoutPad() : generateLayoutPhone()
    }
    
}

// MARK: - UICollectionViewDelegate

extension TWContentPlainCollectionController_MTW: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot() else { return }
        
        let model = snapshot.itemIdentifiers[indexPath.row]
        
        guard let item = content.first(where: {
            $0.id == model.id }) else { return }
        
        navigate(to: item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let model = content[indexPath.row]
        
        if model.content.image == nil {
            loadImage(for: model)
        }
        
        if indexPath.row == (self.content.count - 1),
           !isContentLimitReached {
            loadNextPage()
        }
    }
    
}

// MARK: - Private extension

private extension TWContentPlainCollectionController_MTW {
    
    func configureCollectionView_MTW() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: generateLayout())
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        vContent.addSubview(collectionView)
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            if let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                     for: indexPath) as? Cell {
                cell.configure_MTW(with: item)
                
                return cell
            }
            
            return nil
        }
    }
    
    func loadContent() {
        content = contentManager.fetchContent(contentType: .guide,
                                              page: currentPage)
        applySnapshot()
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(content)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func loadNextPage() {
        let fetchContent = contentManager.fetchContent(contentType: .guide,
                                                       page: currentPage + 1)
        
        guard fetchContent != content else {
            isContentLimitReached = true
            return
        }
        
        currentPage += 1
        
        content = fetchContent
        
        applySnapshot()
    }
    
    func loadImage(for model: TWContentModel_MTW) {
        dropbox.fetchImage(for: model, completion: { [weak self] data in
            guard let self,
                  let data
            else { return }
            
            var newModel = model
            newModel.addImage_MTW(data)
            
            guard let index = content
                .firstIndex(where: { $0.id == model.id }) else { return }
            content[index] = newModel
            
            self.updateImage(for: newModel)
        })
    }
    
    func updateImage(for model: TWContentModel_MTW) {
        guard let indexPath = dataSource?.indexPath(for: model),
              let cell = collectionView.cellForItem(at: indexPath) as? Cell
        else { return }
        
        cell.configure_MTW(with: model)
    }
    
    func fetchContentFromDropbox(completion: @escaping () -> Void) {
        TWDBManager_MTW.shared.fetchContent(for: .guide) {
            DispatchQueue.main.async { completion() }
        }
    }
}
