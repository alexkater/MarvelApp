//
//  Image+Extensions.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 9/10/21.
//

import SwiftUI

extension Image {
    func rounded(with size: CGFloat = 48) -> some View {
        self
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }

    static var heroListItemPlaceholder = Image("hero-list-item-placeholder")
    static var marvelLogo = Image("marvel-logo")
}
