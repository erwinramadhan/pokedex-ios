//
//  AppDIContainer.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import Foundation
import RealmSwift

final class AppDIContainer {
    
    // MARK: - Database Realm
    lazy var realm = try? Realm()
    
    // MARK: - Network
    lazy var apiClient: APIClientProtocol = APIClientImpl()

    // MARK: - Services
    lazy var pokemonApiService: PokemonAPIServiceProtocol = PokemonAPIServiceImpl(apiClient: apiClient)

    // MARK: - Remote Repositories
    lazy var pokemonRepository: PokemonRepositoryProtocol = PokemonRepositoryImpl(apiService: pokemonApiService)
    
    lazy var localDataSource: UserLocalDataSourceProtocol = RealmAuthLocalDataSource(realm: realm)
    
    // MARK: - Local Repositories
    lazy var userRepository: UserRepositoryProtocol = UserRepositoryImpl(
//        realm: realm
        localDataSource: localDataSource
    )

    // MARK: - Use Cases
    lazy var fetchPokemonListUseCase: FetchPokemonListUseCaseProtocol = FetchPokemonListUseCaseImpl(repository: pokemonRepository)
    lazy var fetchPokemonDetailUseCase: FetchPokemonDetailUseCaseProtocol = FetchPokemonDetailUseCaseImpl(repository: pokemonRepository)
    lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCaseImpl(repository: userRepository)
    lazy var registerUserUseCase: RegisterUserUseCaseProtocol = RegisterUserUseCaseImpl(repository: userRepository)
    lazy var getCurrentUserUseCase: GetCurrentUserUseCaseProtocol = GetCurrentUserUseCaseImpl(repository: userRepository)
    lazy var addFavoritePokemonUseCase: AddFavoritePokemonUseCaseProtocol = AddFavoritePokemonUseCaseImpl(repository: userRepository)
    lazy var removeFavoritePokemonUseCase: RemoveFavoritePokemonUseCaseProtocol = RemoveFavoritePokemonUseCaseImpl(repository: userRepository)
    lazy var isFavoritePokemonUseCase: IsFavoritePokemonUseCaseProtocol = IsFavoritePokemonUseCaseImpl(repository: userRepository)
    lazy var getListFavoritesPokemonUseCase: GetFavoritesPokemonUseCaseProtocol = GetFavoritesPokemonUseCaseImpl(repository: userRepository)

    // MARK: - Use Cases Factory
    func makeGettCurrentUserUseCase() -> GetCurrentUserUseCaseProtocol {
        return getCurrentUserUseCase
    }
        
    // MARK: - ViewModel Factory
    func makeHomeViewModel() -> HomeViewModel { return HomeViewModel(fetchPokemonListUseCase: fetchPokemonListUseCase) }
    func makeProfileViewModel() -> ProfileViewModel { return ProfileViewModel(getFavoritesPokemonUseCase: getListFavoritesPokemonUseCase,
                                                                              getCurrentUserUseCase: getCurrentUserUseCase) }
    func makeLoginViewModel() -> LoginViewModel { return LoginViewModel(loginUseCase: loginUseCase) }
    func makeRegisterViewModel() -> RegisterViewModel { return RegisterViewModel(registerUserUseCase: registerUserUseCase) }
    func makeDetailViewModel(selectedPokemon: PokemonListItem) -> DetailViewModel {
        return DetailViewModel(selectedPokemon: selectedPokemon,
                               fetchPokemonDetailUseCase: fetchPokemonDetailUseCase,
                               addFavoritePokemonUseCase: addFavoritePokemonUseCase,
                               removeFavoritePokemonUseCase: removeFavoritePokemonUseCase,
                               isFavoritePokemonUseCase: isFavoritePokemonUseCase)
    }
    
}
