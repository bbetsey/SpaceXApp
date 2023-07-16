//
//  NetworkService.swift
//  SpaceXApp
//
//  Created by Антон Тропин on 16.07.23.
//

import Foundation
import RxSwift


enum NetworkError: Error {
	case invalidURL
	case noData
	case decodingError
}




final class NetworkService {

	static let shared = NetworkService()

	private let session: URLSession
	private let baseURL: String = "https://api.spacexdata.com/v3/"

	private init() {
		session = URLSession.shared
	}

	func get<T: Decodable>(dataType: T.Type, apiRequest: APIRequest) -> Single<T> {
		return Single<T>.create { single in
			guard let url = URL(string: self.baseURL) else {
				single(.failure(NetworkError.invalidURL))
				return Disposables.create()
			}

			let request = apiRequest.request(with: url)

			let task = self.session.dataTask(with: request) { data, response, error in

				if let error = error {
					single(.failure(error))
					return
				}

				guard let data = data else {
					single(.failure(NetworkError.noData))
					return
				}

				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let dataResponse = try decoder.decode(T.self, from: data)
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
