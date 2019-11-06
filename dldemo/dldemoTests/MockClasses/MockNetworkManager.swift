//
//  MockNetworkManager.swift
//  dldemoTests
//
//  Created by kartik on 31/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import Foundation
@testable import dldemo

class MockNetworkManager: NetworkManager {
    var isAvailable = false
    
    override func isReachable() -> Bool {
        return isAvailable
    }
}
