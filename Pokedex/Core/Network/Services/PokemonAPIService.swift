//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import RxSwift

final class PokemonAPIService: PokemonAPIServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchPokemonList(limit: Int, offset: Int = 0) -> Single<PokemonListResponseDTO> {
        let endpoint = PokemonEndpoint.list(limit: limit, offset: offset)
        return apiClient.request(endpoint, responseType: PokemonListResponseDTO.self)
    }
}
