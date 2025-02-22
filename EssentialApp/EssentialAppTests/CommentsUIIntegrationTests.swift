//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import UIKit
import Combine
import EssentialApp
import EssentialFeed
import EssentialFeediOS

class CommentsUIIntegrationTests: XCTestCase {
	func test_commentView_hasTitle() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, commentsTitle)
	}

	func test_loadCommentsActions_requestCommentsFromLoader() {
		let (sut, loader) = makeSUT()
		XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view is loaded")

		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view is loaded")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 2, "Expected another loading request once user initiates a reload")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 3, "Expected yet another loading request once user initiates another reload")
	}

	func test_loadingCommentsIndicator_isVisibleWhileLoadingComments() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

		loader.completeCommentsLoading(at: 0)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

		sut.simulateUserInitiatedReload()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

		loader.completeCommentsLoadingWithError(at: 1)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
	}

	func test_loadCommentsCompletion_rendersSuccessfullyLoadedComments() {
		let comment0 = makeComment(message: "a message", username: "a username")
		let comment1 = makeComment(message: "another message", username: "another imagename")

		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		assertThat(sut, isRendering: [])

		loader.completeCommentsLoading(with: [comment0], at: 0)
		assertThat(sut, isRendering: [comment0])

		sut.simulateUserInitiatedReload()
		loader.completeCommentsLoading(with: [comment0, comment1], at: 1)
		assertThat(sut, isRendering: [comment0, comment1])
	}

	func test_loadCommentsCompletion_rendersSuccessfullyLoadedEmptyCommentsAfterNonEmptyComments() {
		let comment = makeComment()
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeCommentsLoading(with: [comment], at: 0)
		assertThat(sut, isRendering: [comment])

		sut.simulateUserInitiatedReload()
		loader.completeCommentsLoading(with: [], at: 1)
		assertThat(sut, isRendering: [])
	}

	func test_loadCommentsCompletion_doesNotAlterCurrentRenderingStateOnError() {
		let comment = makeComment()
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeCommentsLoading(with: [comment], at: 0)
		assertThat(sut, isRendering: [comment])

		sut.simulateUserInitiatedReload()
		loader.completeCommentsLoadingWithError(at: 1)
		assertThat(sut, isRendering: [comment])
	}

	func test_loadCommentsCompletion_dispatchesFromBackgroundToMainThread() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()

		let exp = expectation(description: "Wait for background queue")
		DispatchQueue.global().async {
			loader.completeCommentsLoading(at: 0)
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
	}

	func test_loadCommentsCompletion_rendersErrorMessageOnErrorUntilNextReload() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertEqual(sut.errorMessage, nil)

		loader.completeCommentsLoadingWithError(at: 0)
		XCTAssertEqual(sut.errorMessage, loadError)

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(sut.errorMessage, nil)
	}

	func test_tapOnErrorView_hidesErrorMessage() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertEqual(sut.errorMessage, nil)

		loader.completeCommentsLoadingWithError(at: 0)
		XCTAssertEqual(sut.errorMessage, loadError)

		sut.simulateErrorViewTap()
		XCTAssertEqual(sut.errorMessage, nil)
	}

	func test_deinit_cancelsuRningRequest() {
		var cancellCallCount = 0
		var sut: ListViewController?

		autoreleasepool {
			sut = CommentsUIComposer.commentsComposedWith(commentsLoader: {
				PassthroughSubject<[ImageComment], Error>().handleEvents(receiveCancel: {
					cancellCallCount += 1
				}).eraseToAnyPublisher()
			})

			sut?.loadViewIfNeeded()
		}

		XCTAssertEqual(cancellCallCount, 0)

		sut = nil

		XCTAssertEqual(cancellCallCount, 1)
	}

	// MARK: - Helpers

	private func makeSUT(
		selection: @escaping (FeedImage) -> Void = { _ in },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: ListViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = CommentsUIComposer.commentsComposedWith(
			commentsLoader: loader.loadPublisher
		)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}

	private func assertThat(_ sut: ListViewController, isRendering comments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
		XCTAssertEqual(sut.numberOfRenderedComments(), comments.count, "comments count", file: file, line: line)
		let viewModel = ImageCommentsPresenter.map(comments)
		viewModel.comments.enumerated().forEach {
			index, comment in
			XCTAssertEqual(sut.commentMessage(at: index), comment.message, "message at \(index)", file: file, line: line)
			XCTAssertEqual(sut.commentDate(at: index), comment.date, "date at \(index)", file: file, line: line)
			XCTAssertEqual(sut.commentUsername(at: index), comment.username, "username at \(index)", file: file, line: line)
		}
	}

	private func makeComment(message: String = "any message", username: String = "any name", createdAt: Date = Date()) -> ImageComment {
		return ImageComment(id: UUID(), message: message, createdAt: createdAt, username: username)
	}

	private final class LoaderSpy {
		// MARK: - FeedLoader

		private var request = [PassthroughSubject<[ImageComment], Error>]()

		var loadCommentsCallCount: Int {
			return request.count
		}

		func loadPublisher() -> AnyPublisher<[ImageComment], Error> {
			let publisher = PassthroughSubject<[ImageComment], Error>()
			request.append(publisher)
			return publisher.eraseToAnyPublisher()
		}

		func completeCommentsLoading(with comments: [ImageComment] = [], at index: Int = 0) {
			request[index].send(comments)
		}

		func completeCommentsLoadingWithError(at index: Int = 0) {
			let error = NSError(domain: "an error", code: 0)
			request[index].send(completion: .failure(error))
		}
	}
}
