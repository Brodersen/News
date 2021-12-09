//
//  ArticleCardView.swift
//  News
//
//  Created by Gabriel Brodersen on 08/12/2021.
//

import SwiftUI

struct ArticleCardView: View {
	
	let article: NewsResponse.Article
	let padding: CGFloat = 8
	
	var body: some View {
		Section(
			content: {
				ZStack (alignment: .bottomLeading) {
					
					// Square background image
					Rectangle().fill(.clear)
						.aspectRatio(1, contentMode: .fit)
						.background(
							
							// Article image
							Group {
								if let url = article.urlToImage {
									AsyncImage(url: url) { phase in
										if let image = phase.image {
											image
												.resizable()
												.aspectRatio(contentMode: .fill)
												.background(Color.gray)
										} else if phase.error != nil {
											// Error Placeholder
											ImagePlaceholderView(systemName: "questionmark")
										} else {
											// Placeholder
											ImagePlaceholderView(systemName: "photo")
										}
									}
								} else {
									// Error Placeholder
									ImagePlaceholderView(systemName: "photo.fill")
								}
							}
						)
					
					// Article Title & Meta
					VStack (alignment: .leading) {
						
						// Title
						Text(article.title ?? "")
							.font(.headline)
							.lineLimit(3)
							.minimumScaleFactor(0.8)
							.multilineTextAlignment(.leading)
							.foregroundColor(.primary)
							.padding(.horizontal, padding)
							.padding(.top, padding)
							.padding(.bottom, 1)
						
						// Meta
						HStack (alignment: .bottom) {
							
							// Name
							if let name = article.source?.name {
								Text(name)
									.fontWeight(.bold)
							}
							Spacer(minLength: 10)
							
							// Date
							if let publishDate = article.publishedAt {
								Text(publishDate, style: .date)
									.fontWeight(.semibold)
									.fixedSize()
							}
							
						}
						.foregroundColor(.secondary)
						.font(.caption)
						.lineLimit(1)
						.padding(.horizontal, padding)
						.padding(.bottom, padding)
						
					}
					.background(.ultraThinMaterial)
				}
				.cornerRadius(10)
				.overlay(RoundedRectangle(cornerRadius: 10)
							.stroke(Color.gray.opacity(0.25), lineWidth: 1))
			}
		)
			.listRowInsets(EdgeInsets())
	}
}

#if DEBUG
struct ArticleFeedView_Previews: PreviewProvider {
	static var previews: some View {
		ArticleCardView(article: NewsResponse.demoArticles[0])
			.padding()
			.previewLayout(.sizeThatFits)
			.preferredColorScheme(.light)
		ArticleCardView(article: NewsResponse.demoArticles[0])
			.padding()
			.previewLayout(.sizeThatFits)
			.preferredColorScheme(.dark)
	}
}
#endif
