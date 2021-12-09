//
//  NewsServerTests.swift
//  NewsServerTests
//
//  Created by Gabriel Brodersen on 09/12/2021.
//

import XCTest
@testable import News

class NewsServerTests: XCTestCase {

	// Expectations
	let timeout: TimeInterval = 2
	
	// Test URLs
	let newsAPIURL = URL(string: "https://newsapi.org/")!

	// Test that the NewsAPI server is alive
	func test_server_is_responding() {
	
		let expectation: XCTestExpectation = expectation(description: "Server responds in a reasonable time (within \(timeout) seconds) ")
		
		URLSession.shared.dataTask(with: newsAPIURL) { data, response, error in
			defer { expectation.fulfill() }
						
			XCTAssertNotNil(data)
			XCTAssertNotNil(response)
			let httpResponse = response as? HTTPURLResponse
			XCTAssertNotNil(httpResponse)
			XCTAssertEqual(httpResponse?.statusCode, 200)
			XCTAssertNil(error)
			
		}.resume()
		
		waitForExpectations(timeout: timeout)
	}

}
