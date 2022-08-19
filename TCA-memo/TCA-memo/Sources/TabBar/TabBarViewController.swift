//
//  TabBarViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .systemGreen

        let memoListViewController = UINavigationController(rootViewController: MemoListViewController(store: .init(initialState: MemoListState(), reducer: memoListReducer, environment: MemoListEnvironment())))
        memoListViewController.tabBarItem = .init(
            title: "memo",
            image: .init(systemName: "book"),
            selectedImage: .init(systemName: "book.fill")
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
}
