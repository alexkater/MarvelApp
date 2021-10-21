//
//  CharacterResponseMock.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import Foundation

extension CharacterResponse {

    static func mock(
        count: Int = 0,
        limit: Int = 0,
        offset: Int = 0,
        results: [Character] = [],
        total: Int = 1400
    ) -> CharacterResponse {
        .init(
            count: count,
            limit: limit,
            offset: offset,
            results: results,
            total: total
        )
    }
}

extension Character {

    static func mock(with id: Int) -> Self {
        mock(with: id, isOnSquad: false)
    }

    static func mock(with id: Int, isOnSquad: Bool) -> Self {
        .init(
            id: id,
            name: "Super hero \(id)",
            description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!",
            imageURL: .imageURLMock,
            isOnSquad: isOnSquad
        )
    }
}

extension URL {
    static var imageURLMock: URL {
        URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/d/50/50febb79985ee/standard_fantastic.jpg")!
    }
}
