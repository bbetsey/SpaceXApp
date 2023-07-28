//
//  NetworkService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation
import RxSwift

final class NetworkService {

    private let decoder: JSONDecoder
    private let baseURL = "https://api.spacexdata.com/v3/"
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()

    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func get<T: Decodable>(dataType: T.Type, apiRequest: APIRequest) -> Single<T> {
        .create { single in
            guard let url = URL(string: self.baseURL) else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let request = apiRequest.request(with: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    single(.failure(NetworkError.noData))
                    return
                }
                do {
                    let dataResponse = try self.decoder.decode(T.self, from: data)
                    single(.success(dataResponse))
                } catch let error {
                    single(.failure(error))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
