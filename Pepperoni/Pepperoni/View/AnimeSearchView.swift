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
    @Environment(\.presentationMode) var presentationMode
    
    private var filteredAnimes: [Anime] {
        animeArray.filter { !$0.title.isEmpty && searchText.isEmpty == false && $0.title.contains(searchText) }
    }
    
    // 임시 더미 배열
    let animeArray: [Anime] = [
        Anime(
            title: "하이큐",
            characters: [
                Character(name: "오이카와 토오루", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "하이볼",
            characters: [
                Character(name: "오이카와 토오루", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "하하하",
            characters: [
                Character(name: "오이카와 토오루", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "원피스",
            characters: [
                Character(name: "빈스모크 상디", favorite: false)
            ],
            favorite: true
        ),
        Anime(
            title: "최애의 아이",
            characters: [
                Character(name: "호시노 아이", favorite: false)
            ],
            favorite: false
        ),
        Anime(
            title: "주술회전",
            characters: [
                Character(name: "고죠 사토루", favorite: false)
            ],
            favorite: false
        )
    ]

    var body: some View {
        VStack {
            SearchBar(searchText: $searchText)
        
            if !filteredAnimes.isEmpty {
                List(filteredAnimes, id: \.id) { anime in
                    Button {
                        Router.shared.navigate(to: .characterList(anime: anime))
                    } label: {
                        HStack {
                            Text(anime.title)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
    }
}

#Preview {
    AnimeSearchView()
}
