//
//  NewsFeederTests.swift
//  NewsTests
//
//  Created by Gabriel Brodersen on 09/12/2021.
//

import XCTest
import Combine
@testable import News

class NewsFeederTests: XCTestCase {

	// Expectations
	let timeout: TimeInterval = 3
	var subscriptions: Set<AnyCancellable> = []
	
	// Test if NewsFeeder can fetch articles using the 'Top Headlines' endpoint
	func test_that_news_feeder_can_fetch_top_headlines_news() {
		
		let newsFeeder = NewsFeeder(apiKey: Authentication.apiKey)
		let expectation = expectation(description: "NewsFeeder responds in a reasonable time (within \(timeout) seconds) ")
		
		newsFeeder
			.$articles
			.dropFirst()
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { articles in
				defer { expectation.fulfill() }
				
				// Fail if there is a server error:
				if let error = newsFeeder.errorMessages { XCTFail(error) }
				XCTAssertFalse(articles.isEmpty)
				
			}.store(in: &subscriptions)
		
		newsFeeder.searchQuery()
		
		wait(for: [expectation], timeout: timeout)
	}
	
	// Test if NewsFeeder can fetch articles using a query to the 'Everything' endpoint
	func test_that_news_feeder_can_fetch_in_everything_using_query_news() {
		
		let newsFeeder = NewsFeeder(apiKey: Authentication.apiKey)
		let expectation = expectation(description: "NewsFeeder responds in a reasonable time (within \(timeout) seconds) ")
		
		newsFeeder
			.$articles
			.dropFirst()
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { articles in
				defer { expectation.fulfill() }
				
				// Fail if there is a server error:
				if let error = newsFeeder.errorMessages { XCTFail(error) }
				XCTAssertFalse(articles.isEmpty)
				
			}.store(in: &subscriptions)
		
		newsFeeder.query = "News"
		
		wait(for: [expectation], timeout: timeout)
	}
	
	// Test NewsFeeder's computations of articles and pages based on server response and currently loaded article counts
	func test_page_estimation() {
		
		let pageSize = 5 // Default
		let newsFeeder = NewsFeeder(apiKey: "", pagesize: pageSize)
		XCTAssertEqual(newsFeeder.pageSize, pageSize)
		
		// Method to fake the number of articles loaded, and total remaining, in NewsFeeder
		func loadDemoArticles(_ articles: Int, of total: Int) {
			let demoArticles = Array(repeating: NewsResponse.demoArticles[0], count: articles)
			newsFeeder.setFakeTotalArticles(total)
			newsFeeder.loadDemoArticles(demoArticles)
		}
		
		// 0 of 0 articles
		loadDemoArticles(0, of: 0)
		XCTAssertEqual(newsFeeder.currentPage, 0)
		XCTAssertEqual(newsFeeder.totalPages, 0)
		XCTAssertEqual(newsFeeder.totalArticles, 0)
		XCTAssertTrue(newsFeeder.maxPageReached)
		
		// 1 of 1 articles
		loadDemoArticles(1, of: 1)
		XCTAssertEqual(newsFeeder.currentPage, 1)
		XCTAssertEqual(newsFeeder.totalPages, 1)
		XCTAssertEqual(newsFeeder.totalArticles, 1)
		XCTAssertTrue(newsFeeder.maxPageReached)
		
		// 1 of 3 articles
		loadDemoArticles(1, of: 3)
		XCTAssertEqual(newsFeeder.currentPage, 1)
		XCTAssertEqual(newsFeeder.totalPages, 1)
		XCTAssertEqual(newsFeeder.totalArticles, 3)
		XCTAssertTrue(newsFeeder.maxPageReached)
		
		// 1 of 5 articles
		loadDemoArticles(1, of: 5)
		XCTAssertEqual(newsFeeder.currentPage, 1)
		XCTAssertEqual(newsFeeder.totalPages, 1)
		XCTAssertEqual(newsFeeder.totalArticles, 5)
		XCTAssertTrue(newsFeeder.maxPageReached)
		
		// 1 of 6 articles
		loadDemoArticles(1, of: 6)
		XCTAssertEqual(newsFeeder.currentPage, 1)
		XCTAssertEqual(newsFeeder.totalPages, 2)
		XCTAssertEqual(newsFeeder.totalArticles, 6)
		XCTAssertFalse(newsFeeder.maxPageReached)
		
		// 3 of 11 articles
		loadDemoArticles(7, of: 11)
		XCTAssertEqual(newsFeeder.currentPage, 2)
		XCTAssertEqual(newsFeeder.totalPages, 3)
		XCTAssertEqual(newsFeeder.totalArticles, 11)
		XCTAssertFalse(newsFeeder.maxPageReached)
		
		// 12345 of 123456789 articles
		loadDemoArticles(12345, of: 123456789)
		XCTAssertEqual(newsFeeder.currentPage, 2469)
		XCTAssertEqual(newsFeeder.totalPages, 24691358)
		XCTAssertEqual(newsFeeder.totalArticles, 123456789)
		XCTAssertFalse(newsFeeder.maxPageReached)
	
	}
}
