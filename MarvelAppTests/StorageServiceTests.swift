//
//  StorageServiceTests.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

import XCTest
@testable import MarvelApp

class StorageServiceTests: XCTestCase {

    func testSaveAndRetrieve() {
        let storageService = StorageService()
        storageService.update(chars: [.mock(with: 1)])

        XCTAssertNotNil(UserDefaults.standard.data(forKey: StorageService.StorageKey.characters.rawValue))

        XCTAssertEqual(storageService.retrieveChars(), [.mock(with: 1)])
    }
}
