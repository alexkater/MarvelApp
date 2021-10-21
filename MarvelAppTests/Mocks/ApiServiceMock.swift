//
//  ApiServiceMock.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

@testable import MarvelApp
import Combine

final class ApiServiceMock: ApiServiceProtocol {

    var getCharactersMock: AnyPublisher<CharacterResponse, Error>?

    func getCharacters(with offset: Int) -> AnyPublisher<CharacterResponse, Error> {
        getCharactersMock ?? Empty().eraseToAnyPublisher()
    }
}
