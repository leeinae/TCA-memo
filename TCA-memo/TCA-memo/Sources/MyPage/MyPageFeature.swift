//
//  MyPageFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import ComposableArchitecture

// MARK: - State

struct MyPageState: Equatable {
    let title: TabBarType = .mypage
}

// MARK: - Action

enum MyPageAction {
    case changeUserStateSwitch(Membership)
}

// MARK: - Environment

struct MyPageEnvironment {}

// MARK: - Reducer

let myPageReducer = Reducer<
    MyPageState,
    MyPageAction,
    MyPageEnvironment
> { state, action, environment in
    switch action {
    case .changeUserStateSwitch:
        return .none
    }
}
