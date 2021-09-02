//
//  OrdersTableViewController.swift
//  MVVMCoffee
//
//  Created by usr on 2021/8/31.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderViewModels = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
        guard let ordersUrl = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("API URL was incorrect")
        }
        
        let resource = Resource<[Order]>(url: ordersUrl)
        Webservice().load(resource: resource) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderViewModels.orderViewModels = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModels.orderViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = orderViewModels.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell",
                                                 for: indexPath)
        
        cell.textLabel?.text = viewModel.type
        cell.detailTextLabel?.text = viewModel.size
        return cell
    }
}
