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
    case editAction
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
