//
//  NewsAPI.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

/// The **NewsAPI** root URL components and endpoints
enum NewsAPI {
	
	// Get API Key at https://newsapi.org/register
	static let scheme = "https"
	static let host = "newsapi.org"
	static private var components: URLComponents {
		var component = URLComponents()
		component.scheme = scheme
		component.host = host
		return component
	}

	// MARK: Endpoints
	static let everything = Everything(root: NewsAPI.components)
	static let topHeadlines = TopHeadlines(root: NewsAPI.components)
		
}

// MARK: - NewsAPI HTTP Status Codes
extension NewsAPI {
	
	/// See: https://newsapi.org/docs/errors
	enum HTTPStatusCodes: CustomStringConvertible, CustomDebugStringConvertible {
		
		case ok,
			 badRequest,
			 unauthorized,
			 tooManyRequests,
			 serverError
		
		init?(_ statusCode: Int) {
			switch statusCode {
				case 200: self = .ok
				case 400: self = .badRequest
				case 401: self = .unauthorized
				case 429: self = .tooManyRequests
				case 500: self = .serverError
				default: return nil
			}
		}
		
		var description: String {
			switch self {
				case .ok: return "200 - OK"
				case .badRequest: return "400 - Bad Request"
				case .unauthorized: return "401 - Unauthorized"
				case .tooManyRequests: return "429 - Too Many Requests"
				case .serverError: return "500 - Server Error"
			}
		}
		
		var debugDescription: String {
			var value = self.description + ": "
			switch self  {
				case .ok:
					value += "The request was executed successfully."
				case .badRequest:
					value += "The request was unacceptable, often due to a missing or misconfigured parameter."
				case .unauthorized:
					value += "Your API key was missing from the request, or wasn't correct."
				case .tooManyRequests:
					value += "You made too many requests within a window of time and have been rate limited. Back off for a while."
				case .serverError:
					value += "Something went wrong on our side."
			}
			return value
		}
		
	}
	
	/// See: https://newsapi.org/docs/errors
	enum ErrorCodes: String {
		case apiKeyDisabled
		case apiKeyExhausted
		case apiKeyInvalid
		case apiKeyMissing
		case parameterInvalid
		case parametersMissing
		case rateLimited
		case sourcesTooMany
		case sourceDoesNotExist
		case unexpectedError
		case maximumResultsReached
	}
}
