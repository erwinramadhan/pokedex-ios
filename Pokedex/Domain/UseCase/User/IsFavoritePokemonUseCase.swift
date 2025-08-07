//
//  IsFavoritePokemonUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 07/08/25.
//

import Foundation
import RxSwift

protocol IsFavoritePokemonUseCaseProtocol {
    func execute(pokemonId: Int) -> Observable<Bool>
}

class IsFavoritePokemonUseCaseImpl: IsFavoritePokemonUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    
    init (repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(pokemonId: Int) -> Observable<Bool> {
        return repository.isPokemonInFavorite(pokemonId: pokemonId)
    }
    
}
