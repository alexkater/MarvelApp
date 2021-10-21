//
//  Detail+Composable.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import Foundation
import ComposableArchitecture

struct DetailState: Equatable {
    let character: Character
    var isOnSquad: Bool = false
    var alert: AlertState<DetailAction>?
}

enum DetailAction: Equatable {
    case add
    case showRemoveAlert
    case alertConfirmTapped
    case alertCancelTapped
}

struct DetailEnvironment {}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in

    switch action {
    case .alertCancelTapped:
        state.alert = nil
        return .none

    case .showRemoveAlert:
        state.alert = AlertState(
            title: TextState("Delete"),
            message: TextState("Are you sure you want to remove this hero from your Squad?"),
            primaryButton: .default(
                TextState("Confirm"),
                action: .send(.alertConfirmTapped)
            ),
            secondaryButton: .cancel(TextState("Cancel"))
        )
        return .none

    case .alertConfirmTapped:
        state.alert = nil
        state.isOnSquad.toggle()

    case .add:
        state.isOnSquad.toggle()

    }

    return .none
}
