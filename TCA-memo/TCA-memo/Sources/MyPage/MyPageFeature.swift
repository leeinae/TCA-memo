//
//  MyPageFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import ComposableArchitecture

// MARK: - State

struct MyPageState: Equatable {}

// MARK: - Action

enum MyPageAction {}

// MARK: - Environment

struct MyPageEnvironment {}

// MARK: - Reducer

let myPageReducer = Reducer<
    MyPageState,
    MyPageAction,
    MyPageEnvironment
> { state, action, environment in
    .none
}
