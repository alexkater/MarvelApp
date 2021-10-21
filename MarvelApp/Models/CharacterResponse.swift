//
//  CharacterResponse.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 9/10/21.
//

import Foundation

enum DecodingError: Error {
    case decodingError
}

// MARK: - Welcome
struct CharacterResponse: Equatable, Decodable {
    let count: Int
    let limit: Int
    let offset: Int
    let results: [Character]
    let total: Int

    init(
        count: Int,
        limit: Int,
        offset: Int,
        results: [Character],
        total: Int
    ) {
        self.count = count
        self.limit = limit
        self.offset = offset
        self.results = results
        self.total = total
    }

    init(from decoder: Decoder) throws {
        let dataContainer = try decoder
            .container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .data)

        count =     try dataContainer.decode(Int.self, forKey: .count)
        limit =     try dataContainer.decode(Int.self, forKey: .limit)
        offset =    try dataContainer.decode(Int.self, forKey: .offset)
        results =   try dataContainer.decode([Character].self, forKey: .results)
        total =     try dataContainer.decode(Int.self, forKey: .total)
    }

    enum CodingKeys: String, CodingKey {
        case data, count, limit, offset, results, total
    }
}
