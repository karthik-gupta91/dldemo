//
//  UIView+Ext.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lalamove. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(to superView:UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
}
