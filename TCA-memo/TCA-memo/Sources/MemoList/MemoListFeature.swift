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
    case memoEditorAction(id: MemoEditorState.ID, action: MemoEditorAction)
    case memoAppendAction(MemoEditorAction)
    case addAction
}

// MARK: - Environment

struct MemoListEnvironment {}

// MARK: - Reducer

let memoListReducer: Reducer<MemoListState, MemoListAction, MemoListEnvironment> =
    /// ientified array의 elem에서 동작하는 reducer를 pullback
    memoEditorReducer.forEach(
        state: \MemoListState.memos,
        action: /MemoListAction.memoEditorAction(id:action:),
        environment: { _ in MemoEditorEnvironment() }
    )
    .combined(with: Reducer<MemoListState, MemoListAction, MemoListEnvironment> { state, action, env in
        switch action {
        case .addAction:
            state.memoEditor = MemoEditorState(memo: .init(memo: "", isBookmark: false))
            return .none
        case let .memoEditorAction(id: id, action: action):
            return .none
        case let .memoAppendAction(memo):
            switch memo {
            case let .saveMemo(model):
                state.memos.append(.init(memo: model))
                return .none
            case .setBookmark:
                return .none
            case .dismiss:
                state.memoEditor = nil
                return .none
            }
        }
    })
