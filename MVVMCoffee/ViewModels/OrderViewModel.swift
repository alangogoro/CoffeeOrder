//
//  OrderViewModel.swift
//  MVVMCoffee
//
//  Created by usr on 2021/9/1.
//

import Foundation

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    var name: String {
        return self.order.name
    }
    var email: String {
        return self.order.email
    }
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}

struct OrderListViewModel {
    var orderViewModels: [OrderViewModel]
    
    init() {
        self.orderViewModels = [OrderViewModel]()
    }
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return orderViewModels[index]
    }
}
