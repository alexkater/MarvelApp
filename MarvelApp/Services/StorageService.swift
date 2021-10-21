//
//  StorageService.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 12/10/21.
//

import Foundation.NSUserDefaults

/// Implementing as it is for simplicity, for a production app DB should be implemented
protocol StorageServiceProtocol {

    func update(chars: [Character])
    func retrieveChars() -> [Character]
}

final class StorageService: StorageServiceProtocol {

    private let defaults = UserDefaults.standard

    enum StorageKey: String {
        case characters
    }

    func update(chars: [Character]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(chars) else {
            print("there is a problem saving characters")
            return
        }

        defaults.set(data, forKey: StorageKey.characters.rawValue)
    }

    func retrieveChars() -> [Character] {
        let decoder = JSONDecoder()
        guard
            let data = defaults.data(forKey: StorageKey.characters.rawValue),
            let characters = try? decoder.decode([Character].self, from: data) else {
                print("there is a problem retrieving your data")
                return []
            }
        return characters
    }
}
