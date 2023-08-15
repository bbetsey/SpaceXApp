//
//  NetworkService.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import RxSwift

final class NetworkService {

    private let decoderWithShortDate: JSONDecoder
    private let decoderWithLongDate: JSONDecoder
    private let baseURL = "https://api.spacexdata.com/v3/"
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    init() {
        decoderWithShortDate = JSONDecoder()
        decoderWithShortDate.keyDecodingStrategy = .convertFromSnakeCase
        decoderWithShortDate.dateDecodingStrategy = .formatted(dateFormatter)

        decoderWithLongDate = JSONDecoder()
        decoderWithLongDate.keyDecodingStrategy = .convertFromSnakeCase
        decoderWithLongDate.dateDecodingStrategy = .iso8601
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
        guard let url = URL(string: baseURL) else {
            return Single.error(NetworkError.invalidURL)
        }
        let request = apiRequest.request(with: url)
        return URLSession.shared.rx.data(request: request)
            .map { return try decoder.decode(T.self, from: $0) }
            .asSingle()
    }
}
