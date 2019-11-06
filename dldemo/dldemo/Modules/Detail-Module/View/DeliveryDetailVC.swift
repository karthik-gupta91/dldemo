//
//  DeliveryDetailViewController.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import UIKit
import GoogleMaps

private let ZOOM_LEVEL:Float = 16.0
private let LEADING_CONSTRAINT:CGFloat = 15.0
private let TRAILING_CONSTRAINT:CGFloat = 20.0
private let TOP_ANCHOR:CGFloat = 15.0

class DeliveryDetailVC: UIViewController {
    
    var deliveryInfo: DeliveryInfo!
    var mapView: GMSMapView?
    var locationView = UIView()
    var userImageView = CustomImageView()
    var descLabel = UILabel()
    
    init(from info:DeliveryInfo) {
        deliveryInfo = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.DELIVERY_LOCATION_TITLE
        configureView()
    }
    
    private func configureView() {
        configureMapView()
        configureLocationView()
        configureUserImageView()
        configureDescLabel()
    }
    
    private func configureMapView() {
        if let lat = deliveryInfo?.location.lat, let lng = deliveryInfo?.location.lng {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: ZOOM_LEVEL)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
            marker.map = mapView
            view.addSubview(mapView!)
            setMapViewConstraints()
        }
    }
    
    private func setMapViewConstraints() {
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        mapView?.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        mapView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        mapView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        mapView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }
    
    private func configureLocationView() {
        locationView.backgroundColor = UIColor.white
        locationView.addSubview(userImageView)
        locationView.addSubview(descLabel)
        self.view.addSubview(locationView)
        setLocationViewConstraints()
    }
    
    private func setLocationViewConstraints()  {
        locationView.translatesAutoresizingMaskIntoConstraints = false
        locationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        locationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        locationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
    }
    
    private func configureUserImageView() {
        userImageView.layer.cornerRadius = Constants.CORNER_RADIUS
        userImageView.clipsToBounds = true
        userImageView.image = UIImage(named: Constants.PLACEHOLDER_IMAGE)
        userImageView.downloaded(from: deliveryInfo.imageUrl)
        setUserImageConstraints()
    }
    
    private func setUserImageConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.centerYAnchor.constraint(equalTo: locationView.centerYAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: Constants.IMAGE_SIZE.height).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: Constants.IMAGE_SIZE.width).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: locationView.leadingAnchor, constant: LEADING_CONSTRAINT).isActive = true
    }
    
    private func configureDescLabel() {
        descLabel.numberOfLines = Constants.NUMBER_OF_LINES
        descLabel.text = deliveryInfo.description + Constants.DESCRIPTION_SEPARATOR + deliveryInfo.location.address
        setDescLabelConstraints()
    }
    
    private func setDescLabelConstraints() {
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.IMAGE_SIZE.height).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: LEADING_CONSTRAINT).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: -TRAILING_CONSTRAINT).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: locationView.bottomAnchor, constant: -TOP_ANCHOR).isActive = true
        descLabel.topAnchor.constraint(equalTo: locationView.topAnchor, constant: TOP_ANCHOR).isActive = true
        descLabel.sizeToFit()
    }
    
}
