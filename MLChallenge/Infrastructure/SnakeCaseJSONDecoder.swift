//
//  SnakeCaseJSONDecoder.swift
//  MLChallenge
//
//  Created by Matias Roldan on 08/08/2023.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
