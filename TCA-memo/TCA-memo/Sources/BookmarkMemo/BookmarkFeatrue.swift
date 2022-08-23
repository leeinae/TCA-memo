//
//  BookmarkFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import ComposableArchitecture

// MARK: - State

struct BookmarkState: Equatable {}

// MARK: - Action

enum BookmarkAction {}

// MARK: - Environment

struct BookmarkEnvironment {}

// MARK: - Reducer

let bookmarkReducer = Reducer<
    BookmarkState,
    BookmarkAction,
    BookmarkEnvironment
> { state, action, environment in
    .none
}
