//
//  PokemonRemoteDataSource.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RxSwift

protocol PokemonRemoteDataSourceProtocol {
    func fetchPokemonList(limit: Int) -> Single<[PokemonListItem]>
}

class PokemonRemoteDataSource: PokemonRemoteDataSourceProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchPokemonList(limit: Int) -> Single<[PokemonListItem]> {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)"
        return apiService.request(url)
            .map { (dto: PokemonListResponseDTO) in
                dto.results.map { $0.toDomain() }
            }
    }
}

