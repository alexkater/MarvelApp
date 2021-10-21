//
//  CharacterResponseTest.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 11/10/21.
//

import XCTest
@testable import MarvelApp

class CharacterResponseTest: XCTestCase {

    func testCharacterResponse() throws {
        let json = """
         {
             "code": 200,
             "status": "Ok",
             "copyright": "© 2021 MARVEL",
             "attributionText": "Data provided by Marvel. © 2021 MARVEL",
             "etag": "bb5c111ea88daf75d25e5a2f8dde1cea8bb2305f",
             "data": {
                 "offset": 0,
                 "limit": 10,
                 "total": 1559,
                 "count": 10,
                 "results": [{
                     "id": 1011334,
                     "name": "3-D Man",
                     "description": "",
                     "modified": "2014-04-29T14:18:17-0400",
                     "thumbnail": {
                         "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
                         "extension": "jpg"
                     },
                     "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011334",
                 }]
             }
         }
        """
        let response = CharacterResponse.decodeSafely(from: json)

        XCTAssertEqual(response?.count, 10)
        XCTAssertEqual(response?.limit, 10)
        XCTAssertEqual(response?.offset, 0)
        XCTAssertEqual(response?.results.count, 1)
        XCTAssertEqual(response?.total, 1559)

        let character = response?.results.first

        XCTAssertEqual(character?.id, 1011334)
        XCTAssertEqual(character?.name, "3-D Man")
        XCTAssertEqual(character?.description, "")
        XCTAssertEqual(character?.imageURL, URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784/standard_fantastic.jpg"))
    }

    func testCodingCharacter() throws {
        let character = Character(
            id: 1,
            name: "3-D Man",
            description: "description",
            imageURL: URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784/standard_fantastic.jpg")!
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let jsonData = try? encoder.encode(character) else {
            throw DecodingError.decodingError
        }

        let jsonString = "{\n  \"isOnSquad\" : false,\n  \"id\" : 1,\n  \"name\" : \"3-D Man\",\n  \"description\" : \"description\",\n  \"thumbnail\" : {\n    \"path\" : \"http:\\/\\/i.annihil.us\\/u\\/prod\\/marvel\\/i\\/mg\\/c\\/e0\\/535fecbbb9784\",\n    \"extension\" : \"jpg\"\n  }\n}"
        let expectedString = String.init(data: jsonData, encoding: .utf8)
        XCTAssertEqual(expectedString, jsonString)
    }
}
