//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class CommentsEndpointTests: XCTestCase {
	func test_feed_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!
		let uuid = UUID(uuidString: "2DFA394E-1179-11EC-82A8-0242AC130003")!
		let received = ImageCommentsEndpoint.get(uuid).url(baseURL: baseURL)
		let expected = URL(string: "http://base-url.com/v1/image/2DFA394E-1179-11EC-82A8-0242AC130003/comments")!

		XCTAssertEqual(received, expected)
	}
}
