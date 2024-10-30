//
//  AnimeListView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI
import SwiftData

struct AnimeListView: View {
    @Query var allAnimes: [Anime]
    
    var body: some View {
        // - MARK: 애니 리스트
        List(allAnimes, id: \.id) { anime in
            Button {
                Router.shared.navigate(to: .characterList(anime: anime))
            } label: {
                Text(anime.title)
            }
        }
    }
}

#Preview {
    AnimeListView()
}
