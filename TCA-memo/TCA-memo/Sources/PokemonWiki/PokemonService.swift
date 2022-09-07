//
//  PokemonService.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/06.
//

import Combine
import Foundation

import Alamofire
import ComposableArchitecture

public enum NetworkError: Error {
    case serverError
    case parsingError
}

final class PokemonService {
    private let alamofire: Session

    public init(sesseion: Session) {
        alamofire = sesseion
    }

    func fetchPokemon(id: Int) -> AnyPublisher<PokemonResponseModel, Error> {
        let url = "https://pokeapi.co/api/v2/pokemon/\(id)"

        return alamofire
            .request(
                url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200 ..< 300)
            .publishData()
            .tryMap { response -> PokemonResponseModel in
                switch response.result {
                case let .success(data):
                    do {
                        return try
                            JSONDecoder().decode(PokemonResponseModel.self, from: data)
                    } catch {
                        throw NetworkError.parsingError
                    }
                case .failure:
                    throw NetworkError.serverError
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchItem(id: Int) -> AnyPublisher<ItemResponseModel, Error> {
        let url = "https://pokeapi.co/api/v2/item/\(id)"

        return alamofire
            .request(
                url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200 ..< 300)
            .publishData()
            .tryMap { response -> ItemResponseModel in
                switch response.result {
                case let .success(data):
                    do {
                        return try
                            JSONDecoder().decode(ItemResponseModel.self, from: data)
                    } catch {
                        throw NetworkError.parsingError
                    }
                case .failure:
                    throw NetworkError.serverError
                }
            }
            .eraseToAnyPublisher()
    }

    func fetchType(id: Int) -> AnyPublisher<TypeResponseModel, Error> {
        let url = "https://pokeapi.co/api/v2/type/\(id)"

        return alamofire
            .request(
                url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default
            )
            .validate(statusCode: 200 ..< 300)
            .publishData()
            .tryMap { response -> TypeResponseModel in
                switch response.result {
                case let .success(data):
                    do {
                        return try
                            JSONDecoder().decode(TypeResponseModel.self, from: data)
                    } catch {
                        throw NetworkError.parsingError
                    }
                case .failure:
                    throw NetworkError.serverError
                }
            }
            .eraseToAnyPublisher()
    }
}
