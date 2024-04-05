//
//  TWDBManager_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation
import Combine
import SwiftyDropbox

final class TWDBManager_MTW: NSObject {
    
    static let shared = TWDBManager_MTW()
    
    let contentManager = TWContentManager_MTW()
    
    var progressPublisher: AnyPublisher<String, Never> {
        progressSubject.eraseToAnyPublisher()
    }
    
    private var progressSubject = PassthroughSubject<String, Never>()
    private var client: DropboxClient?
    
}

// MARK: - Public API

extension TWDBManager_MTW {
    
    var dropbox: TWDBManager_MTW { .shared }
    
    func connect_mtw(completion: ((DropboxClient?) -> Void)? = nil) {
        print("TWDBManager_MTW - connect_mtw!")
        
        UserDefaults
            .standard
            .setValue("7iv_wkAcK80AAAAAAAAAAXLw5hg7EXQ4Ypt_AsEWv5uMcarHzfBpJTsp4YZkZlrg",
                      forKey: "refresh_token")
        
        let connect_mtwionBlock: (_ accessToken: String) -> Void = {
            [unowned self] accessToken in
            
            let client = connect_mtwoDropbox(with: accessToken)
            
            print("TWDBManager_MTW - connect_mtwed!")
            
            completion?(client)
        }
        
        let refreshTokenBlock: (_ refreshToken: String) -> Void = {
            refreshToken in
            TWNetworkManager_MTW.requestAccessToken(with: refreshToken) {
                accessToken in
                guard let accessToken else {
                    print("TWDBManager_MTW - Error acquiring access token")
                    
                    return
                }
                
                print("TWDBManager_MTW - AccessToken: \(accessToken)")
                
                connect_mtwionBlock(accessToken)
            }
        }
        
        if let refreshToken = UserDefaults
            .standard
            .string(forKey: "refresh_token") {
            refreshTokenBlock(refreshToken)
            return
        }
        
        TWNetworkManager_MTW
            .requestRefreshtoken(with: TWKeys_MTW.App.accessCode_MTW.rawValue) {
                refreshToken in
                guard let refreshToken else {
                    completion?(nil)
                    return
                }
                
                UserDefaults.setValue(refreshToken, forKey: "refresh_token")
                print("TWDBManager_MTW - Refreshtoken: \(refreshToken)")
                
                refreshTokenBlock(refreshToken)
            }
    }
    
    func fetchContent(for contentType: TWContentType_MTW,
                      completion: @escaping () -> Void) {
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            completion()
            return
        }
        
        let fetchBlock: (DropboxClient) -> Void = { [unowned self] client in
            let path = contentType.associatedPath.contentPath
            getFile(client: client, with: path) { [unowned self] data in
                guard let data else { completion(); return }
//                let json =  try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                contentManager.serialize(data: data, for: contentType)
                completion()
            }
        }
        
        if let client { fetchBlock(client); return }
        
        connect_mtw { client in
            guard let client else { completion(); return }
            fetchBlock(client)
        }
    }
    
    func fetchImage(for model: TWContentModel_MTW,
                    completion: @escaping (Data?) -> Void) {
        let fetchBlock: (DropboxClient) -> Void = { [unowned self] client in
            guard let imgPath = model.content.path else { return }
            let path = contentManager.getPath_MTW(for: model.contentType,
                                              imgPath: imgPath)
            getFile(client: client, with: path) { [unowned self] data in
                guard let data else {
                    completion(nil)
                    return
                }
                contentManager.store(model: model, data: data)
                completion(data)
            }
        }
        
        if let client { fetchBlock(client); return }
        
        connect_mtw { client in
            guard let client else { completion(nil); return }
            fetchBlock(client)
        }
    }
    
    func fetchEditorContent(completion: @escaping () -> Void) {
        guard TWInternetManager_MTW.shared.checkInternetConnectivity_MTW() else {
            completion()
            return
        }
        
        let fetchBlock: (DropboxClient) -> Void = { [unowned self] client in
            let pathKey = TWKeys_MTW.TWPath_MTW.editor
            let path = pathKey.contentPath
            getFile(client: client, with: path) { [unowned self] data in
                guard let data else {
                    completion()
                    return
                }
                let markups = contentManager.serialized(markups: data)
                
                if markups.isEmpty {
                    completion()
                    return
                }
                
                let dispatchGroup = DispatchGroup()
                var serializedContent = [(markup: TWEditorMarkup_MTW,
                                          model: TWEditorContentModel_MTW)]()
                
                for markup in markups {
                    dispatchGroup.enter()
                    let path = pathKey.getPath(forMarkup: markup.path)
                    getFile(with: path) { [unowned self] data in
                        if let data {
                            let content = contentManager
                                .serialize(markup: markup, data: data)
                           
                            serializedContent.append(contentsOf: content.map { (markup, $0) })
                        }
                        
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
                    [unowned self] in

                    fetchEditorContentData(for: serializedContent,
                                           with: client,
                                           completion: completion)
                }
            }
        }
        
        if let client { fetchBlock(client); return }
        
        connect_mtw { client in
            guard let client else { completion(); return }
            fetchBlock(client)
        }
    }
    
    func fetchEditorContentData(for serializedData: [(markup: TWEditorMarkup_MTW,
                                               model: TWEditorContentModel_MTW)],
                                with client: DropboxClient,
                                completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        var taskCount = 0
        
        if !serializedData.isEmpty {
            progressSubject.send("\(taskCount)/\(serializedData.count)")
        }
        
        for serialized in serializedData {
            dispatchGroup.enter()
            fetchData(for: serialized.model,
                      markup: serialized.markup,
                      client: client) { [weak self] in
                taskCount += 1
                self?.progressSubject.send("\(taskCount)/\(serializedData.count)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { completion() }
    }
    
    func fetchData(for model: TWEditorContentModel_MTW,
                   markup: TWEditorMarkup_MTW,
                   client: DropboxClient,
                   completion: @escaping () -> Void) {
        let pathKey = TWKeys_MTW.TWPath_MTW.editor
        let dispatchGroup = DispatchGroup()
        var fetchedData: Data?
        var fetchedPreview: Data?
        
        dispatchGroup.enter()
        let svgPath = pathKey.getPath(for: model.contentType,
                                                     markup: markup.path,
                                                     path: model.path.svgPath)
        getFile(client: client, with: svgPath) { data in
            fetchedData = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let elPth = pathKey.getPath(for: model.contentType,
                                    markup: markup.path,
                                    path: model.path.elPath)
        
        getFile(client: client, with: elPth) { data in
            fetchedPreview = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            [unowned self] in
            contentManager.store(model: model,
                                 data: fetchedData,
                                 preview: fetchedPreview)
            completion()
        }
    }
    
}

// MARK: - Private API

private extension TWDBManager_MTW {
    
    func connect_mtwoDropbox(with accessToken: String) -> DropboxClient {
        let client = DropboxClient(accessToken: accessToken)
        
        self.client = client
        
        return client
    }
    
    func getFile(with path: String, completion: @escaping (Data?) -> Void) {
        let block: (DropboxClient) -> Void = { client in
            client.files.download(path: path).response { response, error in
                if let error = error {
                    print(error.description)
                }
                completion(response?.1)
            }
        }
        
        if let client { block(client); return }
       
        connect_mtw { client in
            guard let client else {
                completion(nil)
                return
            }
            
            block(client)
        }
    }
    
    func getFile(client: DropboxClient,
                 with path: String,
                 completion: @escaping (Data?) -> Void) {
        client.files.download(path: path).response { response, error in
            if let error { print(error.description) }
            
            completion(response?.1)
        }
    }
    
    func getLink(client: DropboxClient,
                 path: String,
                 completion: @escaping (String?) -> Void) {
        client.files.getTemporaryLink(path: path).response { response, error in
            if let error { print(error.description) }
            
            completion(response?.link)
        }
    }
    
}
