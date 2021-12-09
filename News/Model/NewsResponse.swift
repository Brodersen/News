//
//  NewsResponse.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

/// Codable Struct to represent JSON payload from **NewsAPI**
struct NewsResponse: Codable, CustomStringConvertible {
	
	let status: Status
	let code: String?
	let message: String?
	
	let totalResults: Int?
	let articles: [Article]?
	
	enum Status: String, Codable, CustomStringConvertible {
		case ok
		case error
		
		var description: String { self.rawValue }
	}
	
	struct Article: Codable, Identifiable, CustomStringConvertible {
		
		let source: Source?
		let author: String?
		let title: String?
		let shortDescription: String?
		let url: URL?
		let urlToImage: URL?
		let publishedAt: Date?
		let content: String?
		
		var id: String { return url?.absoluteString ?? "" }
		
		struct Source: Codable, CustomStringConvertible {
			let id: String?
			let name: String?
			
			var description: String {
				"""
				Source:
					id: \(String(describing: id))
					name: \(String(describing: name))
				"""
			}
		}
		
		private enum CodingKeys: String, CodingKey {
			case source
			case author
			case title
			case shortDescription = "description"
			case url
			case urlToImage
			case publishedAt
			case content
		}
		
		var description: String {
			"""
			Article:
				source: \(String(describing: source))
				author: \(String(describing: author))
				title: \(String(describing: title))
				description: \(String(describing: shortDescription))
				url: \(String(describing: url))
				urlToImage: \(String(describing: urlToImage))
				publishedAt: \(String(describing: publishedAt))
				content: \(String(describing: content))
			"""
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case status
		case code
		case message
		case totalResults
		case articles
	}
	
	var description: String {
		
		var firstArticleString = ""
		if let firstArticle = articles?.first {
			firstArticleString = """
			
			first article:
				\(firstArticle)
			"""
		}
		
		return """
		NewsResponse:
			status: \(String(describing: status))
			code:  \(String(describing: code))
			message:  \(String(describing: message))
			totalResults:  \(String(describing: totalResults))
			articles: \(articles?.count ?? 0)\(firstArticleString)
		"""
	}
}
