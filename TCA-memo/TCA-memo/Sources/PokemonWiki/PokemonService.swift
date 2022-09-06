//
//  PokemonService.swift
//  TCA-memo
//
//  Created by inae Lee on 2022/09/06.
//

import Combine

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
}
