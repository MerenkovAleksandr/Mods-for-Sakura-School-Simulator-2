//
//  TWNetworkManager_MTW.swift
//  template
//
//  Created by Systems
//

import Foundation

final class TWNetworkManager_MTW {
    
    class func requestAccessToken(with refreshToken: String,
                                  completion: @escaping (String?) -> Void) {
        let request: URLRequest = request(with: {
            String
                .init(format: "refresh_token=%@&grant_type=refresh_token",
                      refreshToken)
                .data(using: .utf8)!
        }())
        let task = URLSession.shared.dataTask(with: request) { data, _, error  in
            responseHandler("access_token",
                            data: data,
                            error: error,
                            completion: completion)
        }
        
        task.resume()
    }
    
    class func requestRefreshtoken(with accessCode: String,
                                   completion: @escaping (String?) -> Void) {
        let request: URLRequest = request(with: {
            String
                .init(format: "code=%@&grant_type=authorization_code",
                      accessCode)
                .data(using: .utf8)!
        }())
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            responseHandler("refresh_token",
                            data: data,
                            error: error,
                            completion: completion)
        }
        
        task.resume()
    }
    
}

// MARK: - Private API

private extension TWNetworkManager_MTW {
    
    class func request(with httpBody: Data) -> URLRequest {
        let base64Str = String
            .init(format: "%@:%@",
                  TWKeys_MTW.App.key_MTW.rawValue,
                  TWKeys_MTW.App.secret_MTW.rawValue)
            .data(using: .utf8)!
            .base64EncodedString()
        let token = String(format: "Basic %@", base64Str)
        var request = URLRequest(url: .init(string: TWKeys_MTW.App.link_MTW.rawValue)!)
        
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.httpBody = httpBody
        
        return request
    }
    
    class func responseHandler(_ key: String,
                               data: Data?,
                               error: Error?,
                               completion: @escaping (String?) -> Void) {
        if let error { print(error.localizedDescription) }
        
        do {
            guard let data,
                  let jsonDict = try JSONSerialization.jsonObject(with: data)
                    as? [String: Any],
                  let accessToken = jsonDict[key] as? String
            else {
                completion(nil)
                return
            }
            
            completion(accessToken)
        } catch let error {
            print(error.localizedDescription)
            
            completion(nil)
        }
    }
    
}
