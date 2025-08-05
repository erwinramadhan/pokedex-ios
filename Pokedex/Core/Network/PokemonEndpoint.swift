//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Alamofire

enum PokemonEndpoint: APIEndpoint {
    case list(limit: Int, offset: Int = 0)
    case detail(id: Int)
    case species(id: Int)

    var baseURL: String { "https://pokeapi.co/api/v2" }

    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let id):
            return "/pokemon/\(id)"
        case .species(let id):
            return "/pokemon-species/\(id)"
        }
    }

    var method: HTTPMethod { .get }

    var parameters: [String : Any]? {
        switch self {
        case .list(let limit, let offset):
            return ["limit": limit, "offset": offset]
        case .detail, .species:
            return [:]
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
