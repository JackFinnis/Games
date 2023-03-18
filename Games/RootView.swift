//
//  RootView.swift
//  Games
//
//  Created by Jack Finnis on 03/02/2023.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            SwingingSticksView()
            GameOfLife()
        }
        .tabViewStyle(.page)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
