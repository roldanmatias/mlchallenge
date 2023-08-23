//
//  SearchFilter.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

struct SearchFilter: Codable {
    var offset: Int
    var text: String
    
    var query: String {
        "q=\(text)&offset=\(offset)"
    }
}
