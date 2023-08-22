//
//  MLChallengeTests.swift
//  MLChallengeTests
//
//  Created by Matias Roldan on 07/08/2023.
//

import XCTest
@testable import MLChallenge

final class MLChallengeTests: XCTestCase {

    var repository: Repository!
    var mockSession: MockURLSession!

    override func tearDown() {
        repository = nil
        mockSession = nil
        super.tearDown()
    }

    func testRepositorySeearch_successResult() {
        mockSession = createMockSession(fromJsonFile: "searchResponse", andStatusCode: 200, andError: nil)
        repository = Repository(baseUrl: "baseUrl", session: mockSession)

        repository.search(filter: SearchFilter(text: "")) { searchResult in
            XCTAssertNotNil(searchResult)
            XCTAssertTrue(searchResult.results?.count ?? 0 > 0)
        } onError: { _ in
            XCTFail("Search resturns 0 results")
        }
    }
    
    func testRepositoryGetCurrencies_successResult() {
        mockSession = createMockSession(fromJsonFile: "currenciesResponse", andStatusCode: 200, andError: nil)
        repository = Repository(baseUrl: "baseUrl", session: mockSession)

        repository.getCurrencies { currencies in
            XCTAssertNotNil(currencies)
            XCTAssertTrue(currencies.count > 0)
        } onError: { _ in
            XCTFail("GetCurrencies resturns 0 results")
        }
    }

    private func loadJsonData(file: String) -> Data? {

        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }

    private func createMockSession(
        fromJsonFile file: String,   
        andStatusCode code: Int,
        andError error: Error?) -> MockURLSession? 
    {
        let data = loadJsonData(file: file)
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)
        return MockURLSession(completionHandler: (data, response, error))
    }
}
