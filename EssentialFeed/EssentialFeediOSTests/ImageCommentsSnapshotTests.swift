//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ImageCommentsSnapshotTests: XCTestCase {
	func test_listWithComments() {
		let sut = makeSUT()

		sut.display(comments())

		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "IMAGE_COMMENTS_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "IMAGE_COMMENTS_dark")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "IMAGE_COMMENTS_light_extraExtraExtraLarge")
	}

	// MARK: - Helpers

	private func makeSUT() -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let controller = storyboard.instantiateInitialViewController() as! ListViewController
		controller.loadViewIfNeeded()
		controller.tableView.showsVerticalScrollIndicator = false
		controller.tableView.showsHorizontalScrollIndicator = false
		return controller
	}

	private func comments() -> [ImageCommentCellController] {
		return [
			ImageCommentCellController(viewModel: ImageCommentViewModel(message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.", username: "Long Long Long Long username", date: "2 days ago")),
			ImageCommentCellController(viewModel: ImageCommentViewModel(message: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long.", username: " Long Long username", date: "4 minutes ago")),
			ImageCommentCellController(viewModel: ImageCommentViewModel(message: "The East Side Gallery.", username: "username", date: "1 day ago"))
		]
	}
}

private extension ListViewController {
	func display(_ stubs: [ImageCommentCellController]) {
		let cells: [CellController] = stubs.map { stub in
			return CellController(id: UUID(), stub)
		}

		display(cells)
	}
}
