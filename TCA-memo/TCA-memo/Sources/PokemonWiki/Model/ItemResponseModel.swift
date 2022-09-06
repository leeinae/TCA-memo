//
//  ItemResponseModel.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/07.
//

import Foundation

// MARK: - ItemResponseModel

struct ItemResponseModel: Codable {
    let id: Int
    let attributes: [Category]
    let babyTriggerFor: String?
    let category: Category
    let cost: Int
    let effectEntries: [EffectEntry]
    let flavorTextEntries: [FlavorTextEntry]
    let flingEffect, flingPower: String?
    let gameIndices: [ItemGameIndex]
    let heldByPokemon: [JSONAny]
    let machines: [JSONAny]
    let name: String
    let names: [Name]
    let sprites: ItemSprites

    enum CodingKeys: String, CodingKey {
        case attributes
        case babyTriggerFor = "baby_trigger_for"
        case category, cost
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case flingEffect = "fling_effect"
        case flingPower = "fling_power"
        case gameIndices = "game_indices"
        case heldByPokemon = "held_by_pokemon"
        case id, machines, name, names, sprites
    }

    func convertToModel() -> Item {
        .init(id: id, image: sprites.spritesDefault)
    }
}

// MARK: - Category

struct Category: Codable {
    let name: String
    let url: String
}

// MARK: - EffectEntry

struct EffectEntry: Codable {
    let effect: String
    let language: Category
    let shortEffect: String

    enum CodingKeys: String, CodingKey {
        case effect, language
        case shortEffect = "short_effect"
    }
}

// MARK: - FlavorTextEntry

struct FlavorTextEntry: Codable {
    let language: Category
    let text: String
    let versionGroup: Category

    enum CodingKeys: String, CodingKey {
        case language, text
        case versionGroup = "version_group"
    }
}

// MARK: - GameIndex

struct ItemGameIndex: Codable {
    let gameIndex: Int
    let generation: Category

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case generation
    }
}

// MARK: - Name

struct Name: Codable {
    let language: Category
    let name: String
}

// MARK: - Sprites

struct ItemSprites: Codable {
    let spritesDefault: String

    enum CodingKeys: String, CodingKey {
        case spritesDefault = "default"
    }
}
