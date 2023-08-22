//
//  Repository.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

final class Repository: RepositoryProtocol {
    
    private var baseUrl: String
    private var session: URLSessionProtocol
    
    private enum Constant {
        static let currencyUrl = "/currencies"
        static let searchUrl = "/sites/MLA/search?"
    }
    
    init(baseUrl: String, session: URLSessionProtocol) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func getCurrencies(
        onSuccess: @escaping CurrenciesClosure, 
        onError: @escaping ErrorClosure
    ) {
        guard let url = URL(string: baseUrl + Constant.currencyUrl) else {
            fatalError("Bad currency url created")
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { 
                onError(NSError()) 
                return
            }
            
            do {
                let currencies = try SnakeCaseJSONDecoder().decode([Currency].self, from: data)
                onSuccess(currencies)
            } catch let error {
                onError(error)
            }
        }.resume()
    }
    
    func search(
        filter: SearchFilter, 
        onSuccess: @escaping SearchResultClosure, 
        onError: @escaping ErrorClosure
    ) {
        guard let url = URL(string: baseUrl + Constant.searchUrl + filter.query) else {
            fatalError("Bad search url created: \(filter.query)")
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { 
                onError(NSError()) 
                return
            }
            
            do {
                let searchResult = try SnakeCaseJSONDecoder().decode(SearchResult.self, from: data)
                onSuccess(searchResult)
            } catch let error {
                onError(error)
            }
        }.resume()
    }
}
