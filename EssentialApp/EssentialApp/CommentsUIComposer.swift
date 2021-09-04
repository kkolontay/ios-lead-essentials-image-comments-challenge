//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
	private init() {}

	private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

	public static func commentsComposedWith(
		commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>
	) -> ListViewController {
		let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)

		let feedController = makeFeedViewController(title: FeedPresenter.title)
		feedController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: FeedViewAdapter(
				controller: feedController,
				imageLoader: { _ in
					Empty<Data, Error>().eraseToAnyPublisher() },
				selection: { _ in }),
			loadingView: WeakRefVirtualProxy(feedController),
			errorView: WeakRefVirtualProxy(feedController),
			mapper: FeedPresenter.map)

		return feedController
	}

	private static func makeFeedViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! ListViewController
		feedController.title = title
		return feedController
	}
}
