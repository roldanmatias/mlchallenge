//
//  RepositoryProtocol.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

protocol RepositoryProtocol {
    
    func getCurrencies(
        onSuccess: @escaping CurrenciesClosure, 
        onError: @escaping ErrorClosure
    )
    
    func search(
        filter: SearchFilter, 
        onSuccess: @escaping SearchResultClosure, 
        onError: @escaping ErrorClosure
    )
}
