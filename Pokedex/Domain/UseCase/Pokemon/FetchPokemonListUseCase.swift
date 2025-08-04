//
//  PokemonUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RxSwift

protocol FetchPokemonListUseCase {
    func execute(limit: Int, offset: Int) -> Single<[PokemonListItem]>
}

class DefaultFetchPokemonListUseCase: FetchPokemonListUseCase {
    private let repository: PokemonRepository

    init(repository: PokemonRepository) {
        self.repository = repository
    }

    func execute(limit: Int, offset: Int = 0) -> Single<[PokemonListItem]> {
        return repository.fetchPokemonList(limit: limit, offset: offset)
    }
}
