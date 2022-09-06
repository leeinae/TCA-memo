//
//  BookmarkFeature.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/23.
//

import ComposableArchitecture

// MARK: - State

struct WikiState: Equatable {
    var pokemons: IdentifiedArrayOf<Pokemon> = []
    var items: IdentifiedArrayOf<Item> = []
    var types: IdentifiedArrayOf<TypeModel> = []
}

// MARK: - Action

enum WikiAction {
    case viewDidLoad
    case pokemonDataLoaded(Result<PokemonResponseModel, Error>)
    case itemDataLoaded(Result<ItemResponseModel, Error>)
    case typeDataLoaded(Result<TypeResponseModel, Error>)
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
> { state, action, environment in
    switch action {
    case .viewDidLoad:
        return Effect.merge(
            environment.pokemonService
                .fetchPokemon(id: 1)
                .catchToEffect(WikiAction.pokemonDataLoaded),
            environment.pokemonService
                .fetchItem(id: 1)
                .catchToEffect(WikiAction.itemDataLoaded),
            environment.pokemonService
                .fetchType(id: 1)
                .catchToEffect(WikiAction.typeDataLoaded)
        )
    case let .pokemonDataLoaded(response):
        switch response {
        case let .success(result):
            let pokemon = result.convertToModel()
            state.pokemons.append(pokemon)
        case .failure: break /// 에러 처리
        }
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
    }
}
