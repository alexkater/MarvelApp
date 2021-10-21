//
//  Config.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

import Foundation

protocol ConfigProtocol {
    var timestamp: String { get }
    var apiKey: String { get }
    var hash: String { get }
}

struct Config: ConfigProtocol {
    let timestamp: String
    let apiKey: String
    let hash: String

    init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dictionary = NSDictionary(contentsOfFile: path),
           let timestamp = (dictionary["timestamp"] as? String),
           let apiKey = (dictionary["apiKey"] as? String),
           let hash = (dictionary["hash"] as? String)
        {
            self.timestamp = timestamp
            self.apiKey = apiKey
            self.hash = hash
        } else {
            // This should raise a BIG concern / fatal error to block the release
            print("Cannot found configuration")
            self.timestamp = ""
            self.apiKey = ""
            self.hash = ""
        }
    }
}
