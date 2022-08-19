//
//  MemoListFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - State

struct MemoListState: Equatable {
    var memos: [MemoModel] = []
    var isPresentEditor: MemoEditorState? = nil
}

// MARK: - Action

enum MemoListAction {
    case didTapMemoCell
    case addAction
    case dismissEditorAction
}

// MARK: - Environment

struct MemoListEnvironment {}

// MARK: - Reducer

let memoListReducer = Reducer<MemoListState, MemoListAction, MemoListEnvironment> { state, action, environment in
    switch action {
    case .didTapMemoCell:
        return .none
    case .addAction:
        state.isPresentEditor = MemoEditorState()
        return .none
    case .dismissEditorAction:
        state.isPresentEditor = nil
            return .none
    }
}
