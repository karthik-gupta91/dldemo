//
//  NetworkClient.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import Alamofire

protocol RemoteClientProtocol {
    func requestData(api:String,parameters:[String: Any], completion:@escaping (_ data:Data?,_ error:Error?) -> (Void))
}

class RemoteClient: NSObject, RemoteClientProtocol {
    
    func requestData(api: String, parameters: [String : Any], completion: @escaping (Data?, Error?) -> (Void)) {
        Alamofire.request(api, parameters: parameters).responseJSON { response in
            response.error == nil ? completion(response.data, nil) : completion(nil,response.error)
        }
    }
    
}
