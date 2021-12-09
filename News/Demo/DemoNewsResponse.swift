//
//  NewsResponseDemo.swift
//  News
//
//  Created by Gabriel Brodersen on 08/12/2021.
//

#if DEBUG
import Foundation

// Used mainly for SwiftUI Previews
extension NewsResponse {
	
	static var demoArticles: [Article] {
		let article1 = Article(source: Article.Source(id: "cnn", name: "CNN"),
							   author: "Ivana Kottasová, CNN",
							   title: "Olaf Scholz appointed as Germany's new chancellor, replacing Angela Merkel after 16 years - CNN",
							   shortDescription: "Olaf Scholz was voted in as Germany's new Chancellor on Wednesday, bringing to an end Angela Merkel's four terms at the helm of Europe's largest economy.",
							   url: URL(string: "https://www.cnn.com/2021/12/08/europe/germany-olaf-scholz-chancellor-inauguration-intl/index.html")!,
							   urlToImage: URL(string: "https://cdn.cnn.com/cnnnext/dam/assets/211208045003-03-olaf-scholz-12-08-2021-super-tease.jpg")!,
							   publishedAt: try! Date("2021-12-08T10:12:00Z", strategy: .iso8601),
							   content: "Image source, Getty Images\r\nImage caption, Olaf Scholz was given a standing ovation by MPs in the Bundestag after he was elected as chancellor\r\nOlaf Scholz has been confirmed as Germany's new chancel… [+2975 chars]")
		let article2 = Article(source: Article.Source(id: "bbc-news", name: "BBC News"),
							   author: "https://www.facebook.com/bbcnews",
							   title: "Germany's Olaf Scholz takes over from Merkel as chancellor - BBC News",
							   shortDescription: "Olaf Scholz is confirmed as chancellor, leading a three-party coalition after 16 years of Merkel rule.",
							   url: URL(string: "https://www.bbc.co.uk/news/world-europe-59575773")!,
							   urlToImage: URL(string: "https://ichef.bbci.co.uk/news/1024/branded_news/1690F/production/_122013429_scholzoutside.jpg")!,
							   publishedAt: try! Date("2021-12-08T10:36:00Z", strategy: .iso8601),
							   content: "(CNN)Olaf Scholz was voted in as Germany's new Chancellor on Wednesday, bringing to an end Angela Merkel's four terms at the helm of Europe's largest economy.\r\nScholz, the leader of the Social Democr… [+3153 chars]")
		return [article1, article2]
	}
	
	static var demoResponse = NewsResponse(status: Status.ok,
										   code: nil,
										   message: nil,
										   totalResults: 123,
										   articles: demoArticles)
	
	static var demoFailResponse = NewsResponse(status: Status.error,
											   code: "sourceDoesNotExist",
											   message: "You have requested a source which does not exist.",
											   totalResults: nil,
											   articles: nil)
}
#endif
