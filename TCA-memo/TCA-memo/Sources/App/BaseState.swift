//
//  BaseState.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/18.
//
/// REF: https://forums.swift.org/t/best-practice-for-sharing-data-between-many-features/37696/3

import Foundation

@dynamicMemberLookup
struct BaseState<LocalState: Equatable>: Equatable {
    var local: LocalState
    var shared: SharedState

    init(local: LocalState, shared: SharedState) {
        self.local = local
        self.shared = shared
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<LocalState, T>) -> BaseState<T> {
        get {
            .init(local: local[keyPath: keyPath], shared: shared)
        }
        set {
            local[keyPath: keyPath] = newValue.local
        }
    }
}

struct SharedState: Equatable {
    var membership: Membership = .member
}
