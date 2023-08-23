//
//  SearchResult.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

struct SearchResult: Codable {
    var paging: Paging
    var query: String
    var results: [Item]?
}
