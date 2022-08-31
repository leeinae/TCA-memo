//
//  BookmarkFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import ComposableArchitecture

// MARK: - State

struct WikiState: Equatable {}

// MARK: - Action

enum WikiAction {}

// MARK: - Environment

struct WikiEnvironment {}

// MARK: - Reducer

let bookmarkReducer = Reducer<
    WikiState,
    WikiAction,
    WikiEnvironment
> { state, action, environment in
    .none
}
