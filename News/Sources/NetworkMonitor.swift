//
//  NetworkMonitor.swift
//  News
//
//  Created by Bilal Durnagöl on 27.10.2020.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    public var isConnection: Bool = false
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self]path in
            if path.status == .satisfied {
                self?.isConnection = true
                print("Connected!")
            } else {
                self?.isConnection = false
                print("Not Connected!")
            }
        }
    }
    public func stopMonitoring() {
        monitor.cancel()
        print("cancel")
    }
}
