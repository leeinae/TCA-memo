//
//  BookmarkFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import Foundation

import ComposableArchitecture

// MARK: - State

struct WikiState: Equatable {
    let title: TabBarType = .wiki

    var pokemons: IdentifiedArrayOf<Pokemon> = []
    var items: IdentifiedArrayOf<Item> = []
    var types: IdentifiedArrayOf<TypeModel> = []

    var refresh: Bool = false

    /// Child State
    var userState: UserState = .init()
}

// MARK: - Action

enum WikiAction {
    case viewDidLoad

    case pokemonDataLoaded(Result<PokemonResponseModel, Error>)
    case tapPokemonLikeButton(Int, Bool)

    case itemDataLoaded(Result<ItemResponseModel, Error>)
    case typeDataLoaded(Result<TypeResponseModel, Error>)

    case refresh(Bool)

    /// Child Action
    case user(UserAction)
}

// MARK: - Environment

struct WikiEnvironment {
    var pokemonService: PokemonService

    init() {
        pokemonService = .init(sesseion: .default)
    }
}

// MARK: - Reducer

let wikiReducer = Reducer<
    WikiState,
    WikiAction,
    WikiEnvironment
>.combine(
    userReducer
        .pullback(
            state: \.userState,
            action: /WikiAction.user,
            environment: { _ in UserEnvironment() }
        ),
    Reducer { state, action, environment in
        switch action {
        case .viewDidLoad:
            return Effect.merge(
                [(0 ... 10).map {
                    environment.pokemonService
                        .fetchPokemon(id: $0)
                        .catchToEffect(WikiAction.pokemonDataLoaded)
                },
                (0 ... 10).map {
                    environment.pokemonService
                        .fetchItem(id: $0)
                        .catchToEffect(WikiAction.itemDataLoaded)
                },
                (0 ... 10).map {
                    environment.pokemonService
                        .fetchType(id: $0)
                        .catchToEffect(WikiAction.typeDataLoaded)
                }]
                .flatMap { $0 }
            )
        case let .pokemonDataLoaded(response):
            switch response {
            case let .success(result):
                let pokemon = result.convertToModel()
                state.pokemons.append(pokemon)
            case .failure: break /// 에러 처리
            }
            return .none
        case let .tapPokemonLikeButton(index, isLiked):
            guard let oldPokemon = state.pokemons[id: index] else { return .none }
            state.pokemons[id: index] = Pokemon(
                id: oldPokemon.id,
                name: oldPokemon.name,
                stat: oldPokemon.stat,
                image: oldPokemon.image,
                type: oldPokemon.type,
                isLiked: isLiked,
                isPremium: oldPokemon.isPremium
            )
            return .none
        case let .itemDataLoaded(response):
            switch response {
            case let .success(result):
                let item = result.convertToModel()
                state.items.append(item)
            case .failure: break /// 에러 처리
            }
            return .none
        case let .typeDataLoaded(response):
            switch response {
            case let .success(result):
                let type = result.convertToModel()
                state.types.append(type)
            case .failure: break /// 에러 처리
            }
            return .none
        case let .user(.changeUserStatus(membership)):
            return Effect(value: .refresh(true))
        case let .refresh(isRefresh):
            state.refresh = isRefresh
            return .none
        }
    }
)
