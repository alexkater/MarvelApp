//
//  StorageServiceMock.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

@testable import MarvelApp

final class StorageServiceMock: StorageServiceProtocol {

    var savedChars: [Character] = []

    func update(chars: [Character]) {
        savedChars.append(contentsOf: chars)
    }

    func retrieveChars() -> [Character] {
        savedChars
    }
}
