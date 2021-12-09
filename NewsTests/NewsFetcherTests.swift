//
//  NewsFetcherTests.swift
//  NewsTests
//
//  Created by Gabriel Brodersen on 09/12/2021.
//

import XCTest
import Combine
@testable import News

class NewsFetcherTests: XCTestCase {
	
	// Expectations
	let timeout: TimeInterval = 3
	var subscriptions: Set<AnyCancellable> = []
	
	// Test NewsFetcher using no query (to fetch from the 'Top Headlines' endpoint)
	func test_that_news_fetcher_can_request_and_receive_articles_without_parameters() {
		
		let newsFetcher = NewsFetcher(apiKey: Authentication.apiKey)
		
		let expectation = expectation(description: "NewsFetcher responds in a reasonable time (within \(timeout) seconds) ")
		
		newsFetcher
			.$lastResponse
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { response in
				
				XCTAssertNotNil(response)
				XCTAssert(response?.status == .ok)
				XCTAssertNotNil(response?.articles)
				XCTAssertGreaterThan(response?.articles?.count ?? 0, 0)
				
				expectation.fulfill()
			}.store(in: &subscriptions)
		
		newsFetcher.fetchNews(query: nil, pagesize: nil, page: nil)
		
		wait(for: [expectation], timeout: timeout)
	}
	
	// Test NewsFetcher using a query and page parameters (to fetch from the 'Everything' endpoint)
	func test_that_news_fetcher_can_request_and_receive_articles_with_query_parameters() {
		
		let newsFetcher = NewsFetcher(apiKey: Authentication.apiKey)
		
		let expectation = expectation(description: "NewsFetcher responds in a reasonable time (within \(timeout) seconds) ")

		
		newsFetcher
			.$lastResponse
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { response in
				defer { expectation.fulfill() }
				
				XCTAssertNotNil(response)
				XCTAssert(response?.status == .ok)
				XCTAssertNotNil(response?.articles)
				XCTAssertGreaterThan(response?.articles?.count ?? 0, 0)
				
			}.store(in: &subscriptions)
		
		newsFetcher.fetchNews(query: "News", pagesize: 10, page: 1)
		
		wait(for: [expectation], timeout: timeout)
	}
	
	// Test NewsFetcher using a bad query that should result in an error response
	func test_that_news_fetcher_can_request_and_receive_no_articles_with_bad_query() {
		
		let newsFetcher = NewsFetcher(apiKey: Authentication.apiKey)
		
		let expectation = expectation(description: "NewsFetcher responds in a reasonable time (within \(timeout) seconds) ")
		
		newsFetcher
			.$lastResponse
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { response in
				defer { expectation.fulfill() }
				
				XCTAssertNotNil(response)
				XCTAssert(response?.status == .error)
				XCTAssertNil(response?.articles)
				
			}.store(in: &subscriptions)
		
		newsFetcher.fetchNews(query: #",.-!#"€%&/()=?QWERTYUIOPÅASDFGHJKLÆ*ZXCVBNM;:"#)
		
		wait(for: [expectation], timeout: timeout)
	}
}

