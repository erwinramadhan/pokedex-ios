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
    private let isSuccessAddToFavorite = PublishRelay<Bool>()
    private let isSuccessRemoveToFavorite = PublishRelay<Bool>()
    private let isFavoritePokemon = BehaviorRelay<Bool>(value: false)
    private let removeFromFavoriteErrorMessage = PublishRelay<String>()
    private let addToFavoriteErrorMessage = PublishRelay<String>()
    private let isFavoritePokemonErrorMessage = PublishRelay<String>()
    
    private var pokemonDetailForFavorite: PokemonDetail?
    
    // MARK: - Dependencies
    private let selectedPokemon: PokemonListItem
    private let fetchPokemonDetailUseCase: FetchPokemonDetailUseCaseProtocol
    private let addFavoritePokemonUseCase: AddFavoritePokemonUseCaseProtocol
    private let removeFavoritePokemonUseCase: RemoveFavoritePokemonUseCaseProtocol
    private let isFavoritePokemonUseCase: IsFavoritePokemonUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(selectedPokemon: PokemonListItem,
         fetchPokemonDetailUseCase: FetchPokemonDetailUseCaseProtocol,
         addFavoritePokemonUseCase: AddFavoritePokemonUseCaseProtocol,
         removeFavoritePokemonUseCase: RemoveFavoritePokemonUseCaseProtocol,
         isFavoritePokemonUseCase: IsFavoritePokemonUseCaseProtocol) {
        self.selectedPokemon = selectedPokemon
        self.fetchPokemonDetailUseCase = fetchPokemonDetailUseCase
        self.addFavoritePokemonUseCase = addFavoritePokemonUseCase
        self.removeFavoritePokemonUseCase = removeFavoritePokemonUseCase
        self.isFavoritePokemonUseCase = isFavoritePokemonUseCase
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
    
    var isFavoritePokemonObserve: Observable<Bool> {
        return isFavoritePokemon.asObservable()
    }
    
    // MARK: - Public Methods
    func fetchPokemonDetail() {
        isLoading.accept(true)
        fetchPokemonDetailUseCase.execute(id: selectedPokemon.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.pokemon.accept($0)
                self?.pokemonDetailForFavorite = $0
                self?.isLoading.accept(false)
                self?.getIsFavoritePokemon()
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func addFavorite() {
        guard let pokemonDetailForFavorite else { return }
        addFavoritePokemonUseCase.execute(pokemon: pokemonDetailForFavorite)
            .subscribe(
                onNext: { [weak self] in
                    self?.isSuccessAddToFavorite.accept(true)
                    self?.getIsFavoritePokemon()
                },
                onError: { [weak self] error in
                    self?.isSuccessAddToFavorite.accept(true)
                    self?.getIsFavoritePokemon()
                    self?.addToFavoriteErrorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeFavorite() {
        guard let pokemonDetailForFavorite else { return }
        removeFavoritePokemonUseCase.execute(pokemon: pokemonDetailForFavorite)
            .subscribe(
                onNext: { [weak self] in
                    self?.isSuccessRemoveToFavorite.accept(true)
                    self?.getIsFavoritePokemon()
                },
                onError: { [weak self] error in
                    self?.isSuccessRemoveToFavorite.accept(true)
                    self?.getIsFavoritePokemon()
                    self?.removeFromFavoriteErrorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func getIsFavoritePokemon() {
        guard let pokemonDetailForFavorite else { return }
        isFavoritePokemonUseCase.execute(pokemonId: pokemonDetailForFavorite.id)
            .subscribe(
                onNext: { [weak self] isFavorite in
                    self?.isFavoritePokemon.accept(isFavorite)
                },
                onError: { [weak self] error in
                    self?.isFavoritePokemon.accept(false)
                    self?.isFavoritePokemonErrorMessage.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
