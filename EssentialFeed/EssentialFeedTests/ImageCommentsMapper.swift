//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsMapper {
	private struct Root: Decodable {
		private let items: [ImageCommentsItem]

		private struct ImageCommentsItem: Decodable {
			let id: UUID
			let description: String?
			let location: String?
			let image: URL
		}

		var images: [ImageComments] {
			items.map { ImageComments(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
		}
	}

	public enum Error: Swift.Error {
		case invalidData
	}

	public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComments] {
		guard isOK(code: response.statusCode), let root = try? JSONDecoder().decode(Root.self, from: data) else {
			throw Error.invalidData
		}

		return root.images
	}

	static func isOK(code: Int) -> Bool {
		(200 ... 299).contains(code)
	}
}
