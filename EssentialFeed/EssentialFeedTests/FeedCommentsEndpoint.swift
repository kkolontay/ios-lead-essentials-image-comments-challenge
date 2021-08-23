//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public enum FeedCommentsEndpoint {
	case get

	public func url(baseURL: URL, imageId: String) -> URL {
		switch self {
		case .get:
			return baseURL.appendingPathComponent("v1/image/\(imageId)/comments")
		}
	}
}
