//
//  HeroList+Composable.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 14/10/21.
//

import Foundation
import ComposableArchitecture

struct HeroListState: Equatable {
    var isFirstLoad = true
    var isListFull = false
    var isLoading = false
    var offset = 0
    var maxItems = 0
    var characters: IdentifiedArrayOf<Character> = []
    var charactersInSquad: IdentifiedArrayOf<Character> {
        characters.filter(\.isOnSquad)
    }
    var detailState: DetailState?
    var alert: AlertState<HeroListAction>?
}

struct HeroListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var apiService: ApiServiceProtocol
    var selecterCharacter: Character?
    var storageService: StorageServiceProtocol
}

enum HeroListAction: Equatable {
    case loadNextPage
    case herosLoaded(response: CharacterResponse)
    case herosFinishedWithError
    case selectChar(id: Int, action: DetailAction)
    case detailDismissed
    case selectHero(Character)
    case details(DetailAction)
    case showRemoveAlert
    case alertConfirmTapped
    case alertCancelTapped
}

let heroListReducer = Reducer<HeroListState, HeroListAction, HeroListEnvironment>
    .combine(
        detailReducer
            .optional()
            .pullback(
                state: \HeroListState.detailState,
                action: /HeroListAction.details,
                environment: { _ in DetailEnvironment() }
            ),
        Reducer<HeroListState, HeroListAction, HeroListEnvironment> { state, action, environment in
            switch action {
            case .loadNextPage:
                struct GetCharactersHashable: Hashable {}
                if state.isFirstLoad {
                    let dbCharacters = environment.storageService.retrieveChars()
                    state.characters = IdentifiedArrayOf(uniqueElements: dbCharacters)
                    state.isFirstLoad = false
                }
                state.isLoading = true
                if state.offset + 20 >= state.maxItems {
                    state.offset = state.maxItems - state.offset
                } else {
                    state.offset += 20
                }
                return environment.apiService.getCharacters(with: state.offset)
                    .receive(on: environment.mainQueue)
                    .catchToEffect { result in
                        switch result {
                        case .success(let response):
                            return HeroListAction.herosLoaded(response: response)
                        case .failure(let error):
                            return HeroListAction.herosFinishedWithError
                        }
                    }.cancellable(id: GetCharactersHashable(), cancelInFlight: true)

            case .herosLoaded(let response):
                state.characters = IdentifiedArrayOf(uniqueElements: state.characters + response.results.filter { !state.characters.contains($0) })
                state.isLoading = false
                state.maxItems = response.total
                state.isListFull = state.offset == state.maxItems
                return .none

            case .herosFinishedWithError:
                state.isLoading = false
                return Effect(value: .showRemoveAlert)

            case .detailDismissed:
                state.detailState = nil
                return .none

            case .selectHero(let character):
                state.detailState = DetailState(character: character, isOnSquad: character.isOnSquad)
                return .none

            case .details(let detailAction):
                guard let selectedHero = state.detailState?.character else { return .none }
                state.characters[id: selectedHero.id]?.isOnSquad.toggle()
                environment.storageService.update(chars: state.charactersInSquad.elements)
                return .none

            case .showRemoveAlert:
                state.alert = AlertState(
                    title: TextState("Ups!"),
                    message: TextState("Someething went wrong, do you want to try again?"),
                    primaryButton: .default(
                        TextState("Confirm"),
                        action: .send(.alertConfirmTapped)
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
                return .none

            case .alertConfirmTapped:
                state.alert = nil
                return Effect(value: .loadNextPage)

            default: return .none
            }
        }
    ).debug()
