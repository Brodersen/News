//
//  Endpoint.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

/// A **NewsAPI** endpoint to attach the root URL
protocol Endpoint {
	var path: String { get }	
	init(root: URLComponents)
}

