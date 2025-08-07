//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    private let pokemon = PublishRelay<PokemonDetail>()
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let errorMessage = PublishRelay<String>()
    
    // MARK: - Dependencies
    private let selectedPokemon: PokemonListItem
    private let fetchPokemonDetailUseCase: FetchPokemonDetailUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(selectedPokemon: PokemonListItem,
         fetchPokemonDetailUseCase: FetchPokemonDetailUseCaseProtocol) {
        self.selectedPokemon = selectedPokemon
        self.fetchPokemonDetailUseCase = fetchPokemonDetailUseCase
    }
    
    // MARK: - Observable Properties
    var pokemonObserve: Observable<PokemonDetail> {
        return pokemon.asObservable()
    }
    
    var isLoadingObserve: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    var errorMessageObserve: Observable<String> {
        return errorMessage.asObservable()
    }
    
    // MARK: - Public Methods
    func fetchPokemonDetail() {
        isLoading.accept(true)
        fetchPokemonDetailUseCase.execute(id: selectedPokemon.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.pokemon.accept($0)
                self?.isLoading.accept(false)
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
}
