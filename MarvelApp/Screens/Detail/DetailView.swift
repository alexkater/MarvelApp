//
//  DetailView.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 8/10/21.
//

import SwiftUI
import URLImage
import ComposableArchitecture

struct DetailView: View {

    let store: Store<DetailState, DetailAction>

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16.0) {
                WithViewStore(self.store.scope(state: { $0.character.imageURL })) { viewStore in
                    URLImage(
                        viewStore.state,
                        identifier: viewStore.absoluteString,
                        empty: {
                            Image.heroListItemPlaceholder.resizable().aspectRatio(1, contentMode: .fit)
                        },
                        inProgress: { _ in
                            Image.heroListItemPlaceholder.resizable().aspectRatio(1, contentMode: .fit)
                        },
                        failure: { _, _  in EmptyView() },
                        content: { $0.resizable().aspectRatio(1, contentMode: .fit) }
                    )
                        .animation(.easeInOut, value: 1)
                        .transition(.opacity)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                }
                WithViewStore(self.store) { viewStore in
                    Text(viewStore.character.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                    Button(viewStore.isOnSquad ? "🔥  Fire from Squad" : "💪  Recruit to Squad") {
                        viewStore.send(viewStore.isOnSquad ? .showRemoveAlert: .add)
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(viewStore.isOnSquad ? nil : Color.redLight)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.redLight, lineWidth: 3)
                    )
                    .padding(.horizontal, 16.0)
                    Text(viewStore.character.description)
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                }
            }
        }
        .alert(
            self.store.scope(state: \.alert),
            dismiss: .alertCancelTapped
        )
        .background(Color.backgroundColor)
        .ignoresSafeArea(.all, edges: [.top, .bottom])
    }
}

struct DetailView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            DetailView(
                store: Store(
                    initialState: DetailState(
                        character: .mock(with: 1)
                    ),
                    reducer: .empty,
                    environment: DetailEnvironment()
                )
            )
            DetailView(
                store: Store(
                    initialState: DetailState(
                        character: .mock(with: 2)
                    ),
                    reducer: .empty,
                    environment: DetailEnvironment()
                )
            )
        }
    }
}
