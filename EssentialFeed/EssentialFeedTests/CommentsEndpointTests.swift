//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class CommentsEndpointTests: XCTestCase {
	func test_feed_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let received = ImageCommentsEndpoint.get.url(baseURL: baseURL, imageId: "1")
		let expected = URL(string: "http://base-url.com/v1/image/1/comments")!

		XCTAssertEqual(received, expected)
	}
}
