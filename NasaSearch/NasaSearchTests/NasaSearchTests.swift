//
//  NasaSearchTests.swift
//  NasaSearchTests
//
//  Created by Abdalla Elaameir on 4/14/23.
//

import XCTest
@testable import NasaSearch

final class NasaSearchTests: XCTestCase {


    func testAPIHelperWithValidSearchTerm() throws {

        let apiHelper = NASAAPIHelper()
        let successExpectation = expectation(description: "data")
        var resultData: Data = Data()
        var results: [NASAAPIHelper.SearchResult]

        // Testing endpoint call and allowing results to load with expectation
        apiHelper.getNASAImageSearchResults(search: "Stars", pageNumber: 1, mediaType: "image", pageLimit: nil) { success, data in
            if success, let fetchedData = data {
                // fulfill expectation upon result and set data if succeeded
                resultData = fetchedData
                successExpectation.fulfill()
            }
            else {
                XCTAssertFalse(success)
                successExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
        // Assert results array contains values; meaning data has been transformed properly
        results = apiHelper.handleData(data: resultData)
        XCTAssertTrue(!results.isEmpty)
    }
    
    func testAPIHelperWithInvalidSearchTerm() throws {

        let apiHelper = NASAAPIHelper()
        let successExpectation = expectation(description: "data")
        var resultData: Data = Data()
        var results: [NASAAPIHelper.SearchResult]

        // Testing endpoint call and allowing results to load with expectation
        apiHelper.getNASAImageSearchResults(search: "qwrgwh", pageNumber: 1, mediaType: "image", pageLimit: nil) { success, data in
            if success, let fetchedData = data {
                // fulfill expectation upon result and set data if succeeded
                resultData = fetchedData
                successExpectation.fulfill()
            }
            else {
                XCTAssertFalse(success)
                successExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
        // Assert results array contain no values; meaning call fetched no results as expected
        results = apiHelper.handleData(data: resultData)
        XCTAssertTrue(results.isEmpty)
    }


}
