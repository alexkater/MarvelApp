//
//  HeroListView.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 8/10/21.
//

import SwiftUI
import CombineSchedulers
import ComposableArchitecture
import URLImage
import Combine
import IdentifiedCollections
import URLImageStore

struct HeroListView: View {
    let store: Store<HeroListState, HeroListAction>

    init(store: Store<HeroListState, HeroListAction>) {
        self.store = store
        UITableView.appearance().backgroundColor = UIColor.backgroundColor
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor
    }

    var body: some View {
        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
        NavigationView {
            ZStack(alignment: .center) {
                WithViewStore(
                    store.scope(state: \.detailState),
                    removeDuplicates: { $0?.character == $1?.character }
                ) { viewStore in
                    NavigationLink(
                        "",
                        destination: IfLetStore(
                            self.store.scope(state: \.detailState, action: HeroListAction.details),
                            then: DetailView.init(store:)
                        ),
                        isActive: viewStore.binding(
                            get: { $0 != nil },
                            send: .detailDismissed
                        )
                    )
                }
                List {
                    HeroListHeaderView(
                        store: self.store
                    )
                    ForEachStore(
                        self.store.scope(
                            state: \.characters,
                            action: HeroListAction.selectChar(id:action:)
                        )
                    ) { store in
                        WithViewStore(store) { viewStore in
                            ZStack {
                                Button(action: { self.store.view.send(.selectHero(viewStore.state)) }) {
                                    HeroItemView(character: viewStore.state)

                                }
                            }
                            .listRowBackground(Color.backgroundColor)
                        }
                    }
                    .listRowSeparator(.hidden)
                    WithViewStore(self.store.scope(state: \.isListFull)) { viewStore in
                        viewStore.state ? nil : LoadingView()
                            .onAppear {
                                viewStore.send(.loadNextPage)
                            }
                    }.listRowSeparator(.hidden)
                }
                .background(Color.backgroundColor)
                .listStyle(PlainListStyle())
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image.marvelLogo
                }
            }
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(
            self.store.scope(state: \.alert),
            dismiss: .alertCancelTapped
        )
        .environment(\.urlImageService, urlImageService)
    }
}

struct HeroListView_Previews: PreviewProvider {

    static var previews: some View {
        HeroListView(
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
        HeroListView(
            store: Store(
                initialState: HeroListState(
                    characters: IdentifiedArrayOf<Character>(
                        uniqueElements: [
                            .mock(with: 1, isOnSquad: true),
                            .mock(with: 2, isOnSquad: true),
                            .mock(with: 3),
                            .mock(with: 4),
                            .mock(with: 5),
                            .mock(with: 6),
                            .mock(with: 7),
                            .mock(with: 8),
                            .mock(with: 9)
                        ]
                    )
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
