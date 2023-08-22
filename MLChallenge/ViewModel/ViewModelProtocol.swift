//
//  ViewModelProtocol.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

protocol ViewModelProtocol {
    
    func getCurrency(id: String) -> Currency?
    
    func seearch(
        filter: SearchFilter, 
        onSuccess: @escaping SearchResultClosure, 
        onError: @escaping ErrorClosure
    )
}
