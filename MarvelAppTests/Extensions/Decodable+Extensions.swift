//
//  Decodable+Extensions.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import Foundation

extension Decodable {

    static func decodeSafely(from string: String) -> Self? {
        guard let data = string.data(using: .utf8) else { return nil }
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(Self.self, from: data)
        } catch {
            print("Failed to decode \"\(Self.self)\" from JSON data.")
            return nil
        }
    }
}
