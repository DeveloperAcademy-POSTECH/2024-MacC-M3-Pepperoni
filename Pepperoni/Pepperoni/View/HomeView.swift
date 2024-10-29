//
//  MainView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            Button("검색") {
                Router.shared.navigate(to: .search)
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
}
