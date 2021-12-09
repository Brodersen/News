//
//  NewsResponseTests.swift
//  NewsTests
//
//  Created by Gabriel Brodersen on 09/12/2021.
//

import XCTest
@testable import News

class NewsResponseTests: XCTestCase {
	
	var demoServerResponseData: Data!
	var demoServerResponseErrorData: Data!
	var demoResponseInvalidResponseData: Data!
	let decoder = JSONDecoder()
	
	override func setUp() {
		demoServerResponseData = demoResponseJSON.data(using: .utf8)
		demoServerResponseErrorData = demoResponseErrorJSON.data(using: .utf8)
		demoResponseInvalidResponseData = demoResponseInvalidResponseJSON.data(using: .utf8)
		decoder.dateDecodingStrategy = .iso8601
	}
	
	// Test if NewsResponse can be decoded from a JSON response
	func test_decoding_data_response() {
		
		XCTAssertNoThrow(try decoder.decode(NewsResponse.self, from: demoServerResponseData))
		XCTAssertNoThrow(try decoder.decode(NewsResponse.self, from: demoServerResponseErrorData))
		XCTAssertThrowsError(try decoder.decode(NewsResponse.self, from: demoResponseInvalidResponseData))
	}
	
	// Test if decoded NewsResponse objects contains the correct property values
	func test_decoded_newsResponse_properties() {
		
		do {
			let newsResponse = try decoder.decode(NewsResponse.self, from: demoServerResponseData)
			XCTAssert(newsResponse.status == .ok)
			XCTAssert(newsResponse.totalResults == 1234)
			XCTAssert(newsResponse.articles?.count == 3)
			XCTAssert(newsResponse.articles?[0].source?.id == "TestID")
			XCTAssert(newsResponse.articles?[0].source?.name == "TestName")
			XCTAssert(newsResponse.articles?[0].author == "TestAuthor")
			XCTAssert(newsResponse.articles?[0].title == "TestTitle")
			XCTAssert(newsResponse.articles?[0].shortDescription == "TestDescription")
			XCTAssert(newsResponse.articles?[0].url == URL(string: "http://www.test.com/"))
			XCTAssert(newsResponse.articles?[0].urlToImage == URL(string: "http://www.test.com/test.jpeg"))
			XCTAssert(newsResponse.articles?[0].publishedAt == (try! Date("2021-01-01T12:34:56Z", strategy: .iso8601)))
			XCTAssert(newsResponse.articles?[0].content == "TestContent")
		} catch  {
			XCTFail("Decoding failed")
		}
	}
	
	// Test if decoded NewsResponse object from an error response contains the correct property values
	func test_decoded_newsResponse_error_properties() {
		
		do {
			let newsResponse = try decoder.decode(NewsResponse.self, from: demoServerResponseErrorData)
			XCTAssert(newsResponse.status == .error)
			XCTAssert(newsResponse.code == "parametersMissing")
			XCTAssert(newsResponse.message == "DemoMessage")
		} catch  {
			XCTFail("Decoding failed")
		}
	}
	
	
}

// MARK: - Demo JSONs of NewsAPI responses for testing
extension NewsResponseTests {

	var demoResponseJSON: String { """
{
 "status": "ok",
 "totalResults": 1234,
 "articles": [
  {
   "source": {
 "id": "TestID",
 "name": "TestName"
   },
   "author": "TestAuthor",
   "title": "TestTitle",
   "description": "TestDescription",
   "url": "http://www.test.com/",
   "urlToImage": "http://www.test.com/test.jpeg",
   "publishedAt": "2021-01-01T12:34:56Z",
   "content": "TestContent"
  },
  {
   "source": {
 "id": "TestID",
 "name": "TestName"
   },
   "author": "TestAuthor",
   "title": "TestTitle",
   "description": "TestDescription",
   "url": "http://www.test.com/",
   "urlToImage": "http://www.test.com/test.jpeg",
   "publishedAt": "2021-01-01T12:34:56Z",
   "content": "TestContent"
  },
  {
   "source": {
 "id": "TestID",
 "name": "TestName"
   },
   "author": "TestAuthor",
   "title": "TestTitle",
   "description": "TestDescription",
   "url": "http://www.test.com/",
   "urlToImage": "http://www.test.com/test.jpeg",
   "publishedAt": "2021-01-01T12:34:56Z",
   "content": "TestContent"
  }
 ]
}
""" }
	
	var demoResponseErrorJSON: String { """
{
 "status": "error",
 "code": "parametersMissing",
 "message": "DemoMessage"
}
""" }
	
	var demoResponseInvalidResponseJSON: String { """
{
}
""" }
	
}
