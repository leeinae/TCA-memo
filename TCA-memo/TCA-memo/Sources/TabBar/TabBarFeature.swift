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
    var wikiState: WikiState = .init(membership: .member)
    var myPageState: MyPageState = .init()

    var userState: UserState = .init()
}

// MARK: - Action

enum TabBarAction {
    case memoListAction(MemoListAction)
    case wikiAction(WikiAction)
    case myPageAction(MyPageAction)
    
    case userAction(UserAction)
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
    wikiReducer
        .pullback(
            state: \.wikiState,
            action: /TabBarAction.wikiAction,
            environment: { _ in WikiEnvironment() }
        ),
    myPageReducer
        .pullback(
            state: \.myPageState,
            action: /TabBarAction.myPageAction,
            environment: { _ in MyPageEnvironment() }
        ),
    userReducer
        .pullback(
            state: \.userState,
            action: /TabBarAction.userAction,
            environment: { _ in UserEnvironment() }
        ),
    Reducer { state, action, _ in
        switch action {
        case .memoListAction:
            return .none
        case let .wikiAction(.changeUserStateSwitch(membership)):
            return Effect(value: .userAction(.changeUserStatus(membership)))
        case .wikiAction:
            return .none
        case .myPageAction:
            return .none
        case let .userAction(.changeUserStatus(membership)):
            state.wikiState.membership = membership
            return Effect(value: .wikiAction(.refresh(true)))
        }
    }
)
