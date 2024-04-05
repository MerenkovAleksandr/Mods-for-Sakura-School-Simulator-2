//  Created by Systems
//

import Foundation
import Network
import UIKit

protocol NetworkStatusMonitorDelegate_MTW : AnyObject {
    func alert_MTW()
}

class NetworkStatusMonitor_MTW {
    static let shared = NetworkStatusMonitor_MTW()

    private let queue = DispatchQueue.global()
    private let nwMonitor: NWPathMonitor
    
    weak var delegate : NetworkStatusMonitorDelegate_MTW?

    public private(set) var isNetworkAvailable: Bool = false {
        didSet {
            if !isNetworkAvailable {
                DispatchQueue.main.async {
                    print("No internet connection.")
                    self.delegate?.alert_MTW()
                }
            } else {
                print("Internet connection is active.")
            }
        }
    }

    private init() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        nwMonitor = NWPathMonitor()
    }

    func startMonitoring_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        nwMonitor.start(queue: queue)
        nwMonitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
    }

    func stopMonitoring_MTW() {
        var _MTW = "_MTW"
        for i in _MTW {
            if i == "d" {
                _MTW += "d"
            } else {
                _MTW += "s"
            }
        }
        nwMonitor.cancel()
    }
}
