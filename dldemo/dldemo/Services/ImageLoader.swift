//
//  ImageLoader.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class CustomImageView: UIImageView {
    
    let activityIndicator = UIActivityIndicatorView()
    let imageCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        if let image = self.imageCache.image(withIdentifier: link) {
            self.image = image
            self.activityIndicator.stopAnimating()
            return
        }
        
        Alamofire.request(url).responseImage { response in
            if response.error == nil {
                let image = UIImage(data: response.data!, scale: 1.0)!
                self.image = image
                self.imageCache.add(image, withIdentifier: link)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
}

