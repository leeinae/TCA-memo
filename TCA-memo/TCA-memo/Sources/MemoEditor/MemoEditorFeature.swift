//
//  MemoEditorFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - State

struct MemoEditorState: Equatable, Identifiable {
    let id: String = UUID().uuidString
    var memo: MemoModel
}

// MARK: - Action

enum MemoEditorAction: Equatable {
    case saveMemo(MemoModel)
    case setBookmark(Bool)
    case dismiss
}

// MARK: - Environment

struct MemoEditorEnvironment {}

// MARK: - Reducer

let memoEditorReducer = Reducer<MemoEditorState, MemoEditorAction, MemoEditorEnvironment> { state, action, _ in
    switch action {
    case let .saveMemo(memo):
        state.memo = memo
        return .none
    case let .setBookmark(flag):
        state.memo.isBookmark = flag
        return .none
    case .dismiss:
        return .none
    }
}
