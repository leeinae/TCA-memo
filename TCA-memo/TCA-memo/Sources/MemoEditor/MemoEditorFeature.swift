//
//  MemoEditorFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

// MARK: - State

struct MemoEditorState: Equatable {}

// MARK: - Action

enum MemoEditorAction: Equatable {}

// MARK: - Environment

struct MemoEditorEnvironment {}

// MARK: - Reducer

let memoEditorReducer = Reducer<MemoEditorState, MemoEditorAction, MemoEditorEnvironment> { state, action, environment in
    .none
}
