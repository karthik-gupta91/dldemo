//
//  DeliveryListRouter.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterToRouterProtocol: class {
    func pushToDetailScreen(for info: DeliveryInfo)
}

class DeliveryListRouter:PresenterToRouterProtocol {
    
    var sourceVC: UIViewController!
    
    func pushToDetailScreen(for info: DeliveryInfo) {
        let detailVC = DeliveryDetailVC(from: info)
        sourceVC.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
