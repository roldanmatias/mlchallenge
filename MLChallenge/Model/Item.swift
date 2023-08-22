//
//  Item.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

struct Item: Codable {
    var availableQuantity: Int
    var currencyId: String
    var price: Double
    var soldQuantity: Int
    var thumbnail: String
    var title: String
    var seller: Seller
}
