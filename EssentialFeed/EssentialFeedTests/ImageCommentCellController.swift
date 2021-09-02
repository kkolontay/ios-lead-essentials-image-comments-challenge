//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import EssentialFeed

public final class ImageCommentCellController: NSObject {
	public typealias ResourceViewModel = ImageCommentViewModel
	private let viewModel: ImageCommentViewModel
	private var cell: ImageCommentCell?

	public init(viewModel: ImageCommentViewModel) {
		self.viewModel = viewModel
	}
}

extension ImageCommentCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		cell = tableView.dequeueReusableCell()
		cell?.messageLabel.text = viewModel.message
		cell?.dateLabel.text = viewModel.date
		cell?.usernameLabel.text = viewModel.username

		return cell!
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		cancelLoad()
	}

	private func cancelLoad() {
		releaseCellForReuse()
	}

	private func releaseCellForReuse() {
		cell = nil
	}
}

extension ImageCommentCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
	public func display(_ viewModel: ImageCommentViewModel) {}

	public func display(_ viewModel: ResourceLoadingViewModel) {}

	public func display(_ viewModel: ResourceErrorViewModel) {}
}
