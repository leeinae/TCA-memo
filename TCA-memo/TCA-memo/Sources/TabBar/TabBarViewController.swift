//
//  TabBarViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import UIKit

import ComposableArchitecture

class TabBarViewController: UITabBarController {
    let store: Store<TabBarState, TabBarAction>
    let viewStore: ViewStore<TabBarState, TabBarAction>

    init(store: Store<TabBarState, TabBarAction>) {
        self.store = store
        viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .systemGreen

        let memoListViewController = UINavigationController(
            rootViewController: MemoListViewController(
                store: .init(initialState: MemoListState(
                    memos: [
                        .init(memo: .init(memo: "memo 1")),
                        .init(memo: .init(memo: "memo 2")),
                        .init(memo: .init(memo: "memo 3")),
                    ]
                ),
                reducer: memoListReducer,
                environment: MemoListEnvironment())
            )
        )

        memoListViewController.tabBarItem = UITabBarItem(
            title: "memo",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        let bookmarkMemoViewController = UINavigationController(rootViewController: BookMarkMemoViewController())
        bookmarkMemoViewController.tabBarItem = .init(
            title: "bookmark",
            image: .init(systemName: "bookmark"),
            selectedImage: .init(systemName: "bookmark.fill")
        )

        let myPageViewController = MyPageViewController()
        myPageViewController.tabBarItem = .init(
            title: "person",
            image: .init(systemName: "person"),
            selectedImage: .init(systemName: "person.fill")
        )

        setViewControllers([
            memoListViewController,
            bookmarkMemoViewController,
            myPageViewController,
        ],
        animated: true)
    }

    func bind() {}
}

extension TabBarViewController {
    private var memoListStore: Store<MemoListState, MemoListAction> {
        store.scope(
            state: \.memoListState,
            action: TabBarAction.memoListAction
        )
    }
}
