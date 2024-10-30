//
//  AnimeDetailView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/30/24.
//

import SwiftUI

struct CharacterListView: View {
    let anime: Anime

    var body: some View {
        VStack {
            Text(anime.title)
                .font(.largeTitle)
                .padding()
            
            List(anime.characters, id: \.id) { character in
                Button {
                    Router.shared.navigate(to: .characterDetail(character: character))
                } label: {
                    Text(character.name)
                }
            }

            if anime.favorite {
                Text("⭐️")
            }

            Spacer()
        }
        .navigationTitle(anime.title)
    }
}

#Preview {
    CharacterListView(anime: Anime(title: "hihi"))
}
