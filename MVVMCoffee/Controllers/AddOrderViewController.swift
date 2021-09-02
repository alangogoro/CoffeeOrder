//
//  AddOrderViewController.swift
//  MVVMCoffee
//
//  Created by usr on 2021/8/31.
//

import Foundation
import UIKit

protocol AddOrderViewControllerDelegate {
    func AddOrderViewControllerDidSaveOrder(order: Order, controller: UIViewController)
    func AddOrderViewControllerDidClose(_ controller: UIViewController)
}

class AddOrderViewController: UIViewController,
                              UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    private var sizeSegmentedControl: UISegmentedControl!
    
    private var viewModel = AddCoffeeViewModel()
    var delegate: AddOrderViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Selector
    @IBAction func saveOrder() {
        let name = nameTextField.text
        let email = emailTextField.text
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            debugPrint("⚡️ Need to Select a type of coffee")
            return
        }
        let selectedSize = sizeSegmentedControl
            .titleForSegment(at: sizeSegmentedControl.selectedSegmentIndex)
        
        viewModel.name = name
        viewModel.email = email
        viewModel.selectedType = viewModel.types[indexPath.row]
        viewModel.selectedSize = selectedSize
        
        Webservice().load(resource: Order.create(viewModel: viewModel)) { result in
            switch result {
            case .success(let order):
                //debugPrint(order)
                if let order = order,
                   let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.AddOrderViewControllerDidSaveOrder(order: order,
                                                                    controller: self)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    @IBAction func close() {
        if let delegate = self.delegate {
            delegate.AddOrderViewControllerDidClose(self)
        }
    }
    
    // MARK: - Helper
    private func setupUI() {
        // 傳入全部 Size 作為 SegmentedControl 的區段
        sizeSegmentedControl = UISegmentedControl(items: viewModel.sizes)
        
        sizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sizeSegmentedControl)
        sizeSegmentedControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 52)
            .isActive = true
        sizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
    }
    
    // MARK: - TableView delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeCell",
                                                 for: indexPath)
        cell.textLabel?.text = viewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ⭐️ 增加打勾圖示
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // ⭐️ 未被選取的，取消打勾圖示
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    
}
