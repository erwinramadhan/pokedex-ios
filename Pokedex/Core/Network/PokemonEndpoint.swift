//
//  PokemonAPIService.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Alamofire

enum PokemonEndpoint: APIEndpoint {
    case list(limit: Int, offset: Int = 0)

    var baseURL: String { "https://pokeapi.co/api/v2" }

    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        }
    }

    var method: HTTPMethod { .get }

    var parameters: [String : Any]? {
        switch self {
        case .list(let limit, let offset):
            return ["limit": limit, "offset": offset]
        }
    }

    var headers: [String : String]? {
        return nil
    }
}
