//
//  ViewModelFactory.swift
//  MLChallenge
//
//  Created by Matias Roldan on 08/08/2023.
//

import Foundation

final class ViewModelFactory {
    
    static func createViewModel() -> ViewModelProtocol {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "baseUrl") as? String else {
            fatalError("Base url is not found in info.plist")
        }

        let repository = Repository(baseUrl: baseUrl, session: URLSession.shared)
        let viewModel = ViewModel(repository: repository, logger: Logger())
        return viewModel
    }
}
