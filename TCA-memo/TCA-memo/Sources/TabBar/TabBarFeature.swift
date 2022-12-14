//
//  TabBarFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - TabBarType

enum TabBarType: String {
    case memoList = "Memo"
    case wiki = "Pokemon Wiki"
    case mypage = "My Page"
}

// MARK: - State

struct TabBarState: Equatable {
    /// Child State
    var memoListState: MemoListState = .init(
        memos: [
            .init(memo: .init(memo: "memo 1")),
            .init(memo: .init(memo: "memo 2")),
            .init(memo: .init(memo: "memo 3")),
        ],
        memoEditor: nil
    )
    var wikiState: WikiState = .init()
    var myPageState: MyPageState = .init()
}

// MARK: - Action

enum TabBarAction {
    case memoListAction(MemoListAction)
    case wikiAction(WikiAction)
    case myPageAction(MyPageAction)
}

// MARK: - Environment

struct TabBarEnvironment {}

// MARK: - Reducer

let tabBarReducer = Reducer<
    BaseState<TabBarState>,
    TabBarAction,
    TabBarEnvironment
>.combine(
    memoListReducer
        .pullback(
            state: \.local.memoListState,
            action: /TabBarAction.memoListAction,
            environment: { _ in MemoListEnvironment() }
        ),
    wikiReducer
        .pullback(
            state: \.local.wikiState,
            action: /TabBarAction.wikiAction,
            environment: { _ in WikiEnvironment() }
        ),
    myPageReducer
        .pullback(
            state: \.local.myPageState,
            action: /TabBarAction.myPageAction,
            environment: { _ in MyPageEnvironment() }
        ),
    Reducer { state, action, _ in
        switch action {
        case .memoListAction:
            return .none
        case let .wikiAction(.changeUserStateSwitch(membership)):
            state.shared.membership = membership
            return .none
        case .wikiAction:
            return .none
        case let .myPageAction(.changeUserStateSwitch(membership)):
            state.shared.membership = membership
            return .none
        case .myPageAction:
            return .none
        }
    }
)
