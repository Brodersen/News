//
//  String+Extension.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

extension String {
	
	/// Truncate a string to a max number of characters.
	/// - Parameter maxCount: The maximum number of characters allowed.
	/// - Returns: The string truncated (if needed) to the specified number of characters.
	public func truncate(to maxCount: Int) -> Self {
		self.count > maxCount ? String(self.prefix(maxCount)) : self
	}
}
