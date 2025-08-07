//
//  FetchPokemonDetailUseCase.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 05/08/25.
//

import RxSwift

protocol FetchPokemonDetailUseCaseProtocol {
    func execute(id: Int) -> Single<PokemonDetail>
}

class FetchPokemonDetailUseCaseImpl: FetchPokemonDetailUseCaseProtocol {
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) -> Single<PokemonDetail> {
        let detailS = repository.fetchPokemonDetail(id: id)
        let speciesS = repository.fetchPokemonSpecies(id: id)
        
        let safeDetailObs = detailS
            .catch { error in
                print("Detail error: \(error)")
                return .just(PokemonDetailResponseDTO.empty)
            }

        let safeSpeciesObs = speciesS
            .catch { error in
                print("Species error: \(error)")
                return .just(PokemonSpeciesResponseDTO.empty)
            }
        
        let zipped = Single.zip(safeDetailObs, safeSpeciesObs)

        return zipped.map { detailDTO, speciesDTO in
            var model = detailDTO.toDomain()
            model.description = speciesDTO.firstEnglishFlavorText()
            model.color = speciesDTO.color.name
            return model
        }
        
    }
}
