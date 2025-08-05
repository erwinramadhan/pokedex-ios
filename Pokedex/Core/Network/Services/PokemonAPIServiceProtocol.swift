//
//  PokemonAPIServiceProtocol.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import RxSwift

protocol PokemonAPIServiceProtocol {
    func fetchPokemonList(limit: Int, offset: Int) -> Single<PokemonListResponseDTO>
    func fetchPokemonDetail(id: Int) -> Single<PokemonDetailResponseDTO>
    func fetchPokemonSpecies(id: Int) -> Single<PokemonSpeciesResponseDTO>
}
