//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class CommentsEndpointTests: XCTestCase {
	func test_feed_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!
		let uuid = UUID()
		let received = ImageCommentsEndpoint.get(uuid).url(baseURL: baseURL)
		let expected = URL(string: "http://base-url.com/v1/image/\(uuid)/comments")!

		XCTAssertEqual(received, expected)
	}
}
