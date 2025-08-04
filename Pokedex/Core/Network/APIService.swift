//
//  APIService.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 04/08/25.
//

import Alamofire
import RxSwift

protocol APIServiceProtocol {
    func request<T: Decodable>(_ url: URLConvertible) -> Single<T>
}

class APIService: APIServiceProtocol {
    func request<T: Decodable>(_ url: URLConvertible) -> Single<T> {
        return Single.create { single in
            AF.request(url)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decoded):
                        single(.success(decoded))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }
}
