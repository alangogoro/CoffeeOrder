//
//  AddOrderViewModel.swift
//  MVVMCoffee
//
//  Created by usr on 2021/9/2.
//

import Foundation

struct AddCoffeeViewModel {
    var name: String?
    var email: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
    
    var selectedType: String?
    var selectedSize: String?
}
