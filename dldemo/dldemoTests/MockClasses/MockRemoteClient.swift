//
//  MockRemoteClient.swift
//  dldemoTests
//
//  Created by kartik on 31/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import Foundation
@testable import dldemo

class MockRemoteClient: NSObject, RemoteClientProtocol {
    var deliveryList: [DeliveryInfo]!
    var wrongDecoding:Bool = false
    var simulateNetworkError:Bool = false
    
    func requestData(api: String, parameters: [String : Any], completion: @escaping (Data?, Error?) -> (Void)) {
        if simulateNetworkError {
            completion(nil,nil)
            return
        } else if wrongDecoding {
            let data = "jadoo".data(using: .utf8)
            completion(data,nil)
            return
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(deliveryList)
            completion(data,nil)
            return
        } catch {
            completion(nil,error)
            return
        }
    }
}
