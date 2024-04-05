//
//  TWSoundsCollectionController_MTW.swift
//  template
//
//  Created by Systems
//

import UIKit
import AVFoundation
import Combine

final class TWSoundsCollectionController_MTW: TWContentPlainCollectionController_MTW {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TWContentModel_MTW>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TWContentModel_MTW>
    typealias Cell = TWPlainTextCollectionViewCell_MTW
    
    private var content = [TWContentModel_MTW]()
    private var dataSource: DataSource?
    
    private var notificationCenter: NotificationCenter { .default }
    private var cancellables = Set<AnyCancellable>()
    private var player = AVAudioPlayer()
    
    override var localizedTitle: String {
        TWContentType_MTW.sound.localizedTitle
    }
    
    override var leadingBarIcon: UIImage? {
        #imageLiteral(resourceName: "icon_navigation_home")
    }
    
    override func didTapLeadingBarBtn() {
        goToContentSelector()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        configureAVSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            present(UIAlertController.connectionIssue { [weak self] in
                self?.showContentPreloader()
            }, animated: true)
            return
        }
        
        if dropbox.contentManager.isContentReady(for: .sound) {
            loadContent()
            fetchContentFromDropbox { [weak self] in
                self?.loadContent()
            }
            return
        }
        
        showContentPreloader()
    }
    
    override func showContentPreloader() {
        let preloader = TWAlertController_MTW.loadingIndicator { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        present(preloader, animated: false) { [weak self] in
            self?.dropbox.fetchContent(for: .sound) { [weak self] in
                DispatchQueue.main.async {
                    preloader.dismissWithFade_MTW {
                        self?.loadContent()
                    }
                }
            }
        }
    }
    
    override func registerCells() {
        collectionView.register(Cell.classForCoder(),
                                forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    override func generateLayoutPhone() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: .zero, leading: 42.0, bottom: .zero, trailing: 42.0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func generateLayoutPad() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(120.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = .init(top: .zero, leading: 80.0, bottom: .zero, trailing: 80.0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func configureController() {
        configureDataSource()
    }
    
    override func layoutCollectionView() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        guard content[indexPath.row].content.data != nil else { return }
        playMusic(for: content[indexPath.row])
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        let model = content[indexPath.row]

        if model.content.data == nil {
            loadFile(for: model)
        }

        if indexPath.row == (self.content.count - 1),
           !isContentLimitReached {
            loadNextPage()
        }
    }
    
}

// MARK: - AVAudioPlayerDelegate

extension TWSoundsCollectionController_MTW: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        stopPlayer()
    }
    
}

// MARK: - Private extension

private extension TWSoundsCollectionController_MTW {
    
    func loadContent() {
        content = contentManager.fetchContent(contentType: .sound,
                                              page: currentPage)
        applySnapshot()
    }
    
    func fetchContentFromDropbox(completion: @escaping () -> Void) {
        TWDBManager_MTW.shared.fetchContent(for: .sound) {
            DispatchQueue.main.async { completion() }
        }
    }
    
    func addObservers() {
        [notificationCenter
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.stopPlayer()
            },
         notificationCenter
            .publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.stopPlayer()
            }
        ].forEach { $0.store(in: &cancellables) }
    }
    
    func configureAVSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            if let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                     for: indexPath) as? Cell {
                let localizedTitle = NSLocalizedString("Text59ID", comment: "")
                let title = String(format: "%@ %i",
                                   localizedTitle,
                                   indexPath.row + 1)
                cell.configure_MTW(with: title, isLoading: item.content.data == nil)
                return cell
            }
            
            return nil
        }
    }
    
    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(content)
        
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func loadNextPage() {
        let fetchContent = contentManager.fetchContent(contentType: .sound,
                                                       page: currentPage + 1)
        
        guard fetchContent != content else {
            isContentLimitReached = true
            return
        }
        
        currentPage += 1
        
        content = fetchContent
        
        applySnapshot()
    }
    
    func loadFile(for model: TWContentModel_MTW) {
        dropbox.fetchImage(for: model, completion: { [weak self] data in
            guard let self,
                  let data
            else { return }
            
            var newModel = model
            newModel.addImage_MTW(data)
            
            guard let index = content
                .firstIndex(where: { $0.id == model.id }) else { return }
            content[index] = newModel
            
            updateFile(for: newModel)
        })
    }
    
    func updateFile(for model: TWContentModel_MTW) {
        guard let indexPath = dataSource?.indexPath(for: model),
              let cell = collectionView.cellForItem(at: indexPath) as? Cell
        else { return }
        
        cell.configure_MTW(with: String(format: "%@ %i", "Sound",
                                    indexPath.row + 1),
                       isLoading: model.content.data == nil)
        
    }
    
    func playMusic(for model: TWContentModel_MTW) {
        guard let data = model.content.data else { return }
        
        do {
            player = try AVAudioPlayer(data: data,
                                       fileTypeHint: AVFileType.mp3.rawValue)
            player.delegate = self
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayer() {
        player.stop()
//        collectionView.reloadData()
    }
    
    func goToContentSelector() {
        navigationController?.popViewController(animated: false)
    }
}
