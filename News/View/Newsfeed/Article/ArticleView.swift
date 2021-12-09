//
//  ArticleView.swift
//  News
//
//  Created by Gabriel Brodersen on 08/12/2021.
//

import SwiftUI

struct ArticleView: View {
	
	@Environment(\.openURL) var openURL
	
	let article: NewsResponse.Article
	
	let placeholderAspectRatio: CGFloat = 5/3
	
    var body: some View {
		ScrollView {
			
			VStack {
				
				// Article Image
				if let urlToImage = article.urlToImage {
					AsyncImage(url: urlToImage) { phase in
						if let image = phase.image {
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.background(Color.gray)
						} else if phase.error != nil {
							// Error Placeholder
							ImagePlaceholderView(systemName: "questionmark")
								.aspectRatio(placeholderAspectRatio, contentMode: .fit)
								
						} else {
							// Placeholder
							ImagePlaceholderView(systemName: "photo")
								.aspectRatio(placeholderAspectRatio, contentMode: .fit)
						}
					}
				} else {
					// Error Placeholder
					ImagePlaceholderView(systemName: "photo.fill")
						.aspectRatio(placeholderAspectRatio, contentMode: .fit)
				}
					
				
				// Article Body
				VStack {
					HStack {}
					Text(article.title ?? "No title")
						.font(.headline)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
					
					// Author and date
					HStack {
						if let author = article.author {
							Text(author)
								.fontWeight(.bold)
						}
						Spacer()
						
						if let publishDate = article.publishedAt {
							Text(publishDate, style: .date)
								.fontWeight(.semibold)
								.fixedSize()
						}
						
					}
					.foregroundColor(.secondary)
					.font(.caption)
					.lineLimit(1)
					.padding(.bottom, 1)
					
					// Description Text
					Text(article.shortDescription ?? "No content")
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					// Link to news source
					if let url = article.url {
						
						Button("View original article") {
							openURL(url)
						}
						.buttonStyle(.bordered)
						.padding()
						
					}
				
					
				}
				.padding()
				
				
					
				
				Spacer()
			}
		
		
		}
		
		.navigationTitle(article.source?.name ?? article.author ?? "News")
		.navigationBarTitleDisplayMode(.inline)
		
    }
}

#if DEBUG
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ArticleView(article: NewsResponse.demoArticles[0])
		}.preferredColorScheme(.light)
	}
}
#endif
