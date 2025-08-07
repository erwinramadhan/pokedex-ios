//
//  GetFavoritesPokemonUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 08/08/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol GetFavoritesPokemonUseCaseProtocol {
    func execute() -> Observable<[RealmFavoritePokemonObject]>
}

class GetFavoritesPokemonUseCaseImpl: GetFavoritesPokemonUseCaseProtocol {
    
    let repository: UserRepositoryProtocol
    let disposeBag = DisposeBag()
    var pokemonList = PublishRelay<[PokemonListItem]>()
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> RxSwift.Observable<[RealmFavoritePokemonObject]> {
        return repository.getListFavoritePokemon()
    }
    
    
}
