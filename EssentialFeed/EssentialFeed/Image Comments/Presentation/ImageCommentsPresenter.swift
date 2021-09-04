//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public struct ImageCommentsViewModel {
	public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Hashable {
	public let message: String
	public let username: String
	public let date: String

	public init(message: String, username: String, date: String) {
		self.message = message
		self.username = username
		self.date = date
	}
}

public final class ImageCommentsPresenter {
	public static var title: String {
		NSLocalizedString(
			"IMAGE_COMMENTS_VIEW_TITLE",
			tableName: "ImageComments",
			bundle: Bundle(for: Self.self),
			comment: "Title for the image comments view")
	}

	public static func map(_ comments: [ImageComment], currentDate: Date = Date(), calendar: Calendar = .current, locale: Locale = .current) -> ImageCommentsViewModel {
		let formatter = RelativeDateTimeFormatter()
		formatter.calendar = calendar
		formatter.locale = locale
		return ImageCommentsViewModel(comments: comments.map {
			ImageCommentViewModel(message: $0.message, username: $0.username, date: formatter.localizedString(for: $0.createdAt, relativeTo: currentDate))
		})
	}
}
