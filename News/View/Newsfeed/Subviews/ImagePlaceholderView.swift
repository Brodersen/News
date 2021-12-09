//
//  ImagePlaceholderView.swift
//  News
//
//  Created by Gabriel Brodersen on 08/12/2021.
//

import SwiftUI

struct ImagePlaceholderView: View {
	
	let systemName: String
	
	var body: some View {
		Color.gray.overlay(Image(systemName: systemName))
			.imageScale(.large)
			.font(.largeTitle)
			.foregroundColor(.secondary)
			
	}
}

struct ImagePlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
		ImagePlaceholderView(systemName: "swift")
			.preferredColorScheme(.light)
			.previewLayout(.fixed(width: 200, height: 200))
		ImagePlaceholderView(systemName: "swift")
			.preferredColorScheme(.dark)
			.previewLayout(.fixed(width: 200, height: 200))
    }
}
