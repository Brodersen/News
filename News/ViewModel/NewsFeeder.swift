//
//  NewsFeeder.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation
import Combine

/// The `NewsFeeder` is responsible for managing news articles using pagination with continuous scrolling.
/// News is requested whenever the search `query` is changed.
/// The `NewsFeeder` uses an attached `NewsFetcher` to request and receive content from **NewsAPI**
final class NewsFeeder: ObservableObject {
	
	// Publishes
	@Published private(set) var articles: [NewsResponse.Article] = []
	@Published var lastResponseWasEmpty: Bool = false
	@Published var errorMessages: String? = nil
	@Published var query: String = "" {
		didSet {
			lastResponseWasEmpty = false // Reset
			searchQuery() // Auto search on type
		}
	}

	// Page Estimation
	var totalArticles: Int { newsFetcher.lastResponse?.totalResults ?? 0 }
	var totalPages: Int { (totalArticles - 1 + pageSize) / pageSize }
	var currentPage: Int { (articles.count - 1 + pageSize) / pageSize }
	var maxPageReached: Bool { currentPage == totalPages }
	
	// Configuration
	let pageSize: Int // Max articles shown per page
	private let newsFetcher: NewsFetcher
	
	// Combine
	private var subscriptions: Set<AnyCancellable> = []
	
	// MARK: - Initializer
	/// Create a NewsFeeder using a valid API key to **NewsAPI**.
	/// - Parameters:
	///   - apiKey: An API Key to **NewsAPI**. To get a key, visit [NewsAPI](https://newsapi.org/register)
	///   - pagesize: Optionally specify a number of articles to receive per page (default is 5)
	init(apiKey: String, pagesize: Int = 5) {
		self.newsFetcher = NewsFetcher(apiKey: apiKey)
		self.pageSize = max(pagesize, 1) // Minimum 1 article per page
		
		// Subscribe to NewsFetcher responses
		self.newsFetcher
			.$lastResponse
			.sink { [weak self] response in
				
				// Check response for errors
				if response?.status == .error, let errorMessage = response?.message {
					self?.errorMessages = errorMessage
				} else {
					self?.errorMessages = nil
				}
				
				// Load fetched articles
				if let fetchedArticles = response?.articles, !fetchedArticles.isEmpty {
					self?.articles.append(contentsOf: fetchedArticles)
				} else {
					self?.lastResponseWasEmpty = true
				}
			}
			.store(in: &subscriptions)
	}
}

// MARK: - Request News articles using NewsFetcher
extension NewsFeeder {
	
	/// Search **NewsAPI** using the current query. This is also called automatically whenever the query changes.
	func searchQuery() {
		articles = [] // Reset results
		newsFetcher.fetchNews(query: query, pagesize: pageSize, page: 1)
	}
	
	/// Load the next page of articles from **NewsAPI** for the current query, only if it has results and if there are more pages.
	func loadNextPage() {
		guard !maxPageReached, !articles.isEmpty else { return }
		print("LoadNext: Loading page \(currentPage + 1)...")
		newsFetcher.fetchNews(query: query, pagesize: pageSize, page: currentPage + 1)
	}
}

#if DEBUG
// MARK: - Demo Only
extension NewsFeeder {
	func loadDemoArticles(_ articles: [NewsResponse.Article]) {
		self.articles = articles
	}
	
	func setFakeTotalArticles(_ number: Int) {
		newsFetcher.lastResponse = NewsResponse(status: .ok,
												code: nil,
												message: nil,
												totalResults: number,
												articles: [])
	}
}
#endif
