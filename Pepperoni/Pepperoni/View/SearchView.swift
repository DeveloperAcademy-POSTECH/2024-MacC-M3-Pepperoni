//
//  SearchView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        Button("애니ID: 111") {
            Router.shared.navigate(to: .learning(id: "111"))
        }
        .navigationTitle("Search")
    }
}

#Preview {
    SearchView()
}
