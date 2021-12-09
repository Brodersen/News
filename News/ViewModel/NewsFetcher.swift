//
//  NewsFetcher.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Combine
import Foundation

/// The `NewsFetcher` is responsible for fetching news and decode the responses from **NewsAPI**
/// Use the `fetchNews()` method to fetch news as a `NewsResponse` object.
/// Subscribe to the `lastResponse` publisher to receive responses.
/// If a fetch request contains no query, then news from the **Top Headlines** endpoint is received.
/// Otherwise, a query can be used to search using the **Everything** endpoint.
/// News results are defaulted to _english_ and sorted by _relevance_.
final class NewsFetcher: ObservableObject {
	
	// Response Publisher
	@Published var lastResponse: NewsResponse? = nil

	// Configuration
	private let decoder = JSONDecoder()
	private let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
	private let debounceDelay = 500 // Millisecond(s)
	private let retries = 1 // Number of times to retry the connection in case of failure
	
	// Combine
	private var subscription: AnyCancellable!
	private let urlHandler = PassthroughSubject<URL, Never>() // Search by sending an URL
	
	// MARK: - Initializer
	/// Create a NewsFetcher using a valid API key to **NewsAPI**.
	/// - Parameter apiKey: An API Key to **NewsAPI**. To get a key, visit [NewsAPI](https://newsapi.org/register)
	init(apiKey: String) {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601

		// Setup URL Handling
		subscription = urlHandler
			.debounce(for: .milliseconds(debounceDelay), scheduler: backgroundQueue)
			.map { url -> URLRequest in
			
				// Create URLRequest
				var urlRequest = URLRequest.init(url: url)
				urlRequest.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
				print("NewsFetcher: SendRequest \(Date()): \(urlRequest)")
				return urlRequest
			}
			.map { URLSession.shared.dataTaskPublisher(for: $0) }
			.switchToLatest()
			.tryMap { element -> Data in

				// Check HTTPURLResponse
				guard let httpResponse = element.response as? HTTPURLResponse else {
					print("NewsFetcher: Server response not a HTTPURLResponse")
					throw URLError(.unknown)
				}

				// Check if response is a known NewsAPI HTTP status code
				let knownStatusCode = NewsAPI.HTTPStatusCodes(httpResponse.statusCode)
				guard knownStatusCode != nil else {
					print("NewsFetcher: Unknown response with status code \(httpResponse.statusCode)")
					throw URLError(.unknown)
				}

				return element.data
			}
			.decode(type: NewsResponse?.self, decoder: decoder)
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] newsResponse in
				self?.lastResponse = newsResponse
				print("NewsFetcher Received: \(String(describing: newsResponse))")
			}
	}
}

// MARK: - Fetch News Articles
extension NewsFetcher {
	
	/// Fetch news articles from **NewsAPI**. If the query is empty, show articles from **Top Headlines**. Otherwise, search in **Everything**.
	/// - Parameters:
	///   - query: An optional search query. If this value is empty or nil, articles from the **Top Headlines** endpoint will be requested.
	///   - pagesize: Specify the number of pages the server should organize articles in. If `nil`, a default will be used by the server.
	///   - page: Specify which page of articles to fetch. If `nil`, the default page 1 will be requested.
	func fetchNews(query: String?, pagesize: Int? = nil, page: Int? = nil) {
		
		if let query = query, !query.isEmpty {
			guard let url = NewsAPI.everything.URL(q: query,
												   language: .english,
												   sortBy: .relevancy,
												   pageSize: pagesize,
												   page: page) else { return }
			print("NewsFetcher: Searching for '\(query)' at page \(page ?? 0) in 'Everything'")
			urlHandler.send(url)
		} else {
			guard let url = NewsAPI.topHeadlines.URL(language: .english,
													 country: nil,
													 category: nil,
													 q: nil,
													 pageSize: pagesize,
													 page: page) else { return }
			print("NewsFetcher: Searching page \(page ?? 0) in 'TopHeadlines'")
			urlHandler.send(url)
		}
	}
}
