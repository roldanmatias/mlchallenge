//
//  SearchFilter.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

struct SearchFilter: Codable {
    var text: String
    
    var query: String {
        "q=\(text)"
    }
}
