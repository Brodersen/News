//
//  Everything.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

// MARK: - 'Everything'-Endpoint

/// See [Everything Endpoint](https://newsapi.org/docs/endpoints/everything)
struct Everything: Endpoint {
	
	let path = "/v2/everything"
	private(set) var components: URLComponents
	
	// API Constrains
	let maxCharactersInQuery = 500
	let maxPageSize = 100
	let startPage = 1
	var dateFormatter: Formatter {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime,
								   .withDashSeparatorInDate,
								   .withColonSeparatorInTime]
		return formatter
	}
	
	/// Initializing base URL components with 'Everything'-endpoint path
	/// - Parameter root: The **NewsAPI** root `URLComponents`
	init(root: URLComponents) {
		self.components = root
		self.components.path = path
	}
	
	// MARK: - Request URL
	/// Get a **NewsAPI** URL based on parameters to search through 'Everything'.
	/// - Parameters:
	///   - q: Keywords or phrases to search for in the article title and body.
	///   - qInTitle: Keywords or phrases to search for in the article title only.
	///   - sources: A comma-separated string of identifiers (maximum 20) for the news sources or blogs you want headlines from.
	///   - domains: A comma-separated string of domains (eg bbc.co.uk, techcrunch.com, engadget.com) to restrict the search to.
	///   - excludeDomains: A comma-separated string of domains (eg bbc.co.uk, techcrunch.com, engadget.com) to remove from the results.
	///   - from: A date and optional time for the oldest article allowed.
	///   - to: A date and optional time for the newest article allowed.
	///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
	///   - sortBy: The order to sort the articles in.
	///   - pageSize: The number of results to return per page.
	///   - page: Use this to page through the results.
	/// - Returns: An optional `URL`.
	func URL(q: String? = nil,
			 qInTitle: String? = nil,
			 sources: [String]? = nil,
			 domains: [String]? = nil,
			 excludeDomains: [String]? = nil,
			 from: Date? = nil,
			 to: Date? = nil,
			 language: Language? = nil,
			 sortBy: SortBy? = nil,
			 pageSize: Int? = nil,
			 page: Int? = nil) -> URL? {
		
		var components = components
		components.queryItems = []
		
		if let q = q, !q.isEmpty {
			let queryItem = URLQueryItem(name: "q", value: q)
			components.queryItems?.append(queryItem)
		}
		
		if let qInTitle = qInTitle, !qInTitle.isEmpty {
			let queryItem = URLQueryItem(name: "qInTitle", value: qInTitle)
			components.queryItems?.append(queryItem)
		}
		
		if let sources = sources, !sources.isEmpty {
			let queryItem = URLQueryItem(name: "sources", value: sources.joined(separator: ","))
			components.queryItems?.append(queryItem)
		}
		
		if let domains = domains, !domains.isEmpty {
			let queryItem = URLQueryItem(name: "domains", value: domains.joined(separator: ","))
			components.queryItems?.append(queryItem)
		}
		
		if let excludeDomains = excludeDomains, !excludeDomains.isEmpty {
			let queryItem = URLQueryItem(name: "excludeDomains", value: excludeDomains.joined(separator: ","))
			components.queryItems?.append(queryItem)
		}
		
		if let from = from {
			let date = dateFormatter.string(for: from)
			let queryItem = URLQueryItem(name: "from", value: date)
			components.queryItems?.append(queryItem)
		}
		
		if let to = to {
			let date = dateFormatter.string(for: to)
			let queryItem = URLQueryItem(name: "to", value: date)
			components.queryItems?.append(queryItem)
		}
		
		if let language = language {
			let queryItem = URLQueryItem(name: "language", value: language.rawValue)
			components.queryItems?.append(queryItem)
		}
		
		if let sortBy = sortBy {
			let queryItem = URLQueryItem(name: "sortBy", value: sortBy.rawValue)
			components.queryItems?.append(queryItem)
		}
		
		if let pageSize = pageSize {
			let clampedPageSize = pageSize.clamped(to: startPage...maxPageSize)
			let queryItem = URLQueryItem(name: "pageSize",  value: String(clampedPageSize))
			components.queryItems?.append(queryItem)
		}
		
		if let page = page {
			let clampedPageSize = max(page, 1)
			let queryItem = URLQueryItem(name: "page", value: String(clampedPageSize))
			components.queryItems?.append(queryItem)
		}

		return components.url
	}
	
	// MARK: - 'Everything'-Endpoint Parameter Utilities
	/// The 2-letter ISO-639-1 code of the language you want to get headlines for.
	enum Language: String, CaseIterable {
		case arabic = "ar"
		case german = "de"
		case english = "en"
		case spanish = "es"
		case french = "fr"
		case hebrew = "he"
		case italian = "it"
		case dutch = "nl"
		case norwegian = "no"
		case portuguese = "pt"
		case russian = "ru"
		case northernSami = "se"
		case urdu = "ud"
		case chinese = "zh"
	}
	
	/// The order to sort the articles in.
	enum SortBy: String, CaseIterable {
		case relevancy
		case popularity
		case publishedAt
	}
	
	/// Convert a `Date` object to a `String` using ISO8601.
	/// - Parameter date: A `Date`.
	/// - Returns: A `String` representing the date in ISO8601 format.
	private func dateToISO8601(_ date: Date) -> String {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime,
								   .withDashSeparatorInDate,
								   .withColonSeparatorInTime]
		return formatter.string(from: date)
	}
}
