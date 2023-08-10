//
//  NetworkService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation
import RxSwift

final class NetworkService {

    private let decoderWithShortDate: JSONDecoder
    private let decoderWithLongDate: JSONDecoder
    private let baseURL = "https://api.spacexdata.com/v3/"
    private var dateFormatterLong: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    private var dateFormatterShort: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    init() {
        decoderWithShortDate = JSONDecoder()
        decoderWithShortDate.keyDecodingStrategy = .convertFromSnakeCase
        decoderWithShortDate.dateDecodingStrategy = .formatted(dateFormatterShort)

        decoderWithLongDate = JSONDecoder()
        decoderWithLongDate.keyDecodingStrategy = .convertFromSnakeCase
        decoderWithLongDate.dateDecodingStrategy = .formatted(dateFormatterLong)
    }

    func fetchRocket() -> Single<[Rocket]> {
        fetchData(dataType: [Rocket].self, apiRequest: RocketsRequest(), decoder: decoderWithShortDate)
    }

    func fetchLaunch(rocketID: String) -> Single<[Launch]> {
        fetchData(dataType: [Launch].self, apiRequest: LaunchRequest(rocketID: rocketID), decoder: decoderWithLongDate)
    }
}

// MARK: - Private Methods
private extension NetworkService {
    func fetchData<T: Decodable>(dataType: T.Type, apiRequest: APIRequest, decoder: JSONDecoder) -> Single<T> {
        .create { [weak self] single in
            guard let self = self, let url = URL(string: self.baseURL) else {
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
