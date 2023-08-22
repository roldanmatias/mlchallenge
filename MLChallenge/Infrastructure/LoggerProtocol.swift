//
//  LogProtocol.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import Foundation

protocol LoggerProtocol {
    func error(_ error: Error)
    func event(_ event: String)
}
