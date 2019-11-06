//
//  DeliveryInfoCell.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import UIKit
import GoogleMaps

private let LEADING_CONSTRAINT:CGFloat = 15
private let TRAILING_CONSTRAINT:CGFloat = 30
private let TOP_ANCHOR:CGFloat = 15

class DeliveryInfoCell: UITableViewCell {
    
    var userImageView = CustomImageView()
    var descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ deliveryInfo:DeliveryInfo) {
        self.userImageView.downloaded(from: deliveryInfo.imageUrl)
        self.descLabel.text = deliveryInfo.description + Constants.DESCRIPTION_SEPARATOR + deliveryInfo.location.address
    }
    
    private func configureCell() {
        self.userImageView.image = UIImage(named: Constants.PLACEHOLDER_IMAGE)
        self.accessoryType = .disclosureIndicator
        
        self.addSubview(userImageView)
        self.addSubview(descLabel)
        
        configureUserImageView()
        configureDescLabel()
        
        setUserImageConstraints()
        setDescLabelConstraints()
    }
    
    private func configureUserImageView() {
        userImageView.layer.cornerRadius = Constants.CORNER_RADIUS
        userImageView.clipsToBounds = true
    }
    
    private func configureDescLabel() {
        descLabel.numberOfLines = Constants.NUMBER_OF_LINES
    }
    
    private func setUserImageConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: Constants.IMAGE_SIZE.height).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: Constants.IMAGE_SIZE.width).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LEADING_CONSTRAINT).isActive = true
    }
    
    private func setDescLabelConstraints() {
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.IMAGE_SIZE.height).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: LEADING_CONSTRAINT).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -TRAILING_CONSTRAINT).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -TOP_ANCHOR).isActive = true
        descLabel.topAnchor.constraint(equalTo: topAnchor, constant: TOP_ANCHOR).isActive = true
    }
}
