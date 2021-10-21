//
//  HeroItemView.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 12/10/21.
//

import SwiftUI
import ComposableArchitecture
import URLImage

struct HeroItemView: View {
    let character: Character

    var body: some View {
        Group {
            HStack {
                URLImage(character.imageURL,
                         identifier: character.imageURL.absoluteString,
                         empty: { Image.heroListItemPlaceholder.rounded() },
                         inProgress: { _ in  Image.heroListItemPlaceholder.rounded() },
                         failure: { _,_  in EmptyView() },
                         content: { $0.rounded() })
                    .frame(width: 48, height: 48)
                Text(character.name)
                    .font(Font.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(Font.system(.body))
                    .foregroundColor(Color(UIColor.white.withAlphaComponent(0.2)))
                    .padding(.trailing, 16)
            }
            .padding(.leading, 16)
            .frame(height: 80)
            .background(Color.marvelGreyMedium)
        }
        .cornerRadius(16)
    }
}

struct HeroItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            HeroItemView(character: .mock(with: 1))
        }.listStyle(PlainListStyle())
    }
}
