//
//  OrdersTableViewController.swift
//  MVVMCoffee
//
//  Created by usr on 2021/8/31.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
        guard let ordersUrl = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("API URL was incorrect")
        }
        
        let resource = Resource<Order>(url: ordersUrl)
        Webservice().load(resource: resource) { result in
            switch result {
            case .success(let orders):
                print(orders)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    
}
