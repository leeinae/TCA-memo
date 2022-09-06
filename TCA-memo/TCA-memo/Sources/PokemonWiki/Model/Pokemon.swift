//
//  PokemonModel.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/06.
//

import Foundation

struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let stat: String?
    let image: String?
    let type: String?
}
