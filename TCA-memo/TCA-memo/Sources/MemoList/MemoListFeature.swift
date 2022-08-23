//
//  MemoListFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - State

struct MemoListState: Equatable {
    var memos: IdentifiedArrayOf<MemoEditorState> = []
    var memoEditor: MemoEditorState? = nil
}

// MARK: - Action

enum MemoListAction {
    case showMemo(id: MemoEditorState.ID, action: MemoEditorAction)
    case addAction
}

// MARK: - Environment

struct MemoListEnvironment {}

// MARK: - Reducer

let memoListReducer: Reducer<MemoListState, MemoListAction, MemoListEnvironment> =
    memoEditorReducer.forEach(
        state: \MemoListState.memos,
        action: /MemoListAction.showMemo(id:action:),
        environment: { _ in MemoEditorEnvironment() }
    )
    .combined(with: Reducer<MemoListState, MemoListAction, MemoListEnvironment> { state, action, env in
        switch action {
        case .addAction:
            state.memoEditor = MemoEditorState(memo: .init(memo: "", isBookmark: false))
            return .none
        case let .showMemo(id: id, action: action):
            return .none
        }
    })
