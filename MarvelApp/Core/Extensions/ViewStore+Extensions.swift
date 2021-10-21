//
//  ViewStore+Extensions.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import ComposableArchitecture

extension Store where State: Equatable {
    var view: ViewStore<State, Action> {
        return ViewStore(self)
    }
}
