//
//  UserFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/09/07.
//

import Foundation

import ComposableArchitecture

enum Membership: Equatable {
    case member
    case premium
}

enum UserAction: Equatable {
    case changeUserStatus(Membership)
}

struct UserState: Equatable {
    var userStatus: Membership = .member
}

struct UserEnvironment {}

let userReducer = Reducer<UserState, UserAction, UserEnvironment>
    .combine(
        Reducer { state, action, environment in
            switch action {
            case let .changeUserStatus(status):
                state.userStatus = status
                return .none
            }
        }
    )
