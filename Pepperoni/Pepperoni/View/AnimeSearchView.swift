//
//  SearchView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 10/28/24.
//

import SwiftUI
import SwiftData

struct AnimeSearchView: View {
    @Query var allAnimes: [Anime]
    @State private var searchText: String = ""

    var filteredAnimes: [Anime] {
        // 사용자가 입력한 검색어를 기준으로 필터링
        if searchText.isEmpty {
            return allAnimes
        } else {
            return allAnimes.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack {
            // - MARK: 검색창
            TextField("애니를 검색해보세요", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // - MARK: 애니 리스트
            List(filteredAnimes, id: \.id) { anime in
                Button {
                    Router.shared.navigate(to: .characterList(anime: anime))
                } label: {
                    Text(anime.title)
                }
            }
        }
        .padding()
    }
}

#Preview {
    AnimeSearchView()
}
