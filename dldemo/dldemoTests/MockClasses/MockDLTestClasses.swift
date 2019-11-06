//
//  MockTestClasses.swift
//  dldemoTests
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import Foundation
import UIKit
import CoreData
@testable import dldemo

class MockDLVC: UIViewController, PresenterToViewProtocol {
    
    var inputCallbackResults = [String:String]()
    var presenter: ViewToPresenterProtocol!
    
    init(with presenter: ViewToPresenterProtocol ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showNewDeliveries(deliveryList: [DeliveryInfo]) {
        inputCallbackResults[TestConstants.DELIVERY_LIST_KEY] = TestConstants.REFRESH_DELIVERY_LIST_VALUE
    }
    
    func showErrorBanner(_ error: String) {
        inputCallbackResults[TestConstants.ERROR_KEY] = error
    }
    
    func showDeliveryList(deliveryList: [DeliveryInfo]) {
        inputCallbackResults[TestConstants.DELIVERY_LIST_KEY] = TestConstants.RECIEVED_DELIVERY_LIST_VALUE
    }
    
    func startPullToRefresh() {
        inputCallbackResults[TestConstants.START_PULL_REFRESH_KEY] = TestConstants.START_PULL_REFRESH_VALUE
    }
    
    func stopPullToRefresh() {
        inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY] = TestConstants.STOP_PULL_REFRESH_VALUE
    }
    
    func startSpinner() {
        inputCallbackResults[TestConstants.START_SPINNER_KEY] = TestConstants.START_SPINNER_VALUE
    }
    
    func stopSpinner() {
        inputCallbackResults[TestConstants.STOP_SPINNER_KEY] = TestConstants.STOP_SPINNER_VALUE
    }
    
    func showOfflineView() {
        inputCallbackResults[TestConstants.SHOW_OFFLINE_VIEW_KEY] = TestConstants.SHOW_OFFLINE_VIEW_VALUE
    }
    
    func removeOfflineView() {
        inputCallbackResults[TestConstants.REMOVE_OFFLINE_VIEW_KEY] = TestConstants.REMOVE_OFFLINE_VIEW_VALUE
    }
}

class MockDLPresenter: ViewToPresenterProtocol, InteractorToPresenterProtocol {
    
    weak var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var inputCallbackResults = [String:String]()
    var dataNA: Bool = false
    var list:[DeliveryInfo] = []
    var refreshData:Bool = false
    
    func fetchDeliveryList(_ offset: Int, _ limit: Int, _ refreshData: Bool) {
        if !dataNA && !refreshData {
            if let view = view {
                view.showDeliveryList(deliveryList: [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE),TestUtility.mockInfo(TestConstants.FAKE_ID_TWO)])
            }
        } else if !dataNA && refreshData {
            if let view = view {
                view.showNewDeliveries(deliveryList: [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE),TestUtility.mockInfo(TestConstants.FAKE_ID_TWO)])
            }
        } else {
            if let view = view {
                view.showErrorBanner(AppError.emptyDataError.localizedDescription)
            }
        }
    }
    
    func showDetailVC(for info: DeliveryInfo) {
        
    }
    
    func deliveryFetchSuccess(deliveryList: [DeliveryInfo]) {
        inputCallbackResults[TestConstants.DELIVERY_LIST_KEY] = TestConstants.FETCH_DELIVERY_LIST_VALUE
    }
    
    func deliveryFetchFailed(_ error: AppError) {
        inputCallbackResults[TestConstants.ERROR_KEY] = error.localizedDescription
    }
    
}

class MockDLInteractor: PresenterToInteractorProtocol {
    
    var presenter: InteractorToPresenterProtocol!
    init(with presenter: InteractorToPresenterProtocol) {
        self.presenter = presenter
    }
    var list:[DeliveryInfo]?
    var simulateNetworkError: Bool = false
    
    func fetchDataOnline(_ offset: Int, _ limit: Int) {
        if !simulateNetworkError {
            guard let list = list else {
                self.presenter?.deliveryFetchFailed(AppError.decodingError)
                return
            }
            if list.isEmpty {
                self.presenter?.deliveryFetchFailed(AppError.emptyDataError)
            } else {
                self.presenter?.deliveryFetchSuccess(deliveryList: list)
            }
        } else {
            self.presenter?.deliveryFetchFailed(AppError.networkError)
        }
    }
    
    func fetchOfflineCache(_ offset: Int, _ limit: Int) {
        guard let list = list else {
            self.presenter?.deliveryFetchFailed(AppError.coreDataError)
            return
        }
        if list.isEmpty {
            self.presenter?.deliveryFetchFailed(AppError.offlineError)
        } else {
            self.presenter?.deliveryFetchSuccess(deliveryList: list)
        }
    }
}

class MockDLRouter: PresenterToRouterProtocol {
    var inputCallbackResults = [String:String]()
    func pushToDetailScreen(for info: DeliveryInfo) {
        inputCallbackResults[TestConstants.SHOW_DETAIL_VC_KEY] = TestConstants.SHOW_DETAIL_VC_VALUE
    }
}



class MockCDProtocol: InteractorToCDProtocol {
    
    var list:[DeliveryInfo]?
    var inputCallbackResults = [String:String]()
    
    func fetchDeliveryListFromCD(_ offset: Int,_ limit: Int,completion: ([DeliveryInfo]?, Error?) -> (Void)) {
        completion(list,nil)
    }
    
    func saveUpdateDeliveryListfromCD (_ list: [DeliveryInfo]) {
        inputCallbackResults[TestConstants.SAVE_UPDATE_DL_KEY] = TestConstants.SAVE_UPDATE_DL_VALUE
    }
    
}
