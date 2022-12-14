//
//  TabBarViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import UIKit

import ComposableArchitecture

class TabBarViewController: UITabBarController {
    let store: Store<BaseState<TabBarState>, TabBarAction>
    let viewStore: ViewStore<BaseState<TabBarState>, TabBarAction>

    init(store: Store<BaseState<TabBarState>, TabBarAction>) {
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
                store: wikiStore
            )
        )
        pokemonWikiViewController.tabBarItem = .init(
            title: TabBarType.wiki.rawValue,
            image: .init(systemName: "bookmark"),
            selectedImage: .init(systemName: "bookmark.fill")
        )

        let myPageViewController = MyPageViewController(
            store: store.scope(
                state: \.myPageState,
                action: TabBarAction.myPageAction
            ))
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
}

extension TabBarViewController {
    private var memoListStore: Store<MemoListState, MemoListAction> {
        store.scope(
            state: \.local.memoListState,
            action: TabBarAction.memoListAction
        )
    }

    private var wikiStore: Store<BaseState<WikiState>, WikiAction> {
        store.scope(
            state: \.wikiState,
            action: TabBarAction.wikiAction
        )
    }

    private var myPageStore: Store<BaseState<MyPageState>, MyPageAction> {
        store.scope(
            state: \.myPageState,
            action: TabBarAction.myPageAction
        )
    }
}
