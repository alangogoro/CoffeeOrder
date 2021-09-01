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

enum CoffeeType: String, Codable {
    case cappuccino, latte, espressino, cortado
}

enum CoffeeSize: String, Codable {
    case small, medium, large
}
