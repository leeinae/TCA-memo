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
                store: memoListStore
            )
        )
        memoListViewController.tabBarItem = UITabBarItem(
            title: TabBarType.memoList.rawValue,
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        let pokemonWikiViewController = UINavigationController(
            rootViewController: PokemonWikiViewController(
                store: wikiStore)
        )
        pokemonWikiViewController.tabBarItem = .init(
            title: TabBarType.wiki.rawValue,
            image: .init(systemName: "bookmark"),
            selectedImage: .init(systemName: "bookmark.fill")
        )

        let myPageViewController = MyPageViewController()
        myPageViewController.tabBarItem = .init(
            title: TabBarType.mypage.rawValue,
            image: .init(systemName: "person"),
            selectedImage: .init(systemName: "person.fill")
        )

        setViewControllers([
            memoListViewController,
            pokemonWikiViewController,
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

    private var wikiStore: Store<WikiState, WikiAction> {
        store.scope(
            state: \.wikiState,
            action: TabBarAction.wikiAction
        )
    }

    private var myPageStore: Store<MyPageState, MyPageAction> {
        store.scope(
            state: \.myPageState,
            action: TabBarAction.myPageAction
        )
    }
}
