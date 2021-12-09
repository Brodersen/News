//
//  Comparable+Extension.swift
//  News
//
//  Created by Gabriel Brodersen on 06/12/2021.
//

import Foundation

extension Comparable {
	
	/// Clamp a value to fit within the min and max limits of the provided `ClosedRange`.
	/// If the value does not exceeded the limits, then calling this method has no effect.
	/// - Parameter limits: The range to clamp a value between
	/// - Returns: The value clamped within the limits.
	func clamped(to limits: ClosedRange<Self>) -> Self {
		return min(max(self, limits.lowerBound), limits.upperBound)
	}
}
