//
//  DeliveryListVC.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lalamove. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol PresenterToViewProtocol: class {
    func showDeliveryList(deliveryList:[DeliveryInfo])
    func showNewDeliveries(deliveryList:[DeliveryInfo])
    func showErrorBanner(_ error: String)
    func startPullToRefresh()
    func stopPullToRefresh()
    func startSpinner()
    func stopSpinner()
    func showOfflineView()
    func removeOfflineView()
}

class DeliveryListVC: UIViewController {

    var presenter: ViewToPresenterProtocol!
    var tableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .gray)
    var deliveryList: [DeliveryInfo] = []
    let message = UILabel()
    let refreshControl = UIRefreshControl()
    
    init(with presenter: ViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        configureTableView()
        configureRefreshControl()
        presenter?.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
    }
    
    private func addOfflineMessage() {
        message.text = Constants.OFFLINE_MESSAGE
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = Constants.NUMBER_OF_LINES
        message.textAlignment = .center
        self.view.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func removeOfflineMessage() {
        message.removeFromSuperview()
    }
    
    private func setUpNavigationBar() {
        self.title = Constants.DELIVERY_LIST_TITLE
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = Constants.ROW_HEIGHT
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DeliveryInfoCell.self, forCellReuseIdentifier: Cells.deliveryCell)
        tableView.pin(to: view)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefreshData), for: .valueChanged)
    }
    
    @objc private func pullToRefreshData() {
        presenter?.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, true)
    }
    
}


extension DeliveryListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.deliveryCell) as! DeliveryInfoCell
        cell.set(deliveryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.showDetailVC(for: deliveryList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == deliveryList.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if tableView.visibleCells.contains(cell) {
                    self.presenter?.fetchDeliveryList(self.deliveryList.count, Constants.FETCH_LIMIT, false)
                }
            }
        }
    }
    
}

extension DeliveryListVC: PresenterToViewProtocol {
    
    func showNewDeliveries(deliveryList: [DeliveryInfo]) {
        self.deliveryList = deliveryList
        tableView.reloadData()
    }
    
    func showDeliveryList(deliveryList: [DeliveryInfo]) {
        self.deliveryList += deliveryList
        tableView.reloadData()
    }
    
    func showErrorBanner(_ error: String) {
        let banner = NotificationBanner(title: Constants.ALERT_TITLE, subtitle: error, style: .info)
        banner.duration = Constants.BANNER_DURATION
        banner.show()
    }
    
    func stopPullToRefresh() {
        refreshControl.endRefreshing()
    }
    
    func startPullToRefresh() {
        refreshControl.beginRefreshing()
    }
    
    func startSpinner() {
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    func showOfflineView() {
        if deliveryList.isEmpty {
            self.addOfflineMessage()
        }
    }
    
    func removeOfflineView() {
        self.removeOfflineMessage()
    }
}
