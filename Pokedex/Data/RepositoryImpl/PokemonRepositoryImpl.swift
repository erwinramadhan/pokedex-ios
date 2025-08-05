//
//  PokemonRepositoryImpl.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RxSwift

final class DefaultPokemonRepository: PokemonRepository {
    private let apiService: PokemonAPIServiceProtocol

    init(apiService: PokemonAPIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchPokemonList(limit: Int, offset: Int) -> Single<[PokemonListItem]> {
        return apiService.fetchPokemonList(limit: limit, offset: offset)
            .map { dto in
                dto.results.map { $0.toDomain() }
            }
    }
    
    func fetchPokemonDetail(id: Int) -> Single<PokemonDetailResponseDTO> {
        return apiService.fetchPokemonDetail(id: id)
    }
    
    func fetchPokemonSpecies(id: Int) -> Single<PokemonSpeciesResponseDTO> {
        return apiService.fetchPokemonSpecies(id: id)
    }
}
