//
//  APIClient.swift
//  Pokedex
//
//  Created by Erwin Ramadhan Edwar Putra on 03/08/25.
//

import Alamofire
import RxSwift

final class DefaultAPIClient: APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> Single<T> {
        return Single.create { single in
            let afRequest = AF.request(
                endpoint.url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: HTTPHeaders(endpoint.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        single(.failure(NetworkError.serverError(code: statusCode)))
                    } else {
                        single(.failure(NetworkError.unknown(error)))
                    }
                }
            }

            return Disposables.create {
                afRequest.cancel()
            }
        }
    }
}

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> Single<T>
}

