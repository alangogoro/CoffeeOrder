//
//  OrdersTableViewController.swift
//  MVVMCoffee
//
//  Created by usr on 2021/8/31.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddOrderViewControllerDelegate {
    
    // MARK: - Properties
    var orderListViewModel = OrderListViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
              let addOrder = nav.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue!")
        }
        addOrder.delegate = self
    }
    
    // MARK: - Helpers
    private func populateOrders() {
        Webservice().load(resource: Order.allOrder) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListViewModel.orderViewModels = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: - TableView delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListViewModel.orderViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell",
                                                 for: indexPath)
        
        cell.textLabel?.text = viewModel.type
        cell.detailTextLabel?.text = viewModel.size
        return cell
    }
    
    // MARK: - AddOrderViewController delegates
    func AddOrderViewControllerDidSaveOrder(order: Order,
                                            controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderViewModel = OrderViewModel(order: order)
        orderListViewModel.orderViewModels.append(orderViewModel)
        
        tableView.insertRows(at: [IndexPath.init(row: orderListViewModel.orderViewModels.count - 1,
                                                 section: 0)],
                             with: .automatic)
    }
    
    func AddOrderViewControllerDidClose(_ controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
