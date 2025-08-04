//
//  PokemonRepository.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import RxSwift

protocol PokemonRepository {
    func fetchPokemonList(limit: Int, offset: Int) -> Single<[PokemonListItem]>
}
