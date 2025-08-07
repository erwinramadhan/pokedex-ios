//
//  AddFavoritePokemonUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 07/08/25.
//

import Foundation
import RxSwift

protocol AddFavoritePokemonUseCaseProtocol {
    func execute(pokemon: PokemonDetail) -> Observable<Void>
}

class AddFavoritePokemonUseCaseImpl: AddFavoritePokemonUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    
    init (repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pokemon: PokemonDetail) -> Observable<Void> {
        return repository.addFavoritePokemon(pokemon: pokemon)
    }
    
}
