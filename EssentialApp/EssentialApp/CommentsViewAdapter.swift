//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class CommentsViewAdapter: ResourceView {
	private weak var controller: ListViewController?

	init(controller: ListViewController) {
		self.controller = controller
	}

	func display(_ viewModel: ImageCommentsViewModel) {
		controller?.display(viewModel.comments.map {
			viewModel in
			CellController(id: viewModel, ImageCommentCellController(viewModel: viewModel))
		})
	}
}
