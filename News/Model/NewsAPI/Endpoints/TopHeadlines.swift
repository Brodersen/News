//
//  TopHeadlines.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

// MARK: - 'Top-Headlines'-Endpoint
/// /// See [Top Headlines](https://newsapi.org/docs/endpoints/top-headlines)
struct TopHeadlines: Endpoint {
	
	let path = "/v2/top-headlines"
	private(set) var components: URLComponents
	
	// API Limits
	let maxCharactersInQuery = 500
	let maxPageSize = 100
	let startPage = 1
	
	/// Initializing base URL components with 'Top-Headlines'-endpoint path
	/// - Parameter root: The **NewsAPI** root `URLComponents`
	init(root: URLComponents) {
		self.components = root
		self.components.path = path
	}
	
	// MARK: - Country and/or Category Request URL
	/// Get a **NewsAPI** URL based on parameters to search through 'Top Headlines'.
	/// - Parameters:
	///   - language: The 2-letter ISO-639-1 code of the language you want to get headlines for.
	///   - country: The 2-letter ISO 3166-1 code of the country you want to get headlines for.
	///   - category: The category you want to get headlines for.
	///   - q: Keywords or a phrase to search for.
	///   - pageSize: The number of results to return per page (request). 20 is the default, 100 is the maximum.
	///   - page: Use this to page through the results if the total results found is greater than the page size.
	/// - Returns: An optional `URL`.
	func URL(language: Language? = nil,
			 country: Country? = nil,
			 category: Category? = nil,
			 q: String? = nil,
			 pageSize: Int? = nil,
			 page: Int? = nil) -> URL? {
		
		var components = components
		components.queryItems = []
		
		if let language = language {
			let queryItem = URLQueryItem(name: "language", value: language.rawValue)
			components.queryItems?.append(queryItem)
		}
		
		if let country = country {
			let queryItem = URLQueryItem(name: "country", value: country.rawValue)
			components.queryItems?.append(queryItem)
		}
		
		if let category = category {
			let queryItem = URLQueryItem(name: "category", value: category.rawValue)
			components.queryItems?.append(queryItem)
		}
		
		if let q = q, !q.isEmpty {
			let queryItem = URLQueryItem(name: "q", value: q)
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
	
	// MARK: - Sources Request URL
	/// Get a **NewsAPI** URL based on parameters to search through 'Top Headlines'.
	/// - Parameters:
	///   - sources: A comma-separated string of identifiers for the news sources or blogs you want headlines from.
	///   - q: Keywords or a phrase to search for.
	///   - pageSize: The number of results to return per page (request). 20 is the default, 100 is the maximum.
	///   - page: Use this to page through the results if the total results found is greater than the page size.
	/// - Returns: An optional `URL`.
	func URL(sources: [String]? = nil,
			 q: String? = nil,
			 pageSize: Int? = nil,
			 page: Int? = nil) -> URL? {
		
		var components = components
		components.queryItems = []
		
		if let sources = sources, !sources.isEmpty {
			let queryItem = URLQueryItem(name: "sources", value: sources.joined(separator: ","))
			components.queryItems?.append(queryItem)
		}
		
		if let q = q, !q.isEmpty {
			let queryItem = URLQueryItem(name: "q", value: q)
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
	
	/// The 2-letter ISO 3166-1 code of the country you want to get headlines for.
	enum Country: String, CaseIterable {
		case unitedArabEmirates = "ae"
		case argentina = "ar"
		case austria = "at"
		case australia = "au"
		case belgium = "be"
		case bulgaria = "bg"
		case brazil = "br"
		case canada = "ca"
		case switzerland = "ch"
		case china = "cn"
		case colombia = "co"
		case cuba = "cu"
		case czechia = "cz"
		case germany = "de"
		case egypt = "eg"
		case france = "fr"
		case unitedKingdom = "gb"
		case greece = "gr"
		case hongKong = "hk"
		case hungary = "hu"
		case indonesia = "id"
		case ireland = "ie"
		case israel = "il"
		case india = "`in`"
		case italy = "it"
		case japan = "jp"
		case korea = "kr"
		case lithuania = "lt"
		case latvia = "lv"
		case morocco = "ma"
		case mexico = "mx"
		case malaysia = "my"
		case nigeria = "ng"
		case netherlands = "nl"
		case norway = "no"
		case newZealand = "nz"
		case philippines = "ph"
		case poland = "pl"
		case portugal = "pt"
		case romania = "ro"
		case serbia = "rs"
		case russia = "ru"
		case saudiArabia = "sa"
		case sweden = "se"
		case singapore = "sg"
		case slovenia = "si"
		case slovakia = "sk"
		case thailand = "th"
		case turkey = "tr"
		case taiwan = "tw"
		case ukraine = "ua"
		case unitedStatesOfAmerica = "us"
		case venezuela = "ve"
		case southAfrica = "za"
	}
	
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
	
	/// The category you want to get headlines for.
	enum Category: String, CaseIterable {
		case business
		case entertainment
		case general
		case health
		case science
		case sports
		case technology
	}
}
