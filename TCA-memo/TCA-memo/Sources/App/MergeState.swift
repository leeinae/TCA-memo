//
//  MergeState.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/18.
//

import Foundation

@dynamicMemberLookup
struct MergeState<LocalState: Equatable>: Equatable {
    var local: LocalState
    var global: GlobalState

    init(local: LocalState, global: GlobalState) {
        self.local = local
        self.global = global
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<LocalState, T>) -> MergeState<T> {
        get {
            .init(local: local[keyPath: keyPath], global: global)
        }
        set {
            local[keyPath: keyPath] = newValue.local
        }
    }
}

struct GlobalState: Equatable {
    var membership: Membership = .member
}
