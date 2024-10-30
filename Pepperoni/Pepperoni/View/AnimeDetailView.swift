//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: Anime

    var body: some View {
        VStack {
            Text(anime.title)
                .font(.largeTitle)
                .padding()

            if anime.favorite {
                Text("⭐️")
            }

            Spacer()
        }
        .navigationTitle(anime.title)
    }
}

#Preview {
    AnimeDetailView(anime: Anime(title: "hihi"))
}
