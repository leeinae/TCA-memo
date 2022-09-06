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
}

// MARK: - Action

enum WikiAction {
    case viewDidLoad
    case dataLoaded(Result<PokemonResponseModel, Error>)
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
        return environment.pokemonService.fetchPokemon()
            .catchToEffect(WikiAction.dataLoaded)
    case let .dataLoaded(response):
        switch response {
        case let .success(result):
            let pokemon = result.convertToModel()
            state.pokemons.append(pokemon)
            print(state.pokemons)
        case .failure: break /// 에러 처리
        }
        return .none
    }
}
