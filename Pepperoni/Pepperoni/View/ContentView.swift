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
                            .navigationBarBackButtonHidden(true)
                    case .animeSearch:
                        AnimeSearchView()
                            .navigationBarBackButtonHidden(true)
                    case .characterList(let anime):
                        CharacterListView(anime: anime)
                            .navigationBarBackButtonHidden(true)
                    case .characterDetail(let character):
                        CharacterDetailView(character: character)
                            .navigationBarBackButtonHidden(true)
                    case .learningStart(let quote):
                        LearningStartView(quote: quote)
                    case .learning(let quote):
                        LearningView(quote: quote)
                    case .result(let quote):
                        ResultView(quote: quote)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
