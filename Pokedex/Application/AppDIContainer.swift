//
//  AppDIContainer.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    lazy var apiClient: APIClientProtocol = DefaultAPIClient()

    // MARK: - Services
    lazy var pokemonApiService: PokemonAPIService = PokemonAPIService(apiClient: apiClient)

    // MARK: - Repositories
    lazy var pokemonRepository: PokemonRepository = DefaultPokemonRepository(apiService: pokemonApiService)

    // MARK: - Use Cases
    lazy var fetchPokemonListUseCase: FetchPokemonListUseCase = DefaultFetchPokemonListUseCase(repository: pokemonRepository)

    // MARK: - ViewModel Factory
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(fetchUseCase: fetchPokemonListUseCase)
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel()
    }
    
    
}
