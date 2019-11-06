//
//  Reachability.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {

    private var reachability: Reachability!
    
    override init() {
        super.init()
    }

    func isReachable() -> Bool {
        do {
            reachability = try Reachability()
        } catch let error {
            print(error)
        }
        return reachability.connection != .unavailable
    }
    
}
