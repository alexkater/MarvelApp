//
//  DetailTests.swift
//  MarvelAppTests
//
//  Created by Alejandro Arjonilla Garcia on 13/10/21.
//

import XCTest
import ComposableArchitecture
import SnapshotTesting

@testable import MarvelApp

class DetailTests: XCTestCase {

    // MARK: - Unit Tests

    func testToggle() {

        let store = TestStore(
            initialState: DetailState(
                character: .mock(with: 2)
            ),
            reducer: detailReducer,
            environment: DetailEnvironment()
        )

        store.assert(
            .send(.add) {
                $0.isOnSquad = true
            },
            .send(.showRemoveAlert) {
                $0.alert = AlertState(
                    title: TextState("Delete"),
                    message: TextState("Are you sure you want to remove this hero from your Squad?"),
                    primaryButton: .default(
                        TextState("Confirm"),
                        action: .send(.alertConfirmTapped)
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
            },
            .send(.alertCancelTapped) {
                $0.alert = nil
            },
            .send(.showRemoveAlert) {
                $0.alert = AlertState(
                    title: TextState("Delete"),
                    message: TextState("Are you sure you want to remove this hero from your Squad?"),
                    primaryButton: .default(
                        TextState("Confirm"),
                        action: .send(.alertConfirmTapped)
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
            },
            .send(.alertConfirmTapped) {
                $0.isOnSquad = false
                $0.alert = nil
            }
        )
    }

    // MARK: - Snapshot
    func testSnapshotDetail() {
        verify(state: .init(character: .mock(with: 1)))
    }

    func testSnapshotDetailAddedToSquad() {
        verify(
            state: .init(
                character: .mock(with: 1),
                isOnSquad: true
            )
        )
    }

    private func verify(
        state: DetailState,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let store = Store(
            initialState: state,
            reducer: detailReducer,
            environment: DetailEnvironment()
        )
        let rootView = DetailView(store: store)
        assertSnapshot(
            matching: rootView,
            as: .image(layout: .fixed(width: 375, height: 900)),
            file: file,
            testName: testName,
            line: line
        )
    }
}
