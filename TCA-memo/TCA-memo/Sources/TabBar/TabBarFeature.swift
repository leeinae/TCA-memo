//
//  TabBarFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - TabBarType

enum TabBarType {
    case memoList
    case bookmark
    case mypage
}

// MARK: - State

struct TabBarState: Equatable {
    var selectedTab: TabBarType = .memoList

    var memoListState: MemoListState = .init()
    var bookmarkState: BookmarkState = .init()
    var myPageState: MyPageState = .init()
}

// MARK: - Action

enum TabBarAction {
    case setSelectedTabBar(TabBarType)

    case memoListAction(MemoListAction)
    case bookmarkAction(BookmarkAction)
    case myPageAction(MyPageAction)
}

// MARK: - Environment

struct TabBarEnvironment {}

// MARK: - Reducer

let tabBarReducer = Reducer<
    TabBarState,
    TabBarAction,
    TabBarEnvironment
>.combine(
    memoListReducer
        .pullback(
            state: \.memoListState,
            action: /TabBarAction.memoListAction,
            environment: { _ in MemoListEnvironment() }
        ),
    bookmarkReducer
        .pullback(
            state: \.bookmarkState,
            action: /TabBarAction.bookmarkAction,
            environment: { _ in BookmarkEnvironment() }
        ),
    myPageReducer
        .pullback(
            state: \.myPageState,
            action: /TabBarAction.myPageAction,
            environment: { _ in MyPageEnvironment() }
        ),
    Reducer { state, action, environment in
        switch action {
        case let .setSelectedTabBar(selectedTab):
            state.selectedTab = selectedTab
            return .none
        case .memoListAction:
            return .none
        case .bookmarkAction:
            return .none
        case .myPageAction:
            return .none
        }
    }
)
