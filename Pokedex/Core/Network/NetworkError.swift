//
//  NetworkError.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case serverError(code: Int)
    case unknown(Error)
}
