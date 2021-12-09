//
//  NewsfeedView.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import SwiftUI

struct NewsfeedView: View {
	
	@StateObject private var newsfeed = NewsFeeder(apiKey: Authentication.apiKey)
	
	@State private var alertMessage = ""
	@State private var showAlert = false
	
	var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack {
					
					// No articles info messages
					if newsfeed.articles.isEmpty && newsfeed.errorMessages == nil {
						if newsfeed.lastResponseWasEmpty && !newsfeed.query.isEmpty {
							
							// No search results
							Text("No results for **\(newsfeed.query)**")
								.font(.callout)
								.foregroundColor(.secondary)
								.padding()
						} else {
							
							// Loading spinning wheel
							ProgressView()
								.font(.callout)
								.foregroundColor(.secondary)
								.padding()
						}
					}
					
					// Articles
					ForEach(newsfeed.articles) { article in
						NavigationLink(destination: ArticleView(article: article), label: {
							ArticleCardView(article: article)
								.padding(.horizontal)
								.padding(.bottom)
						})
					}
					
					// End of feed info messages
					if !newsfeed.articles.isEmpty {
						if newsfeed.maxPageReached {
							
							// End reached
							Text("No more results available")
								.font(.callout)
								.foregroundColor(.secondary)
						} else if newsfeed.errorMessages == nil {
							
							// Infinite scroll spinning wheel
							ProgressView()
								.onAppear {
									newsfeed.loadNextPage()
								}
						}
					}
				}
			}
			.searchable(text: $newsfeed.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search the news")
			.navigationTitle("News")
		}
		.alert(alertMessage, isPresented: $showAlert) {
			Button("OK", role: .cancel) { }
		}
		.onReceive(newsfeed.$errorMessages) { message in
			if let message = message {
				alertMessage = message
				showAlert = true
			}
		}
		.onAppear {
			
#if DEBUG && !targetEnvironment(simulator)
			newsfeed.loadDemoArticles(NewsResponse.demoArticles)
#endif
			newsfeed.searchQuery()
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NewsfeedView()
	}
}
