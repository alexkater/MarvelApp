//
//  Character.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import Foundation

struct Character: Hashable, Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let imageURL: URL
    private let thumbnailPath: String
    private let thumbnailExtension: String
    var isOnSquad: Bool

    init(
        id: Int,
        name: String,
        description: String,
        imageURL: URL,
        isOnSquad: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.isOnSquad = isOnSquad

        let strings = imageURL.absoluteString.components(separatedBy: "/standard_fantastic.")
        thumbnailPath = strings.first ?? ""
        thumbnailExtension = strings.last ?? ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id =            try container.decode(Int.self, forKey: .id)
        name =          try container.decode(String.self, forKey: .name)
        description =   try container.decode(String.self, forKey: .description)
        isOnSquad =     (try? container.decode(Bool.self, forKey: .isOnSquad)) ?? false

        let thumbnailContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        thumbnailPath =          try thumbnailContainer.decode(String.self, forKey: .path)
        thumbnailExtension =     try thumbnailContainer.decode(String.self, forKey: .extension)
        let imageURLString = "\(thumbnailPath)/standard_fantastic.\(thumbnailExtension)"

        guard let url = URL(string: imageURLString) ?? URL(string: "https://bit.ly/3oLi3gh") else {
            throw DecodingError.decodingError
        }

        imageURL = url
    }

    func encode(to encoder: Encoder) throws {
        var baseContainer = encoder.container(keyedBy: CodingKeys.self)
        try baseContainer.encode(id, forKey: .id)
        try baseContainer.encode(name, forKey: .name)
        try baseContainer.encode(description, forKey: .description)
        try baseContainer.encode(isOnSquad, forKey: .isOnSquad)

        let dataEncoder = baseContainer.superEncoder(forKey: .thumbnail)

        var userContainer = dataEncoder.container(keyedBy: CodingKeys.self)
        try userContainer.encodeIfPresent(thumbnailPath, forKey: .path)
        try userContainer.encodeIfPresent(thumbnailExtension, forKey: .extension)
    }

    enum CodingKeys: String, CodingKey {
        case  id, name, description, thumbnail, path, `extension`, isOnSquad
    }
}
