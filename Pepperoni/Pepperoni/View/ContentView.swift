//
//  ContentView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = Router.shared
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            HomeView()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .home:
                        HomeView()
                    case .animeList:
                        AnimeListView()
                    case .animeSearch:
                        AnimeSearchView()
                    case .characterList(let anime):
                        CharacterListView(anime: anime)
                    case .characterDetail(let character):
                        CharacterDetailView(character: character)
                    case .learningStart(let quote):
                        LearningStartView(quote: quote)
                    case .learning(let quote):
                        LearningView(quote: quote)
                    case .result(let quote):
                        ResultView(quote: quote)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
