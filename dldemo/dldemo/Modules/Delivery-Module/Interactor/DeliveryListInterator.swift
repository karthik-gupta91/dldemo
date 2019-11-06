//
//  DeliveryListInterator.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation

protocol PresenterToInteractorProtocol: class {
    func fetchDataOnline(_ offset:Int,_ limit:Int)
    func fetchOfflineCache(_ offset:Int,_ limit:Int)
}

class DeliveryListInterator: PresenterToInteractorProtocol {
    
    private weak var presenter: InteractorToPresenterProtocol!
    private var remoteClient : RemoteClientProtocol!
    private var cdProtocol: InteractorToCDProtocol!
    
    init(remoteClient:RemoteClientProtocol, presenter:InteractorToPresenterProtocol, cdProtocol:InteractorToCDProtocol) {
        self.remoteClient = remoteClient
        self.presenter = presenter
        self.cdProtocol = cdProtocol
    }
    
    private var error: AppError = AppError.offlineError
    
    func fetchDataOnline(_ offset:Int,_ limit:Int) {
        let parameters = [
            Constants.OFFSET: offset,
            Constants.LIMIT: limit
        ]
        self.remoteClient.requestData(api: APIService.DELIVERY_LIST, parameters: parameters) {[weak self] (data, error) -> (Void) in
            guard let self = self else {
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode([DeliveryInfo].self, from:
                        data)
                    if model.isEmpty {
                        self.error = AppError.emptyDataError
                        self.presenter?.deliveryFetchFailed(self.error)
                    } else {
                        self.cdProtocol?.saveUpdateDeliveryListfromCD(model)
                        self.presenter?.deliveryFetchSuccess(deliveryList: model)
                    }
                } catch {
                    self.error = AppError.decodingError
                    self.fetchOfflineCache(offset, limit)
                }
            } else {
                self.error = AppError.networkError
                self.fetchOfflineCache(offset, limit)
            }
        }
    }
    
    func fetchOfflineCache(_ offset:Int,_ limit:Int) {
        self.cdProtocol?.fetchDeliveryListFromCD(offset, limit) { [weak self] (list, error) -> Void in
            guard let self = self else {
                return
            }
            guard let list = list else {
                self.presenter?.deliveryFetchFailed(AppError.coreDataError)
                return
            }
            if list.isEmpty {
                self.presenter?.deliveryFetchFailed(self.error)
            } else {
                self.presenter?.deliveryFetchSuccess(deliveryList: list)
            }
        }
    }
    
}
