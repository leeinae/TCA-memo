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
    var memoEditor: MemoEditorState? = nil
}

// MARK: - Action

enum MemoListAction {
    case addAction
    case presentMemoEditor(MemoEditorAction)
    case dismissMemoEditor
}

// MARK: - Environment

struct MemoListEnvironment {}

// MARK: - Reducer

let memoListReducer = Reducer<MemoListState, MemoListAction, MemoListEnvironment> { state, action, _ in
    switch action {
    case .addAction:
        state.memoEditor = MemoEditorState()
        return .none
    case .presentMemoEditor:
        state.memoEditor = MemoEditorState()
        return .none
    case .dismissMemoEditor:
        state.memoEditor = nil
        return .none
    }
}
