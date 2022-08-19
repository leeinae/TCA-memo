//
//  TabBarFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import ComposableArchitecture

struct TabBarState: Equatable {}

enum TabBarAction: Equatable {}

struct TabBarEnvironment {}

let tabBarReducer = Reducer<TabBarState, TabBarAction, TabBarEnvironment> { state, action, environment in
    return .none
}
