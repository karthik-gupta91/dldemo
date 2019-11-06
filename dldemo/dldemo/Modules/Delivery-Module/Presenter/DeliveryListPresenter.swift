//
//  DeliveryListPresenter.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation

protocol ViewToPresenterProtocol: class {
    func fetchDeliveryList(_ offset:Int, _ limit:Int,_ isPullToRefresh:Bool)
    func showDetailVC(for info: DeliveryInfo)
}

protocol InteractorToPresenterProtocol: class {
    func deliveryFetchSuccess(deliveryList:[DeliveryInfo])
    func deliveryFetchFailed(_ error: AppError)
}

class DeliveryListPresenter: ViewToPresenterProtocol {
    
    weak var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var networkManager = NetworkManager()
    private var isFetchingInProgress = false
    private var isPullToRefresh = false
    
    func fetchDeliveryList(_ offset:Int,_ limit:Int,_ isPullToRefresh: Bool) {
        view?.stopPullToRefresh()
        if !isFetchingInProgress {
            isFetchingInProgress = true
            view?.removeOfflineView()
            self.isPullToRefresh = isPullToRefresh
            self.isPullToRefresh ? view?.startPullToRefresh() : view?.startSpinner()
            if networkManager.isReachable() {
                self.interactor?.fetchDataOnline(offset, limit)
            } else {
                self.interactor?.fetchOfflineCache(offset, limit)
            }
        }
    }
    
    func showDetailVC(for info: DeliveryInfo) {
        router?.pushToDetailScreen(for: info)
    }
    
}

extension DeliveryListPresenter: InteractorToPresenterProtocol {
    
    func deliveryFetchSuccess(deliveryList: [DeliveryInfo]) {
        if self.isPullToRefresh {
            view?.stopPullToRefresh()
            view?.showNewDeliveries(deliveryList: deliveryList)
        } else {
            view?.stopSpinner()
            view?.showDeliveryList(deliveryList: deliveryList)
        }
        isFetchingInProgress = false
    }
    
    func deliveryFetchFailed(_ error: AppError) {
        self.isPullToRefresh ? view?.stopPullToRefresh() : view?.stopSpinner()
        view?.showOfflineView()
        view?.showErrorBanner(error.localizedDescription)
        isFetchingInProgress = false
    }
    
}
