//
//  HeroListTests.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

import XCTest
import ComposableArchitecture
import Combine
import SwiftUI
import SnapshotTesting

@testable import MarvelApp

class HeroListTests: XCTestCase {
    let scheduler = DispatchQueue.test

    // MARK: - Unit Tests

    func testLoadHerosSucceed() {
        let apiService = ApiServiceMock()
        let storageService = StorageServiceMock()

        let store = TestStore(
            initialState: HeroListState(),
            reducer: heroListReducer,
            environment: HeroListEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                apiService: apiService,
                selecterCharacter: nil,
                storageService: storageService
            )
        )

        storageService.savedChars = [.mock(with: 1, isOnSquad: true)]
        let response = CharacterResponse.mock(results: [.mock(with: 2)])
        apiService.getCharactersMock = Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        store.assert(
            .send(.loadNextPage) {
                $0.characters = [.mock(with: 1, isOnSquad: true)]
                $0.isFirstLoad = false
                $0.isLoading = true
                $0.offset = 0
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.herosLoaded(response: response), {
                $0.characters = [.mock(with: 1, isOnSquad: true), .mock(with: 2)]
                $0.maxItems = 1400
                $0.isLoading = false
                $0.isListFull = false
            }),
            .send(.selectHero(.mock(with: 2))) {
                $0.detailState = DetailState(character: .mock(with: 2))
            },
            .send(.details(.add)) {
                $0.characters = [.mock(with: 1, isOnSquad: true), .mock(with: 2, isOnSquad: true)]
                $0.detailState =  DetailState(character: .mock(with: 2), isOnSquad: true)
            },
            .send(.details(.alertConfirmTapped)) {
                $0.characters = [.mock(with: 1, isOnSquad: true), .mock(with: 2, isOnSquad: false)]
                $0.detailState =  DetailState(character: .mock(with: 2))
            }
        )
    }

    func testLoadHerosError() {
        let apiService = ApiServiceMock()
        let storageService = StorageServiceMock()

        let store = TestStore(
            initialState: HeroListState(
                characters: []
            ),
            reducer: heroListReducer,
            environment: HeroListEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                apiService: apiService,
                selecterCharacter: nil,
                storageService: storageService
            )
        )

        storageService.savedChars = [.mock(with: 1)]
        apiService.getCharactersMock = Fail(error: DecodingError.decodingError).eraseToAnyPublisher()

        store.assert(
            .send(.loadNextPage) {
                $0.characters = [.mock(with: 1)]
                $0.isFirstLoad = false
                $0.isLoading = true
                $0.offset = 0
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.herosFinishedWithError, {
                $0.isLoading = false
            }),
            .receive(.showRemoveAlert) {
                $0.alert = AlertState(
                    title: TextState("Ups!"),
                    message: TextState("Someething went wrong, do you want to try again?"),
                    primaryButton: .default(
                        TextState("Confirm"),
                        action: .send(.alertConfirmTapped)
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
            },
            .send(.alertCancelTapped)
        )
    }

    func testLoadHerosErrorRetry() {
        let apiService = ApiServiceMock()
        let storageService = StorageServiceMock()

        let store = TestStore(
            initialState: HeroListState(
                characters: []
            ),
            reducer: heroListReducer,
            environment: HeroListEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                apiService: apiService,
                selecterCharacter: nil,
                storageService: storageService
            )
        )

        storageService.savedChars = [.mock(with: 1)]
        apiService.getCharactersMock = Fail(error: DecodingError.decodingError).eraseToAnyPublisher()
        let response = CharacterResponse.mock(results: [.mock(with: 2)])

        store.assert(
            .send(.loadNextPage) {
                $0.characters = [.mock(with: 1)]
                $0.isFirstLoad = false
                $0.isLoading = true
                $0.offset = 0
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.herosFinishedWithError, {
                $0.isLoading = false
            }),
            .receive(.showRemoveAlert) {
                $0.alert = AlertState(
                    title: TextState("Ups!"),
                    message: TextState("Someething went wrong, do you want to try again?"),
                    primaryButton: .default(
                        TextState("Confirm"),
                        action: .send(.alertConfirmTapped)
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
            },
            .do {
                apiService.getCharactersMock = Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            .send(.alertConfirmTapped) {
                $0.alert = nil
            },
            .receive(.loadNextPage) {
                $0.isLoading = true
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.herosLoaded(response: response), {
                $0.characters = [.mock(with: 1), .mock(with: 2)]
                $0.maxItems = 1400
                $0.isLoading = false
                $0.isListFull = false
            })
        )
    }

    // MARK: - Snapshot

    func testSnapshotNoData() {
        verify(state: HeroListState())
    }

    func testSnapshotDataLoaded() {
        verify(
            state: HeroListState(
                characters: IdentifiedArrayOf(uniqueElements: (1...20).map(Character.mock(with:)))
            )
        )
    }

    func testSnapshotDataLoadedWithSquadFilled() {
        verify(
            state: HeroListState(
                characters: IdentifiedArrayOf(uniqueElements: (1...20).map {
                    Character.mock(with: $0, isOnSquad: true)
                })
            )
        )
    }

    private func verify(
        state: HeroListState,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let store = Store(
            initialState: state,
            reducer: heroListReducer,
            environment: HeroListEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                apiService: ApiServiceMock(),
                selecterCharacter: nil,
                storageService: StorageServiceMock()
            )
        )
        let rootView = HeroListView(store: store)
        assertSnapshot(
            matching: rootView,
            as: .image(layout: .fixed(width: 375, height: 900)),
            file: file,
            testName: testName,
            line: line
        )
    }
}
