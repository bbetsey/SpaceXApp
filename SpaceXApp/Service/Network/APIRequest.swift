//
//  APIRequest.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 16.07.23.
//

import Foundation

enum RequestType: String {
    case GET
    case POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        return URLRequest(url: url)
    }
}
