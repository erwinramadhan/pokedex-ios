//
//  HomeViewModel.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: AnyObject {
    private let pokemons = BehaviorRelay<[PokemonListItem]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let errorMessage = PublishRelay<String>()
    let searchValue = BehaviorRelay<String>(value: "")
    
    private var offset = 0
    private let limit = 10
    private var hasMoreData = true
    
    // MARK: - Dependencies
    private let fetchPokemonListUseCase: FetchPokemonListUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(fetchPokemonListUseCase: FetchPokemonListUseCaseProtocol) {
        self.fetchPokemonListUseCase = fetchPokemonListUseCase
    }
    
    
    // MARK: Observeable Properties
    var pokemonObserve: Observable<[PokemonListItem]> {
        return Observable.combineLatest(pokemons, searchValue)
            .map { pokemons, query in
                guard !query.isEmpty else { return pokemons }
                return pokemons.filter { $0.name.lowercased().contains(query.lowercased()) }
            }
    }
    
    var isLoadingObserve: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    // MARK: - Public Methods
    func fetchPokemonList() {
        isLoading.accept(true)
        
        fetchPokemonListUseCase.execute(limit: limit, offset: offset)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.pokemons.accept(result)
                self?.isLoading.accept(false)
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNextPage() {
        guard !isLoading.value && hasMoreData && searchValue.value.isEmpty else { return }
        
        self.offset += self.limit
        fetchPokemonListUseCase.execute(limit: limit, offset: offset)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                
                let current = self.pokemons.value
                let newData = current + result
                self.pokemons.accept(newData)
                
                self.hasMoreData = !result.isEmpty
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
