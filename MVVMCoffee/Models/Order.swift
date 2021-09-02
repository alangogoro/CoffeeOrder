//
//  Order.swift
//  MVVMCoffee
//
//  Created by usr on 2021/9/1.
//

import Foundation

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

/* ⭐️ CaseIterable 協定
 * 使 enum 遵從 CaseIterable 協定後，可以調用 .allCases
 * 來取得包含所有 case 的 enum 陣列。也就可以再利用陣列的 .count 等屬性 */
enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino, latte, espressino, cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small, medium, large
}

extension Order {
    static var allOrder: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("API URL is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
    init?(_ viewModel: AddCoffeeViewModel) {
        guard let name = viewModel.name,
              let email = viewModel.email,
              let selectedType = CoffeeType(rawValue: viewModel.selectedType!.lowercased()),
              let selectedSize = CoffeeSize(rawValue: viewModel.selectedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
    
    static func create(viewModel: AddCoffeeViewModel) -> Resource<Order?> {
        let order = Order(viewModel)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            fatalError("API URL is incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding Order")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.httpBody = data
        
        return resource
    }
}
