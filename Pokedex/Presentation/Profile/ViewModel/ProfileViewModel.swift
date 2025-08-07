//
//  ProfileViewModel.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: AnyObject {
    
    private let favoritesPokemon = PublishRelay<[PokemonListItem]>()
    private let profile = PublishRelay<User>()
    
    private let getFavoritesPokemonUseCase: GetFavoritesPokemonUseCaseProtocol
    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(getFavoritesPokemonUseCase: GetFavoritesPokemonUseCaseProtocol,
         getCurrentUserUseCase: GetCurrentUserUseCaseProtocol) {
        self.getFavoritesPokemonUseCase = getFavoritesPokemonUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }
    
    var favoritesPokemonObservable: Observable<[PokemonListItem]> {
        return favoritesPokemon.asObservable()
    }
    
    var profileObservable: Observable<User> {
        return profile.asObservable()
    }
    
    func getFavoritesPokemon() {
        getFavoritesPokemonUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] pokemons in
                    self?.favoritesPokemon.accept(pokemons.map{ return $0.toFavoritePokemon() })
                },
                onError: { [weak self] error in
                    print("error", error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getProfile() {
        getCurrentUserUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] profile in
                    if let profile {
                        self?.profile.accept(profile)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
