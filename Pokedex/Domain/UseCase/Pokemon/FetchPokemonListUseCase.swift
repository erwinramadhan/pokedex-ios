//
//  PokemonUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RxSwift

protocol FetchPokemonListUseCaseProtocol {
    func execute(limit: Int, offset: Int) -> Single<[PokemonListItem]>
}

class FetchPokemonListUseCaseImpl: FetchPokemonListUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int, offset: Int = 0) -> Single<[PokemonListItem]> {
        return repository.fetchPokemonList(limit: limit, offset: offset)
    }
}
