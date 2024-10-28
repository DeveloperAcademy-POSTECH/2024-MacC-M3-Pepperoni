//
//  ContentView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/22/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var animes: [Anime]
    @State private var isDataLoaded = false

    var body: some View {
        NavigationView {
            if isDataLoaded {
                List(animes) { anime in
                    NavigationLink(destination: AnimeDetailView(anime: anime)) {
                        VStack(alignment: .leading) {
                            Text(anime.title)
                                .font(.headline)
                            Text(anime.season)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Anime List")
            } else {
                ProgressView("Loading Data...")
            }
        }
        .onAppear {
            if isFirstLaunch() {
                JSONUtils.saveAnimeCharacterData(modelContext: modelContext)
                JSONUtils.saveAnimeQuotesData(modelContext: modelContext)
                isDataLoaded = true
            } else {
                isDataLoaded = true
            }
        }
    }

    private func isFirstLaunch() -> Bool {
        let key = "isFirstLaunch"
        let isFirst = !UserDefaults.standard.bool(forKey: key)
        if isFirst {
            UserDefaults.standard.set(true, forKey: key)
        }
        return isFirst
    }
}

#Preview {
    ContentView()
}
