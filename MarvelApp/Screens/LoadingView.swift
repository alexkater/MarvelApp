//
//  LoadingView.swift
//  MarvelApp
//
//  Created by Alejandro Arjonilla Garcia on 12/10/21.
//

import SwiftUI

struct LoadingView: View {

    var body: some View {
        HStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
    }
}
