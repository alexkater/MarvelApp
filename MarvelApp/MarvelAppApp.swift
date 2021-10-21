//
//  MarvelAppApp.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 21/10/21.
//
import SwiftUI
import ComposableArchitecture

@main
struct MarvelAppApp: App {
    // TODO: DI needed here for a proper DI
    let apiService = ApiService(config: Config())
    let storageService = StorageService()

    var body: some Scene {
        WindowGroup {
            HeroListView(
                store: Store(
                    initialState: HeroListState(),
                    reducer: heroListReducer,
                    environment: HeroListEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        apiService: apiService,
                        storageService: storageService
                    )
                )
            )
        }
    }
}
