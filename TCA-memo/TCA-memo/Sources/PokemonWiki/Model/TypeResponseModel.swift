//
//  TypeResponseModel.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/07.
//

import Foundation

// MARK: - TypeResponseModel

struct TypeResponseModel: Codable {
    let id: Int
    let name: String
    let damageRelations: DamageRelations
    let gameIndices: [TypeGameIndex]
    let generation: Generation
    let moveDamageClass: Generation
    let moves: [Generation]
    let names: [Name]
    let pastDamageRelations: [JSONAny]
    let pokemon: [TypePokemon]

    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
        case gameIndices = "game_indices"
        case generation, id
        case moveDamageClass = "move_damage_class"
        case moves, name, names
        case pastDamageRelations = "past_damage_relations"
        case pokemon
    }

    func convertToModel() -> TypeModel {
        .init(
            id: id,
            name: name,
            pokomons: pokemon[0 ... 3].map(\.pokemon.name)
        )
    }
}

// MARK: - TypePokemon

struct TypePokemon: Codable {
    let pokemon: PokemonInfo
    let slot: Int
}

// MARK: - PokemonInfo

struct PokemonInfo: Codable {
    let name: String
    let url: String
}

// MARK: - DamageRelations

struct DamageRelations: Codable {
    let doubleDamageFrom: [Generation]
    let doubleDamageTo, halfDamageFrom: [JSONAny]
    let halfDamageTo, noDamageFrom, noDamageTo: [Generation]

    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}

// MARK: - Generation

struct Generation: Codable {
    let name: String
    let url: String
}

// MARK: - TypeGameIndex

struct TypeGameIndex: Codable {
    let gameIndex: Int
    let generation: Generation

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case generation
    }
}
