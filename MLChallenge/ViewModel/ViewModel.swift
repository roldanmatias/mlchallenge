//
//  ViewModel.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

final class ViewModel: ViewModelProtocol {
    
    private var currencies: [Currency]?
    private var logger: LoggerProtocol
    private var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol, logger: LoggerProtocol) {
        self.repository = repository
        self.logger = logger
    }
    
    func getCurrency(id: String) -> Currency? {
        currencies?.first{ $0.id == id }
    }
    
    func seearch(
        filter: SearchFilter, 
        onSuccess: @escaping SearchResultClosure, 
        onError: @escaping ErrorClosure
    ) {
        logger.event("Search: \(filter.query)")
        repository.search(filter: filter) { [weak self] searchResult in
            self?.logger.event("Search: \(filter.query) count: \(searchResult.results?.count ?? 0)")
            
            if self?.currencies == nil && searchResult.results?.count ?? 0 > 0 {
                self?.loadCurrencies(
                    onSuccess: { 
                        onSuccess(searchResult)
                    }, 
                    onError: onError
                )
            } else {
                onSuccess(searchResult)    
            }
            
        } onError: { [weak self] error in
            self?.logger.error(error)
            onError(error)
        }
    }
}

private extension ViewModel {
    
    func loadCurrencies( 
        onSuccess: @escaping VoidClosure, 
        onError: @escaping ErrorClosure
    ) {
        logger.event("Get Currencies")
        repository.getCurrencies { [weak self] currencies in
            self?.currencies = currencies
            onSuccess()
        } onError: { [weak self] error in
            self?.logger.error(error)
            onError(error)
        }
    }
}
