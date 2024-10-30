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
                    case .animeDetail(let anime):
                        AnimeDetailView(anime: anime)
                    case .learning(let id):
                        LearningView(animeId: id)
                    case .result(let score):
                        ResultView(score: score)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
