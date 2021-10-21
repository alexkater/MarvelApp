//
//  ApiService.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 9/10/21.
//

import Combine
import Foundation

protocol ApiServiceProtocol {
    func getCharacters(with offset: Int) -> AnyPublisher<CharacterResponse, Error>
}

extension ApiServiceProtocol {
    func getCharacters() -> AnyPublisher<CharacterResponse, Error> {
        getCharacters(with: 0)
    }
}

enum APIRouter {

    case getCharacters(timestamp: String, apiKey: String, hash: String, offset: Int)

    var urlString: String {
        switch self {
        case .getCharacters(let timestamp, let apiKey, let hash, let offset):
            return "https://gateway.marvel.com/v1/public/characters?ts=\(timestamp)&apikey=\(apiKey)&hash=\(hash)&offset=\(offset)&orderBy=-modified"
        }
    }
}

class ApiService: ApiServiceProtocol {
    var cancellable = Set<AnyCancellable>()
    let config: ConfigProtocol

    init(config: ConfigProtocol) {
        self.config = config
    }

    func getCharacters(with offset: Int) -> AnyPublisher<CharacterResponse, Error> {
        let url = URL(
            string: APIRouter.getCharacters(
                timestamp: config.timestamp,
                apiKey: config.apiKey,
                hash: config.hash,
                offset: offset
            ).urlString
        )!

        return URLSession.shared
             .dataTaskPublisher(for: url)
             .tryMap() { element -> Data in
                 guard let httpResponse = element.response as? HTTPURLResponse,
                       httpResponse.statusCode == 200 else {
                           throw URLError(.badServerResponse)
                       }
                 return element.data
             }
             .decode(type: CharacterResponse.self, decoder: JSONDecoder())
             .eraseToAnyPublisher()
    }
}
