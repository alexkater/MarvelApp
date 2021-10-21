//
//  HeroListHeaderView.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 8/10/21.
//

import SwiftUI
import ComposableArchitecture
import URLImage

struct HeroListHeaderView: View {
    let store: Store<HeroListState, HeroListAction>

    var body: some View {
        WithViewStore(store.scope(state: \.charactersInSquad.isEmpty)) { viewStore in
            viewStore.state ? nil :
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Squad")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                        .frame(height: 25)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEachStore(
                                self.store.scope(
                                    state: \.charactersInSquad,
                                    action: HeroListAction.selectChar(id:action:)
                                )
                            ) { store in
                                WithViewStore(store) { viewStore in
                                    Button(action: { self.store.view.send(.selectHero(viewStore.state)) }) {
                                        VStack {
                                            URLImage(viewStore.imageURL,
                                                     identifier: viewStore.imageURL.absoluteString,
                                                     empty: { Image.heroListItemPlaceholder.rounded() },
                                                     inProgress: { _ in  Image.heroListItemPlaceholder.rounded() },
                                                     failure: { _,_  in EmptyView() },
                                                     content: { $0.rounded(with: 72) })
                                            Text(viewStore.name)
                                                .font(Font.system(.footnote))
                                                .foregroundColor(.white)
                                                .frame(height: 36, alignment: .center)
                                                .lineLimit(2)
                                                .lineSpacing(0)
                                                .frame(width: 72)
                                        }
                                    }
                                }
                            }
                            .lineSpacing(8)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 157)
        .listRowBackground(Color.backgroundColor)
        .listRowSeparator(.hidden)
    }
}

struct HeroListHeaderView_Previews: PreviewProvider {

    static var previews: some View {
        HeroListHeaderView(
            store: Store(
                initialState: HeroListState(
                    characters: IdentifiedArrayOf<Character>(uniqueElements: (1...5).map(Character.mock(with:)))
                ),
                reducer: heroListReducer,
                environment: HeroListEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    apiService: ApiService(config: Config()),
                    storageService: StorageService()
                )
            )
        )
    }
}
